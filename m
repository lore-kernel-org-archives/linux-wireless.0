Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40777 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932415AbeGIKUj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 06:20:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id t6-v6so10380484wrn.7
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2018 03:20:39 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org, dcaratti@redhat.com
Subject: [PATCH 1/2] mt7601u: use sw encryption for hw unsupported ciphers
Date: Mon,  9 Jul 2018 12:20:26 +0200
Message-Id: <ad9cbcd50cdde4ff997a5ce69265f741114e9af0.1531130155.git.lorenzo.bianconi@redhat.com> (sfid-20180709_122042_778672_C7305DE6)
In-Reply-To: <cover.1531130155.git.lorenzo.bianconi@redhat.com>
References: <cover.1531130155.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fall back to software encryption for hw unsupported ciphers in order
to enable 802.11w

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index 7b21016012c3..0f1789020960 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -308,6 +308,17 @@ mt7601u_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
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
 	if (cmd == SET_KEY) {
 		key->hw_key_idx = wcid->idx;
 		wcid->hw_key_idx = idx;
-- 
2.17.1
