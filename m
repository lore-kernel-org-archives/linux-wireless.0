Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46866 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2IBSuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 14:50:25 -0400
Received: by iahk25 with SMTP id k25so3413091iah.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2012 11:50:24 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Sep 2012 21:50:24 +0300
Message-ID: <CAK678xg-uD6rKdcZVksAdAwMtsvmcn6GmYsSa1gWS=CNTLpenw@mail.gmail.com> (sfid-20120902_205046_549858_F0FC109D)
Subject: [RFC][PATCH] rtl8192cu: completing beaconing support
From: coekbe <coekbe@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

Beaconing support in rtl8192cu (AP and ad-hoc modes) was already
mostly there, but code for actually sending out beacon frames was
missing. The following patch works for me, meaning that I can use
hostapd to set up a functioning AP.

Beaconing in rtl8192cu seems to work such that the user needs to
explicitly send one beacon frame, which the hardware then starts
repeating. The explicitly sent frames show up in hostapd's mon.wlan0
and then hostapd also prints out a message "unknown mgmt cb frame
subtype 8". I don't know how to fix that. It doesn't seem to matter,
though.

Also, hostapd.conf should have "dtim_period=1", since the hardware
doesn't change dtim count in the beacon frames it sends. Furthermore,
the period is hardcoded to 1 in the realtek vendor driver. Is there a
way for a driver to inform mac80211 and hostapd about this limitation?

How does the patch look? My knowledge in this area is very limited:
basically, I guess the patch is ok, since my kernel doesn't panic. :)
(I realize that the patch modifies the common rtlwifi code, so it
should condition the new beaconing code for rtl8192cu only.)

Colin

diff -Nurp a/compat-wireless-3.5.1-1-snpc/drivers/net/wireless/rtlwifi/core.c
b/compat-wireless-3.5.1-1-snpc/drivers/net/wireless/rtlwifi/core.c
--- a/compat-wireless-3.5.1-1-snpc/drivers/net/wireless/rtlwifi/core.c	2012-08-14
07:49:58.000000000 +0300
+++ b/compat-wireless-3.5.1-1-snpc/drivers/net/wireless/rtlwifi/core.c	2012-09-01
23:38:19.598281038 +0300
@@ -572,6 +572,25 @@ static int rtl_op_conf_tx(struct ieee802
 	return 0;
 }

+static void _rtl_update_beacon(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif)
+{
+        struct sk_buff *skb;
+
+        skb = ieee80211_beacon_get(hw, vif);
+        rtl_op_tx(hw, skb);
+}
+
+static int rtl_op_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+			  bool set)
+{
+        struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+        _rtl_update_beacon(hw, rtlpriv->mac80211.vif);
+
+        return 0;
+}
+
 static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_bss_conf *bss_conf, u32 changed)
@@ -589,6 +608,7 @@ static void rtl_op_bss_info_changed(stru
 		if ((changed & BSS_CHANGED_BEACON) ||
 		    (changed & BSS_CHANGED_BEACON_ENABLED &&
 		     bss_conf->enable_beacon)) {
+			_rtl_update_beacon(hw, vif);
 			if (mac->beacon_enabled == 0) {
 				RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 					 "BSS_CHANGED_BEACON_ENABLED\n");
@@ -1181,6 +1201,7 @@ const struct ieee80211_ops rtl_ops = {
 	.configure_filter = rtl_op_configure_filter,
 	.sta_add = rtl_op_sta_add,
 	.sta_remove = rtl_op_sta_remove,
+	.set_tim = rtl_op_set_tim,
 	.set_key = rtl_op_set_key,
 	.conf_tx = rtl_op_conf_tx,
 	.bss_info_changed = rtl_op_bss_info_changed,
