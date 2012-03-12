Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:43436 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2CLLXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 07:23:19 -0400
Subject: [PATCH 3/4] ath6kl: fix open parenthesis alignment in
 ath6kl_sdio_suspend()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 12 Mar 2012 13:23:14 +0200
Message-ID: <20120312112314.23253.26734.stgit@x201> (sfid-20120312_122322_784391_6D961182)
In-Reply-To: <20120312112131.23253.74137.stgit@x201>
References: <20120312112131.23253.74137.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl/sdio.c:875: CHECK: Alignment should match open parenthesis

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 5a03082..5352864 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -871,12 +871,13 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 		if (ret && ret != -ENOTCONN)
 			ath6kl_err("wow suspend failed: %d\n", ret);
 
-		if (ret && (!ar->wow_suspend_mode ||
-		    ar->wow_suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP))
-				try_deepsleep = true;
+		if (ret &&
+		    (!ar->wow_suspend_mode ||
+		     ar->wow_suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP))
+			try_deepsleep = true;
 		else if (ret &&
 			 ar->wow_suspend_mode == WLAN_POWER_STATE_CUT_PWR)
-				goto cut_pwr;
+			goto cut_pwr;
 		if (!ret)
 			return 0;
 	}

