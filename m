Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793720617;
	b=DswncGOpPXDVCTEJnjbn5D1JekGtdLtXSFCPYxVZEIm4DaoJFILXK2WuiRiE/G7x4vcE
	 QaE4GM0ELf4J3e7zK/r3luEfYD1yZw5nGLtXYB471saPKXHNev39bNoMS//5yXp6HtioA
	 GSEYmXYt2dI2CgaVZo3lrzbYo8wq+7M3ZBrZY7TcQdU7wUOeS62bvYjnhef9eWy4zGzs+
	 GutDlLw8ETDxMTnx5Ruxd+pC40lzWHErBNaJfYSp/FJCB5JV6dls/DMFFzrkCRLmqMjPM
	 /Fu07nAmqwhzK8bKprA8r/GqwFFgOQ0hGEPiAQx7fqlZS+qI50woFmwdBixFuUoQENw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720617;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWMpHil3tUiWoM/gXqxyfKt6bv1Q3LCVwmL1mluvAhA=;
	b=BbXXpm88JoAotW4RBuv3Gm9drvKtgAhbYmduxvoFWthXJIfSUOIGABMTkG4oF8k7qqnx
	 Bl3ehik6k4ofDRNNvos9HTqlBkfTYy9/gwuhCe2W7MIKlK/7BJxDzJizMrnldF2KWxBX8
	 BozK2AgsiQP8FRIZ4qMhOKxfRPgZNQa7G5rikrLyEyivdcoTPfuw20l+5kOgqrQAp41n0
	 S2lZqR5gVZBsbg+CKTI37SZhrrMohQu43mjHfpdVMDddYLfUJUzEDh/iU6s8+rRBtv7nT
	 8Qh41SBJESODkqhqZTDhBGKyRxJWVEIMg01EsISQYeGo6cClqGHfGzIYMpzILzu+nQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=rKAYCtRJ;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1151D606A33B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=rKAYCtRJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=XWMpHil3tUiWoM/gXqxyfKt6bv1Q3LCVwmL1mluvAhA=; t=1793720616; x=1794930216; 
	b=rKAYCtRJj+HwPtU7oGQPbvQV/Im0SyBhqfB/n9MDxLEPlIH0cy/dNXd552YwAOaGoxaa7joWtWG
	qm1vpOG4NfnUByRLmMJfxyLxFeDXqmWN4mK4ZNWN7Ks1bMqz+VvHODyGASjnUWH9HYGSDCfuniMnB
	6XyP0yYWEyeSNQGlIK5xVSC3HUNSXxxN3XLmpZJk1CHQ8S2AdJiW7ddzlrJ5ze1NOAP8rjEBQ2IMv
	5lJ/mkexrbnsSE5G0thnng03ONF+V6OXOHK9PH12fyaoor9Om5W1/tMJS+0tMUOSGLT8c78jAtroy
	fWVIuNdiyMqIcGpdSGgIPcNihj0aBfsMrYAg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOGfe-00000003fYd-0CUT;
	Tue, 03 Nov 2026 16:43:34 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: toke@toke.dk,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: ath9k: uninline ar9003_paprd_create_curve() helpers
Date: Tue,  3 Nov 2026 16:43:31 +0100
Message-ID: <20261103164331.d661e4447139.I759358de0d74f858b9410a5db6918cd7e12dd877@changeid>
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

