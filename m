Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:34356 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756557Ab1BCRZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 12:25:56 -0500
Date: Thu, 3 Feb 2011 18:35:19 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Add testing functionality for TKIP
Message-ID: <20110203163519.GB17227@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TKIP countermeasures depend on devices being able to detect Michael
MIC failures on received frames and for stations to report errors to
the AP. In order to test that behavior, it is useful to be able to
send out TKIP frames with incorrect Michael MIC. This testing behavior
has minimal effect on the TX path, so it can be added to mac80211 for
convenient use.

The interface for using this functionality is a file in mac80211
netdev debugfs (tkip_mic_test). Writing a MAC address to the file
makes mac80211 generate a dummy data frame that will be sent out using
invalid Michael MIC value. In AP mode, the address needs to be for one
of the associated stations or ff:ff:ff:ff:ff:ff to use a broadcast
frame. In station mode, the address can be anything, e.g., the current
BSSID. It should be noted that this functionality works correctly only
when associated and using TKIP.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/net/mac80211.h        |    4 +
 net/mac80211/debugfs_netdev.c |  102 +++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/wpa.c            |    7 ++
 3 files changed, 112 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/mac80211.h	2011-02-03 17:55:31.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2011-02-03 17:56:14.000000000 +0200
@@ -341,6 +341,9 @@ struct ieee80211_bss_conf {
  *	the off-channel channel when a remain-on-channel offload is done
  *	in hardware -- normal packets still flow and are expected to be
  *	handled properly by the device.
+ * @IEEE80211_TX_INTFL_TKIP_MIC_FAILURE: Marks this packet to be used for TKIP
+ *	testing. It will be sent out with incorrect Michael MIC key to allow
+ *	TKIP countermeasures to be tested.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -370,6 +373,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_LDPC			= BIT(22),
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
 	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
+	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
--- wireless-testing.orig/net/mac80211/wpa.c	2011-02-03 17:55:31.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2011-02-03 17:56:14.000000000 +0200
@@ -46,6 +46,11 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	data = skb->data + hdrlen;
 	data_len = skb->len - hdrlen;
 
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_TKIP_MIC_FAILURE)) {
+		/* Need to use software crypto for the test */
+		info->control.hw_key = NULL;
+	}
+
 	if (info->control.hw_key &&
 	    !(tx->flags & IEEE80211_TX_FRAGMENTED) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)) {
@@ -64,6 +69,8 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	key = &tx->key->conf.key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY];
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
 	michael_mic(key, hdr, data, data_len, mic);
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_TKIP_MIC_FAILURE))
+		mic[0]++;
 
 	return TX_CONTINUE;
 }
--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2011-02-03 17:55:31.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2011-02-03 17:56:14.000000000 +0200
@@ -36,7 +36,7 @@ static ssize_t ieee80211_if_read(
 		ret = (*format)(sdata, buf, sizeof(buf));
 	read_unlock(&dev_base_lock);
 
-	if (ret != -EINVAL)
+	if (ret >= 0)
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, ret);
 
 	return ret;
@@ -220,6 +220,104 @@ static ssize_t ieee80211_if_parse_smps(s
 
 __IEEE80211_IF_FILE_W(smps);
 
+static ssize_t ieee80211_if_fmt_tkip_mic_test(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hwaddr_aton(const char *txt, u8 *addr)
+{
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++) {
+		int a, b;
+
+		a = hex_to_bin(*txt++);
+		if (a < 0)
+			return -1;
+		b = hex_to_bin(*txt++);
+		if (b < 0)
+			return -1;
+		*addr++ = (a << 4) | b;
+		if (i < 5 && *txt++ != ':')
+			return -1;
+	}
+
+	return 0;
+}
+
+static ssize_t ieee80211_if_parse_tkip_mic_test(
+	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+{
+	struct ieee80211_local *local = sdata->local;
+	u8 addr[ETH_ALEN];
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	__le16 fc;
+
+	/*
+	 * Assume colon-delimited MAC address with possible white space
+	 * following.
+	 */
+	if (buflen < 3 * ETH_ALEN - 1)
+		return -EINVAL;
+	if (hwaddr_aton(buf, addr) < 0)
+		return -EINVAL;
+
+	if (!ieee80211_sdata_running(sdata))
+		return -ENOTCONN;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24 + 100);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	hdr = (struct ieee80211_hdr *) skb_put(skb, 24);
+	memset(hdr, 0, 24);
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA);
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
+		/* DA BSSID SA */
+		memcpy(hdr->addr1, addr, ETH_ALEN);
+		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		memcpy(hdr->addr3, sdata->vif.addr, ETH_ALEN);
+		break;
+	case NL80211_IFTYPE_STATION:
+		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
+		/* BSSID SA DA */
+		if (sdata->vif.bss_conf.bssid == NULL) {
+			dev_kfree_skb(skb);
+			return -ENOTCONN;
+		}
+		memcpy(hdr->addr1, sdata->vif.bss_conf.bssid, ETH_ALEN);
+		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		memcpy(hdr->addr3, addr, ETH_ALEN);
+		break;
+	default:
+		dev_kfree_skb(skb);
+		return -EOPNOTSUPP;
+	}
+	hdr->frame_control = fc;
+
+	/*
+	 * Add some length to the test frame to make it look bit more valid.
+	 * The exact contents does not matter since the recipient is required
+	 * to drop this because of the Michael MIC failure.
+	 */
+	memset(skb_put(skb, 50), 0, 50);
+
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_TKIP_MIC_FAILURE;
+
+	ieee80211_tx_skb(sdata, skb);
+
+	return buflen;
+}
+
+__IEEE80211_IF_FILE_W(tkip_mic_test);
+
 /* AP attributes */
 IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
 IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
@@ -297,6 +395,7 @@ static void add_sta_files(struct ieee802
 	DEBUGFS_ADD(last_beacon);
 	DEBUGFS_ADD(ave_beacon);
 	DEBUGFS_ADD_MODE(smps, 0600);
+	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
@@ -310,6 +409,7 @@ static void add_ap_files(struct ieee8021
 	DEBUGFS_ADD(num_sta_ps);
 	DEBUGFS_ADD(dtim_count);
 	DEBUGFS_ADD(num_buffered_multicast);
+	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
 }
 
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)

-- 
Jouni Malinen                                            PGP id EFC895FA
