Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:19620 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992445AbXDCWgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2007 18:36:15 -0400
Message-ID: <46137FE9.8080105@linux.intel.com>
Date: Wed, 04 Apr 2007 03:37:29 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mabbas@linux.intel.com
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com> <20070326165254.97753ad8.randy.dunlap@oracle.com>
In-Reply-To: <20070326165254.97753ad8.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modified patch at the end

Randy Dunlap wrote:
>
>
> I'm seeing an email/patch problem here.  The lines above should be
> 3 lines only, not 6 that I'm seeing.  Maybe it's my mail client,
> but it usually works for me, so possibly yours is splitting lines
> when it should not.
>
>   
>> @TSF timer value from firmware/hardware. Currently,
>>  	 * this is only used for IBSS mode debugging and, as such, is not a
>>  	 * required function. */
>> +
>> +	/* Configure ht parameters 
>>     
>
> Line above ends with space.  :(
>
> What is "ht"?
>
>   
>>  	return cw - 1;
>>  }
>>  
>> +/* call low level driver with 11n params as it was recieved
>>     
>
>                                                       received
>   
>> +   from the AP
>> +*/   
>>     
>
> Line above ends with spaces.
>
> Kernel long comment style is:
>
> /*
>  * call low-level driver with 11n params as they were received
>  * from the AP
>  */
>
>   
>>  				     struct ieee80211_if_sta *ifsta,
>>  				     u8 *wmm_param, size_t wmm_param_len)
>> @@ -584,6 +648,15 @@ static void ieee80211_send_assoc(struct 
>>  		*pos++ = 0;
>>  	}
>>  
>> +	/* if low level driver support 11n fill in 11n IE */
>>     
>
>                                supports 11n,
>
>   
>> +	if (ht_enabled && ifsta->ht_enabled && local->ops->get_ht_capab) {
>> +		pos = skb_put(skb, sizeof(struct ieee80211_ht_capability)+2);
>> +		*pos++ = WLAN_EID_HT_CAPABILITY;
>> +		*pos++ = sizeof(struct ieee80211_ht_capability);
>> +		ieee80211_fill_ht_ie(dev, 
>> +				     (struct ieee80211_ht_capability *)pos);
>> +	}
>> +		
>>  	kfree(ifsta->assocreq_ies);
>>  	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
>>  	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_ATOMIC);
>>     
>
>   
On 3/27/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
On 3/27/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
 > On 3/26/07, mohamed <mabbas@linux.intel.com> wrote:
 >
 > > +/* Get 11n capabilties from low level driver */
 > > +static void ieee80211_fill_ht_ie(struct net_device *dev,
 > > + struct ieee80211_ht_capability *ht_capab)
 > > +{
 > > + int rc;
 > > + struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 > > +
 > > + if (!local->ops->get_ht_capab){
 > > + memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
 > > + return;
 > > + }
 > > +
 > > + rc = local->ops->get_ht_capab(local_to_hw(local), ht_capab);
 > > + if (!rc) {
 > > + memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
 > > + return;
 > > + }
 > >
 > > + ht_capab->capabilitiesInfo = (__le16) cpu_to_le16(
 > > + ht_capab->capabilitiesInfo);
 > > + ht_capab->extended_ht_capability_info = (__le16) cpu_to_le16(
 > > + ht_capab->extended_ht_capability_info);
 > > + ht_capab->tx_BF_capability_info = (__le32) cpu_to_le32(
 > > + ht_capab->tx_BF_capability_info);
 > > +}
 > > +
 >
 > We should memset to 0 the entire ht_capab to regardless as its coming
 > from skb_put() otherwise we'll get random data there if we don't set
 > it and we sure as hell don't want to just transmit that :) Also
 > ieee80211_send_assoc() is already checking for
 > local->ops->get_ht_capab so lets just do a BUG_ON here to capture
 > cases where someone else didn't do the proper checking. So how about
 > instead something like:
 >
 > /* Get 11n capabilties from low level driver */
 > static void ieee80211_fill_ht_ie(struct net_device *dev,
 > struct ieee80211_ht_capability *ht_capab)
 > {
 > struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 > BUG_ON(!local->ops->get_ht_capab);
 > memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
 > if (!local->ops->get_ht_capab(local_to_hw(local), ht_capab))
 > return;
 > ht_capab->capabilitiesInfo = (__le16) cpu_to_le16(
 > ht_capab->capabilitiesInfo);
 > ht_capab->extended_ht_capability_info = (__le16) cpu_to_le16(
 > ht_capab->extended_ht_capability_info);
 > ht_capab->tx_BF_capability_info = (__le32) cpu_to_le32(
 > ht_capab->tx_BF_capability_info);
 > }
 >

 > On second thought just memset to 0 on ieee80211_send_assoc() right
 > after the skb_put and remove that from above.

Johannes Berg wrote:
> On Mon, 2007-03-26 at 04:38 -0700, mohamed wrote:
>
>   
>> @@ -96,6 +96,10 @@ struct ieee802_11_elems {
>>  	u8 rsn_len;
>>  	u8 *erp_info;
>>  	u8 erp_info_len;
>> +	u8 *ht_cap_param;
>> +	u8 ht_cap_param_len;
>> +	u8 *ht_extra_param;
>> +	u8 ht_extra_param_len;
>>  	u8 *ext_supp_rates;
>>  	u8 ext_supp_rates_len;
>>  	u8 *wmm_info;
>>     
>
> Random note not applicable to your patch: This is quite a large struct,
> especially on 64-bit. Maybe we should be thinking about making those
> pointers there u16 offsets instead. And we *definitely* should change
> the order of these fields, having u8 and u8* alternate just sucks.
>
>   
>> +static void ieee80211_sta_ht_params(struct net_device *dev, 
>> +			struct sta_info *sta,
>> +			struct ieee80211_ht_additional_info *ht_extra_param,
>> +			struct ieee80211_ht_capability *ht_cap_param)
>> +{
>> +	int rc;
>> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>> +
>> +	if (local->ops->conf_ht) {
>> +		rc = local->ops->conf_ht(local_to_hw(local), ht_cap_param, 
>> +					 ht_extra_param);
>> +
>> +		if (rc)
>> +			sta->flags &= ~WLAN_STA_HT;
>> +	} else 
>> +		sta->flags &= ~WLAN_STA_HT;
>>     
>
> Shouldn't this also set the STA_HT flag in the case where conf_ht
> returns without error?
>
>   
>> +/* Get 11n capabilties from low level driver */
>> +static void ieee80211_fill_ht_ie(struct net_device *dev,
>>     
>
> [filling in how it looks like after Luis's and my proposed changes]
>
>   
>> +				 struct ieee80211_ht_capability *ht_capab)
>> +{
>> +       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>> +       BUG_ON(!local->ops->get_ht_capab);
>> +       memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
>> +       local->ops->get_ht_capab(local_to_hw(local), ht_capab);
>>     
>
> some blank lines would be good ;)
>
> Maybe we should be setting some fields to default values here that
> aren't zero? Haven't checked.
>  
>   
>> +	/* if low level driver support 11n fill in 11n IE */
>> +	if (ht_enabled && ifsta->ht_enabled && local->ops->get_ht_capab) {
>> +		pos = skb_put(skb, sizeof(struct ieee80211_ht_capability)+2);
>> +		*pos++ = WLAN_EID_HT_CAPABILITY;
>> +		*pos++ = sizeof(struct ieee80211_ht_capability);
>> +		ieee80211_fill_ht_ie(dev, 
>> +				     (struct ieee80211_ht_capability *)pos);
>> Now that fill_ht_ie is so short maybe it should just be rolled into this
>>     
Add basic support for IEEE 802.11n discovery and association.

This patch adds support to discover IEEE 802.11n AP and enable
association to 802.11n Network. It parses beacon to discover 802.11n
IE and include HT capability information element in Association Request Frame.
It also call low level driver with the HT capability available during
association.
    Tomas:

    1. Removed trailing spaces
    2. tsf handlers declarations not splited by ht hanlders
    2. fill_ht and ht_params functions removed
    3. Moved code from sta_sysfs.c to debug_sta.c

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 916b21b..b1bbc3d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -529,6 +529,9 @@ #define IEEE80211_HW_TKIP_REQ_PHASE1_KEY
 	 * per-packet RC4 key with each TX frame when doing hwcrypto */
 #define IEEE80211_HW_TKIP_REQ_PHASE2_KEY (1<<14)
 
+	/* The device capable of supporting 11n */
+#define IEEE80211_HW_SUPPORT_HT_MODE (1<<15)
+
 	u32 flags;			/* hardware flags defined above */
 
 	/* Set to the size of a needed device specific skb headroom for TX skbs. */
@@ -731,6 +734,15 @@ struct ieee80211_ops {
 	 * TSF synchronization. */
 	void (*reset_tsf)(struct ieee80211_hw *hw);
 
+	/* Configure ht parameters. */
+	int (*conf_ht)(struct ieee80211_hw *hw,
+		       struct ieee80211_ht_capability *ht_cap_param,
+		       struct ieee80211_ht_additional_info *ht_extra_param);
+
+	/* Get ht capabilities from the device */
+	void (*get_ht_capab)(struct ieee80211_hw *hw,
+			     struct ieee80211_ht_capability *ht_cap_param);
+
 	/* Setup beacon data for IBSS beacons. Unlike access point (Master),
 	 * IBSS uses a fixed beacon frame which is configured using this
 	 * function. This handler is required only for IBSS mode. */
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 3012b9e..aa3035b 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -87,7 +87,7 @@ static ssize_t sta_flags_read(struct fil
 {
 	char buf[100];
 	struct sta_info *sta = file->private_data;
-	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s%s",
+	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s%s%s",
 		sta->flags & WLAN_STA_AUTH ? "AUTH\n" : "",
 		sta->flags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
 		sta->flags & WLAN_STA_PS ? "PS\n" : "",
@@ -96,6 +96,7 @@ static ssize_t sta_flags_read(struct fil
 		sta->flags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
 		sta->flags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
 		sta->flags & WLAN_STA_WME ? "WME\n" : "",
+		sta->flags & WLAN_STA_HT ? "HT\n" : "",
 		sta->flags & WLAN_STA_WDS ? "WDS\n" : "");
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e8eea4d..dd1d031 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -89,6 +89,8 @@ struct ieee80211_sta_bss {
 	size_t rsn_ie_len;
 	u8 *wmm_ie;
 	size_t wmm_ie_len;
+	u8 *ht_ie;
+	size_t ht_ie_len;
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
@@ -268,6 +270,7 @@ struct ieee80211_if_sta {
 	unsigned int create_ibss:1;
 	unsigned int mixed_cell:1;
 	unsigned int wmm_enabled:1;
+	unsigned int ht_enabled:1;
 	unsigned int auto_ssid_sel:1;
 	unsigned int auto_bssid_sel:1;
 	unsigned int auto_channel_sel:1;
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index b1b20ba..ebea50d 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -184,6 +184,7 @@ void ieee80211_if_set_type(struct net_de
 			IEEE80211_AUTH_ALG_SHARED_KEY;
 		ifsta->create_ibss = 1;
 		ifsta->wmm_enabled = 1;
+		ifsta->ht_enabled = 1;
 		ifsta->auto_channel_sel = 1;
 		ifsta->auto_bssid_sel = 1;
 
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 087f176..2ae0a56 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -96,6 +96,10 @@ struct ieee802_11_elems {
 	u8 rsn_len;
 	u8 *erp_info;
 	u8 erp_info_len;
+	u8 *ht_cap_param;
+	u8 ht_cap_param_len;
+	u8 *ht_extra_param;
+	u8 ht_extra_param_len;
 	u8 *ext_supp_rates;
 	u8 ext_supp_rates_len;
 	u8 *wmm_info;
@@ -197,6 +201,14 @@ #endif
 			elems->ext_supp_rates = pos;
 			elems->ext_supp_rates_len = elen;
 			break;
+		case WLAN_EID_HT_CAPABILITY:
+			elems->ht_cap_param = pos;
+			elems->ht_cap_param_len = elen;
+			break;
+		case WLAN_EID_HT_EXTRA_INFO:
+			elems->ht_extra_param = pos;
+			elems->ht_extra_param_len = elen;
+			break;
 		default:
 #if 0
 			printk(KERN_DEBUG "IEEE 802.11 element parse ignored "
@@ -230,7 +242,6 @@ static int ecw2cw(int ecw)
 	return cw - 1;
 }
 
-
 static void ieee80211_sta_wmm_params(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
 				     u8 *wmm_param, size_t wmm_param_len)
@@ -490,6 +501,7 @@ static void ieee80211_send_assoc(struct 
 	u16 capab;
 	struct ieee80211_sta_bss *bss;
 	int wmm = 0;
+	int ht_enabled = 0;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
@@ -513,6 +525,8 @@ static void ieee80211_send_assoc(struct 
 			capab |= WLAN_CAPABILITY_PRIVACY;
 		if (bss->wmm_ie) {
 			wmm = 1;
+
+				ht_enabled = 1;
 		}
 		ieee80211_rx_bss_put(dev, bss);
 	}
@@ -588,6 +602,16 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = 0;
 	}
 
+	/* if low level driver supports 11n, fill in 11n IE */
+	if (ht_enabled && ifsta->ht_enabled && local->ops->get_ht_capab) {
+		pos = skb_put(skb, sizeof(struct ieee80211_ht_capability)+2);
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_capability);
+		memset(pos, 0, sizeof(struct ieee80211_ht_capability));
+		local->ops->get_ht_capab(local_to_hw(local),
+			(struct ieee80211_ht_capability *)pos);
+	}
+
 	kfree(ifsta->assocreq_ies);
 	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
 	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_ATOMIC);
@@ -1223,6 +1247,20 @@ static void ieee80211_rx_mgmt_assoc_resp
 	}
 	sta->supp_rates = rates;
 
+	if (elems.ht_extra_param && elems.ht_cap_param && elems.wmm_param &&
+	    ifsta->ht_enabled && local->ops->conf_ht){
+		int rc;
+		
+		rc = local->ops->conf_ht(local_to_hw(local),
+					 (struct ieee80211_ht_capability *)
+					 elems.ht_cap_param,
+					 (struct ieee80211_ht_additional_info *)
+					 elems.ht_extra_param);
+		if (!rc)
+			sta->flags |= WLAN_STA_HT;
+	}
+
+
 	rate_control_rate_init(sta, local);
 
 	if (elems.wmm_param && ifsta->wmm_enabled) {
@@ -1318,6 +1356,7 @@ static void ieee80211_rx_bss_free(struct
 	kfree(bss->wpa_ie);
 	kfree(bss->rsn_ie);
 	kfree(bss->wmm_ie);
+	kfree(bss->ht_ie);
 	kfree(bss);
 }
 
@@ -1564,6 +1603,23 @@ #endif
 		bss->wmm_ie_len = 0;
 	}
 
+	if (elems.ht_cap_param &&
+	    (!bss->ht_ie || bss->ht_ie_len != elems.ht_cap_param_len ||
+	     memcmp(bss->ht_ie, elems.ht_cap_param, elems.ht_cap_param_len))) {
+		if (bss->ht_ie)
+			kfree(bss->ht_ie);
+		bss->ht_ie = kmalloc(elems.ht_cap_param_len + 2, GFP_ATOMIC);
+		if (bss->ht_ie) {
+			memcpy(bss->ht_ie, elems.ht_cap_param - 2,
+			       elems.ht_cap_param_len + 2);
+			bss->ht_ie_len = elems.ht_cap_param_len + 2;
+		} else
+			bss->ht_ie_len = 0;
+	} else if (!elems.ht_cap_param && bss->ht_ie) {
+		kfree(bss->ht_ie);
+		bss->ht_ie = NULL;
+		bss->ht_ie_len = 0;
+	}
 
 	bss->hw_mode = rx_status->phymode;
 	bss->channel = channel;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ed7ca59..0010fde 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -27,6 +27,7 @@ #define WLAN_STA_AUTHORIZED BIT(5) /* If
 				    */
 #define WLAN_STA_SHORT_PREAMBLE BIT(7)
 #define WLAN_STA_WME BIT(9)
+#define WLAN_STA_HT  BIT(10)
 #define WLAN_STA_WDS BIT(27)
 
 
