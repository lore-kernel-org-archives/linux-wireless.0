Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:36930 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbbKYNrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:47:15 -0500
Subject: [PATCH 1/6] ath10k: fix otp board id error message
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 25 Nov 2015 15:38:05 +0200
Message-ID: <20151125133804.25507.64575.stgit@potku.adurom.net> (sfid-20151125_144718_823627_90B36BFB)
In-Reply-To: <20151125133654.25507.10863.stgit@potku.adurom.net>
References: <20151125133654.25507.10863.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We check board id from all board types, not just qca99x0, so the error message
was misleading.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f128adbae454..78fe1863ad04 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1753,7 +1753,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	ret = ath10k_core_get_board_id_from_otp(ar);
 	if (ret && ret != -EOPNOTSUPP) {
-		ath10k_err(ar, "failed to get board id from otp for qca99x0: %d\n",
+		ath10k_err(ar, "failed to get board id from otp: %d\n",
 			   ret);
 		return ret;
 	}

