Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:42071 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbeCQOBs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Mar 2018 10:01:48 -0400
Received: by mail-wr0-f196.google.com with SMTP id s18so14208541wrg.9
        for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2018 07:01:47 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix warning in ieee80211_get_key_rx_seq()
Date: Sat, 17 Mar 2018 15:01:39 +0100
Message-Id: <20180317140139.24724-1-lorenzo.bianconi@redhat.com> (sfid-20180317_150200_966730_0B841D0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fall back to software encryption for hw unsupported ciphers in order
to fix the following warning in ieee80211_get_key_rx_seq routine:

WARNING: CPU: 1 PID: 1277 at backports-2017-11-01/net/mac80211/key.c:
1010 mt76_wcid_key_setup+0x6c/0x138 [mt76]
CPU: 1 PID: 1277 Comm: hostapd Tainted: G        W       4.9.86 #0
Stack : 00000000 00000000 80527b4a 00000042 80523824 00000000 00000000 80520000
        8fd79a9c 804bbda7 80454c84 00000001 000004fd 80523824 8f7e4ba0 8eceda12
        00000010 8006af94 00000001 80520000 804c1f04 804c1f08 80459890 8ec999b4
        00000003 800a7840 8f7e4ba0 8eceda12 8121de20 00000000 00000001 00c999b4
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
        ...
Call Trace:
[<8000f52c>] show_stack+0x70/0x8c
[<801d8d04>] dump_stack+0x94/0xd0
[<8002bcd4>] __warn+0x110/0x118
[<8002bd70>] warn_slowpath_null+0x1c/0x2c
[<8f0415cc>] mt76_wcid_key_setup+0x6c/0x138 [mt76]
[<8f1311b4>] mt76x2_dma_cleanup+0xa38/0x1048 [mt76x2e]

Fixes: 30ce7f4456ae ("mt76: validate rx CCMP PN")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 25f4cebef26d..73c127f92613 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -336,6 +336,17 @@ mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	int idx = key->keyidx;
 	int ret;
 
+	/* fall back to sw encryption for unsupported ciphers */
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	/*
 	 * The hardware does not support per-STA RX GTK, fall back
 	 * to software mode for these.
-- 
2.16.2
