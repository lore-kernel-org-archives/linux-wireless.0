Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:3854 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992450AbXDCWgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2007 18:36:39 -0400
Message-ID: <46138001.70301@linux.intel.com>
Date: Wed, 04 Apr 2007 03:37:53 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	mabbas@linux.intel.com
Subject: Re: [patch 5/5] IEEE 802.11n management action frame handling
References: <1174909425.1364.63.camel@dell-4965.jf.intel.com> <1175112901.5151.141.camel@johannes.berg>
In-Reply-To: <1175112901.5151.141.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modified patch at the end
Johannes Berg wrote:
> On Mon, 2007-03-26 at 04:43 -0700, mohamed wrote:
>
>   
>> +static void ieee80211_send_addba_resp(struct net_device *dev,
>> +				      struct ieee80211_mgmt *mgmt_src,
>> +				      size_t len,
>> +				      u16 status)
>> +{
>> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +        struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>> +	struct sk_buff *skb;
>> +	struct ieee80211_mgmt *mgmt;
>> +
>> +	skb = dev_alloc_skb(sizeof(*mgmt) + 50 );
>>     
>
> Why +50? And isn't sizeof(ieee80211_mgmt) a bit dangerous since that
> structure might increase in size?
>
>   
>> +static void ieee80211_rx_mgmt_action(struct net_device *dev,
>> +				     struct ieee80211_if_sta *ifsta,
>> +				     struct ieee80211_mgmt *mgmt,
>> +				     size_t len)
>> +{
>> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>> +
>> +	if (len < 24 + 1) {
>>     
>
> Why 25? Some #define maybe?
>
>   
>> +			printk(KERN_ERR "%s: recieved back unsupported \n",
>> +								dev->name);
>>     
>
> "Received unsupported block-ack action"? And you need a ratelimit on
> that printk or somebody can flood you with kernel messages by sending
> tiny frames with invalid fields there. Possibly on other printks too.
>
> Oh and one more smallish thing: Can you post your patches 1-5/5 as
> replies to 0/5? Makes the whole thing more readable in most mail
> programs, and I think it also simplifies John's life when merging.
>  
> johannes
>   
add draft IEEE 802.11n management action frame handling

Several Action frame format are defined to support IEEE 802.11n features.
This patch adds support to parse Block Ack action frame, then call
low level driver with the frame's body.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b1bbc3d..34e67a7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -728,6 +728,10 @@ struct ieee80211_ops {
 	 * required function. */
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 
+	/* Call low level driver with 11n Block Ack action */
+	int (*handle_ba_action)(struct ieee80211_hw *hw,
+				struct ieee80211_mgmt *mgmt);
+
 	/* Reset the TSF timer and allow firmware/hardware to synchronize with
 	 * other STAs in the IBSS. This is only used in IBSS mode. This
 	 * function is optional if the firmware/hardware takes full care of
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2ae0a56..7bba219 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -57,6 +57,9 @@ #define IEEE80211_FC(type, stype) cpu_to
 
 #define ERP_INFO_USE_PROTECTION BIT(1)
 
+/* mgmt header + 1 byte action code */
+#define IEEE80211_MIN_ACTION_SIZE (24 + 1)
+
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
@@ -1782,6 +1785,102 @@ #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	ieee80211_sta_tx(dev, skb, 0);
 }
 
+static void ieee80211_send_addba_resp(struct net_device *dev,
+				      struct ieee80211_mgmt *mgmt_src,
+				      size_t len,
+				      u16 status)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer "
+		       "for addts frame\n", dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					   IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
+	mgmt->u.action.u.addba_resp.dialog_token =
+		mgmt_src->u.action.u.addba_req.dialog_token;
+	mgmt->u.action.u.addba_resp.capab =
+		mgmt_src->u.action.u.addba_req.capab;
+	mgmt->u.action.u.addba_resp.timeout =
+		mgmt_src->u.action.u.addba_req.timeout;
+	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
+
+	ieee80211_sta_tx(dev, skb, 0);
+	
+	return;
+}
+
+static void ieee80211_rx_mgmt_action(struct net_device *dev,
+				     struct ieee80211_if_sta *ifsta,
+				     struct ieee80211_mgmt *mgmt,
+				     size_t len)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+
+	if (len < IEEE80211_MIN_ACTION_SIZE) 
+		return;
+
+	switch (mgmt->u.action.category) {
+	case WLAN_CATEGORY_BACK:
+		switch (mgmt->u.action.u.addba_req.action_code) {
+		case WLAN_ACTION_ADDBA_REQ:
+			if (len < (IEEE80211_MIN_ACTION_SIZE + 
+				   sizeof(mgmt->u.action.u.addba_req)))
+				break;	
+			if (!local->ops->handle_ba_action || 
+			    (local->ops->handle_ba_action(local_to_hw(local),
+						      mgmt)))
+				ieee80211_send_addba_resp(dev, mgmt, len,
+						WLAN_STATUS_REQUEST_DECLINED);
+			else
+				ieee80211_send_addba_resp(dev, mgmt, len,
+							WLAN_STATUS_SUCCESS);
+			break;
+		case WLAN_ACTION_ADDBA_RESP:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.addba_resp)))
+				break;
+			if (!local->ops->handle_ba_action)
+				break;
+			local->ops->handle_ba_action(local_to_hw(local), mgmt);
+			break;
+		case WLAN_ACTION_DELBA:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.delba)))
+				break;
+
+			 if (!local->ops->handle_ba_action)
+				break;
+
+			local->ops->handle_ba_action(local_to_hw(local), mgmt);
+			break;
+		default:
+			break;
+		}
+		break;
+
+	default:
+		break;
+	}
+}
 
 void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status)
@@ -1810,6 +1909,7 @@ void ieee80211_sta_rx_mgmt(struct net_de
 	case IEEE80211_STYPE_REASSOC_RESP:
 	case IEEE80211_STYPE_DEAUTH:
 	case IEEE80211_STYPE_DISASSOC:
+	case IEEE80211_STYPE_ACTION:
 		skb_queue_tail(&ifsta->skb_queue, skb);
 		schedule_work(&ifsta->work);
 		return;
@@ -1867,6 +1967,9 @@ static void ieee80211_sta_rx_queued_mgmt
 	case IEEE80211_STYPE_DISASSOC:
 		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len);
 		break;
+	case IEEE80211_STYPE_ACTION:
+		ieee80211_rx_mgmt_action(dev, ifsta, mgmt, skb->len);
+		break;
 	}
 
 	kfree_skb(skb);
