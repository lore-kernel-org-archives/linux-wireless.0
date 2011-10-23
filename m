Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1JWGWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 02:22:00 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so6690457bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 23:22:00 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] wl12xx: leave IV calculation to HW for CCMP
Date: Sun, 23 Oct 2011 08:21:54 +0200
Message-Id: <1319350915-31222-1-git-send-email-arik@wizery.com> (sfid-20111023_082206_652181_7FC72D69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use an appropriate mac80211 flags in CCMP keys to indicate we are
calculating the CCMP IV in HW, but require room for the IV to be reserved
in the skb. The space is reserved by mac80211.

depends on "mac80211: support adding IV-room in the skb for CCMP keys".

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f76be5a..75adc76 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2992,7 +2992,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = KEY_AES;
 
-		key_conf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		key_conf->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
 		tx_seq_32 = WL1271_TX_SECURITY_HI32(wlvif->tx_security_seq);
 		tx_seq_16 = WL1271_TX_SECURITY_LO16(wlvif->tx_security_seq);
 		break;
-- 
1.7.5.4

