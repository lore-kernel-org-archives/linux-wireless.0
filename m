Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:26917 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757584Ab0IHHFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:07 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-025769503
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:05 +0900 (JST)
Subject: [PATCH 1/8] ath: Copy cryptographic capability flags into ath
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:04:33 +0900
Message-ID: <20100908070433.11255.61620.stgit@tt-desk>
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used later in this patch series.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index a706202..057fdd7 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -71,6 +71,15 @@ struct ath_regulatory {
 	struct reg_dmn_pair_mapping *regpair;
 };
 
+enum ath_crypt_caps {
+	ATH_CRYPT_CAP_MIC_AESCCM		= BIT(0),
+	ATH_CRYPT_CAP_MIC_CKIP			= BIT(1),
+	ATH_CRYPT_CAP_MIC_TKIP			= BIT(2),
+	ATH_CRYPT_CAP_CIPHER_AESCCM		= BIT(3),
+	ATH_CRYPT_CAP_CIPHER_CKIP		= BIT(4),
+	ATH_CRYPT_CAP_CIPHER_TKIP		= BIT(5),
+};
+
 /**
  * struct ath_ops - Register read/write operations
  *
@@ -121,6 +130,7 @@ struct ath_common {
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	DECLARE_BITMAP(tkip_keymap, ATH_KEYMAX);
 	u8 splitmic;
+	enum ath_crypt_caps crypt_caps;
 
 	struct ath_regulatory regulatory;
 	const struct ath_ops *ops;

