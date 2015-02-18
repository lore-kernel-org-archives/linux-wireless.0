Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:43893 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbbBRTvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 14:51:31 -0500
Received: by wesu56 with SMTP id u56so3231714wes.10
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2015 11:51:30 -0800 (PST)
From: Jon Hunter <jgchunter@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Jon Hunter <jgchunter@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>, coekbe@gmail.com
Subject: [RFC PATCH] rtl8192cu: Fix beacon support in AP mode
Date: Wed, 18 Feb 2015 19:51:14 +0000
Message-Id: <1424289074-27489-1-git-send-email-jgchunter@gmail.com> (sfid-20150218_205136_483882_7072FBAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the rtl8192cu in AP mode a few devices (an android phone,
iphone and ipad) were unable to associate, where as the laptops I tried
could. Using wireshark to sniff the wlan traffic, it appears that the
rtl8192cu is not beaconing, however, it is responding to broadcast
probe requests and so devices are able to detect the AP.

Searching the archives the same issue was reported for this WLAN device
and a fix to send an initial beacon frame was proposed [1]. This was
rejected as it was modifying the rtlwifi core. This change does the
same but from within the rtl8192cu driver and appears to fix the problem.

Please note that although this does fix the problem, I don't know if this
is the best way or correct way to fix the problem, hence the request for
comment.

[1] http://permalink.gmane.org/gmane.linux.kernel.wireless.general/96770

Signed-off-by: Jon Hunter <jgchunter@gmail.com>

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
Cc: coekbe@gmail.com
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index fe4b699..4fbca80 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1520,6 +1520,22 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
 	_beacon_function_enable(hw, true, true);
 }
 
+static void _beacon_send_frame(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct ieee80211_sta *sta;
+	struct rtl_tcb_desc tcb_desc;
+	struct sk_buff *skb;
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
+
+	skb = ieee80211_beacon_get(hw, mac->vif);
+	sta = rtl_find_sta(hw, mac->bssid);
+
+	if (!rtlpriv->intf_ops->waitq_insert(hw, sta, skb))
+		rtlpriv->intf_ops->adapter_tx(hw, sta, skb, &tcb_desc);
+}
+
 void rtl92cu_set_beacon_interval(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1529,6 +1545,9 @@ void rtl92cu_set_beacon_interval(struct ieee80211_hw *hw)
 	RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG, "beacon_interval:%d\n",
 		 bcn_interval);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
+
+        /* Send initial beacon frame to start beaconing */
+	_beacon_send_frame(hw);
 }
 
 void rtl92cu_update_interrupt_mask(struct ieee80211_hw *hw,
-- 
1.9.1

