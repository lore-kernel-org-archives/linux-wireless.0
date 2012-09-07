Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55699 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507Ab2IGX24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 19:28:56 -0400
Received: by wibhi8 with SMTP id hi8so40889wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 16:28:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3.6] p54: fix off-by-one null pointer bug in p54_tx_80211
Date: Sat, 8 Sep 2012 01:28:42 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201209080128.43388.chunkeey@googlemail.com> (sfid-20120908_012916_805620_339E0091)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression which was introduced in:
"mac80211: move TX station pointer and restructure TX"

IP: p54_tx_80211+0x21/0x513 [p54common]
Oops: 0000 [#1] SMP
Modules linked in: p54usb p54common [...]
Pid: 13394, comm: hostapd 3.6.0-rc4-wl+
RIP: 0010:p54_tx_80211+0x21/0x513
RSP: 0018:...  EFLAGS: 00010292
[...]
Process hostapd
Stack:
[...]
Call Trace:
p54_bss_info_changed+0x204/0x21e [p54common]
ieee80211_del_station+0x16/0x32 [mac80211]
ieee80211_start_ap+0x10f/0x157 [mac80211]
nl80211_start_ap+0x315/0x361 [cfg80211]

p54_tx_80211 function is called as part of the
beacon update. The caller p54_bss_info_changed
has to supply a valid tx control struct, or
the control->sta will lead to a null pointer
dereference.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 6c709c5..d9d0a11 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -139,6 +139,7 @@ static int p54_beacon_format_ie_tim(struct sk_buff *skb)
 static int p54_beacon_update(struct p54_common *priv,
 			struct ieee80211_vif *vif)
 {
+	struct ieee80211_tx_control control = { };
 	struct sk_buff *beacon;
 	int ret;
 
@@ -158,7 +159,7 @@ static int p54_beacon_update(struct p54_common *priv,
 	 * to cancel the old beacon template by hand, instead the firmware
 	 * will release the previous one through the feedback mechanism.
 	 */
-	p54_tx_80211(priv->hw, NULL, beacon);
+	p54_tx_80211(priv->hw, &control, beacon);
 	priv->tsf_high32 = 0;
 	priv->tsf_low32 = 0;
 
