Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:58283 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYKZVRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 16:17:40 -0500
Received: by yw-out-2324.google.com with SMTP id 9so337533ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 13:17:39 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: nbd@openwrt.org, lrodriguez@atheros.com, jirislaby@gmail.com,
	linville@tuxdriver.com, mickflemm@gmail.com
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Date: Wed, 26 Nov 2008 16:17:25 -0500
Message-Id: <20081126211725.16875.27970.sendpatchset@localhost> (sfid-20081126_221743_974919_D0830A0C)
In-Reply-To: <20081126211711.16875.71258.sendpatchset@localhost>
References: <20081126211711.16875.71258.sendpatchset@localhost>
Subject: [PATCH 3/3] ath5k: enable combined michael mic in key cache
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For mac revisions >= "Griffin," the hardware allows the mic tx and rx
authenticator keys to share the same cache line, whereas earlier
hardware can only store the rx.  Enable the combined mic on hardware
that supports it.

Changes to ath5k.h
Changes-licensed-under: 3-Clause-BSD

Changes to attach.c, pcu.c, reg.h
Changes-licensed-under: ISC

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/ath5k.h  |    1 +
 drivers/net/wireless/ath5k/attach.c |    6 ++++++
 drivers/net/wireless/ath5k/pcu.c    |   28 ++++++++++++++--------------
 drivers/net/wireless/ath5k/reg.h    |    1 +
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 5ee2dd1..13df119 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1052,6 +1052,7 @@ struct ath5k_hw {
 	bool			ah_calibration;
 	bool			ah_running;
 	bool			ah_single_chip;
+	bool			ah_combined_mic;
 	enum ath5k_rfgain	ah_rf_gain;
 
 	u32			ah_mac_srev;
diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wireless/ath5k/attach.c
index 49d82d7..dea378f 100644
--- a/drivers/net/wireless/ath5k/attach.c
+++ b/drivers/net/wireless/ath5k/attach.c
@@ -317,6 +317,12 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		goto err_free;
 	}
 
+	if (srev >= AR5K_SREV_AR2414) {
+		ah->ah_combined_mic = true;
+		AR5K_REG_ENABLE_BITS(ah, AR5K_MISC_MODE,
+			AR5K_MISC_MODE_COMBINED_MIC);
+	}
+
 	/* MAC address is cleared until add_interface */
 	ath5k_hw_set_lladdr(ah, mac);
 
diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index 86ca54b..0461ce5 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -1096,20 +1096,20 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
 		/* Install rx/tx MIC */
 		rxmic = (__le32 *) &key->key[16];
 		txmic = (__le32 *) &key->key[24];
-#if 0
-		/* MISC_MODE register & 0x04 - for mac srev >= griffin */
-		key_v[0] = rxmic[0];
-		key_v[1] = (txmic[0] >> 16) & 0xffff;
-		key_v[2] = rxmic[1];
-		key_v[3] = txmic[0] & 0xffff;
-		key_v[4] = txmic[1];
-#else
-		key_v[0] = rxmic[0];
-		key_v[1] = 0;
-		key_v[2] = rxmic[1];
-		key_v[3] = 0;
-		key_v[4] = 0;
-#endif
+
+		if (ah->ah_combined_mic) {
+			key_v[0] = rxmic[0];
+			key_v[1] = (txmic[0] >> 16) & 0xffff;
+			key_v[2] = rxmic[1];
+			key_v[3] = txmic[0] & 0xffff;
+			key_v[4] = txmic[1];
+		} else {
+			key_v[0] = rxmic[0];
+			key_v[1] = 0;
+			key_v[2] = rxmic[1];
+			key_v[3] = 0;
+			key_v[4] = 0;
+		}
 		for (i = 0; i < ARRAY_SIZE(key_v); i++)
 			ath5k_hw_reg_write(ah, le32_to_cpu(key_v[i]),
 				AR5K_KEYTABLE_OFF(micentry, i));
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 69755fc..91aaeaf 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1729,6 +1729,7 @@
 #define	AR5K_MISC_MODE			0x8120			/* Register Address */
 #define	AR5K_MISC_MODE_FBSSID_MATCH	0x00000001	/* Force BSSID match */
 #define	AR5K_MISC_MODE_ACKSIFS_MEM	0x00000002	/* ACK SIFS memory (?) */
+#define	AR5K_MISC_MODE_COMBINED_MIC	0x00000004	/* use rx/tx MIC key */
 /* more bits */
 
 /*
-- 
1.5.4.2.182.gb3092

