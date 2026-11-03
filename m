Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719562;
	b=PLQTgfaMgqAQjZqRGvEKIxWpVOhYwlOJZPqV+8yeXyQyWYCuCvIHNvJ0Tw/sqM5iGfJ9
	 g7PYxQgiqw+TkzNgeQcfkHVfenItS4uIJgqgTM7t4iQI4VCE2WItvxtx/BJ9wn4jym1A0
	 +pEqPK8iS7jQ6bDP7pgU/hvcKJOqMF2I570OFQGbg2fIzCyOf0duMrdyPuVNvgmEw6Sm8
	 +NzI90dEWUTwZ67ZebxmW/CDfESteZH2DA+DithjDWFfq/Vvhrmf+0mD7GM3wtcHCSE1X
	 e9MQYDtxMIRV01Wf31MeqTosXdpvs+ZlWSbj1N/hbH2yGNDKFqBLByIia9mEeMLM1Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719562;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWMpHil3tUiWoM/gXqxyfKt6bv1Q3LCVwmL1mluvAhA=;
	b=Y5sk9Tltm51heQpGWc7n4x81oLl4o/QRE2aHI6MzEMXPWdZZGXIKvbGXuuGuVPSEI7w6
	 dEeasWPTxZJoJa5QTxTgLUyXPfe68l0ij4Eg5wPtqirjeZ1qAWK0TNNrEonCuG682P679
	 OW27QvrJKVWoETdMs0xD+oxBaU/vmrVwZU4l+RcZzy0HjTbZf5Xg0CngaNuvCI/II4beK
	 5REvuWG7hzsfqSOt2No6g7a1BhmW5X0pvlyxxkMUnhg5wt6GPqSKFHSyBCP2J8tYhI8Kk
	 cMlCBoZ3ISsRIkl4tpaL0MF7bDFOMdZe6/HgXjTOlHo2YK1Tmt/3ICdiNHSIYzWcTnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=IBUqmmdb;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4CA606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=IBUqmmdb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=XWMpHil3tUiWoM/gXqxyfKt6bv1Q3LCVwmL1mluvAhA=; t=1793719561; x=1794929161; 
	b=IBUqmmdbi7TVR4YiEx31c4fPf7//dMeISxAgVhqa2Xw3RCzCDVO+ab4Q3X/6pbRqgIQpJSqleBR
	Se6+0u0KvO207Z2X2k471tFMMEzb6HOOS0dpTlrF1fwnjeX/2mRaFGSXeOXS5eqHZtJdEkhUhnXwa
	VGVOUVvWbAoae0ffogDb/xEltqW8KkeuUB5OS/A+3Ey/eCOojv+AOgkMy7GD4aoTBkGQ3lt/xYGlU
	rnrtN0YFhq2XIY54811lImmPGQ+tAQTJYzb4adgvFfta2hbF04k4bl1Myt3NcQ3nDiLNYmDLXWARo
	L9MsS6838QWh5GmUFUJQiv0SnyVfc4ZVVgHQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOGOc-00000003eJJ-2TFW;
	Tue, 03 Nov 2026 16:25:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] ath: ath9k: uninline ar9003_paprd_create_curve() helpers
Date: Tue,  3 Nov 2026 16:25:55 +0100
Message-ID: <20261103162555.9462d171c397.I759358de0d74f858b9410a5db6918cd7e12dd877@changeid>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ar9003_paprd_create_curve() calls the two helpers, but
if they get inlined the stack can exceed 1k with clang,
causing warnings/errors. Mark the two helpers to not be
inlined due to stack ("noinline_for_stack") to fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 83d993fff695..15945689c089 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -416,7 +416,8 @@ static inline int find_proper_scale(int expn, int N)
 
 #define NUM_BIN 23
 
-static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
+static noinline_for_stack bool
+create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 {
 	unsigned int thresh_accum_cnt;
 	int x_est[NUM_BIN + 1], Y[NUM_BIN + 1], theta[NUM_BIN + 1];
@@ -817,9 +818,10 @@ void ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain)
 }
 EXPORT_SYMBOL(ar9003_paprd_setup_gain_table);
 
-static bool ar9003_paprd_retrain_pa_in(struct ath_hw *ah,
-				       struct ath9k_hw_cal_data *caldata,
-				       int chain)
+static noinline_for_stack bool
+ar9003_paprd_retrain_pa_in(struct ath_hw *ah,
+			   struct ath9k_hw_cal_data *caldata,
+			   int chain)
 {
 	u32 *pa_in = caldata->pa_table[chain];
 	int capdiv_offset, quick_drop_offset;
-- 
2.56.0

