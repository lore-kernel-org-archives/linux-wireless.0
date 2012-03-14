Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49883 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab2CNJLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 05:11:05 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20320.24718.586432.959379@gargle.gargle.HOWL> (sfid-20120314_101110_952178_19BB5B13)
Date: Wed, 14 Mar 2012 14:40:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/6] ath9k: Remove 'other' VIF count
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not needed and will not be used anyway since
unsupported interfaces are not allowed to be created.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/debug.c |    4 ++--
 drivers/net/wireless/ath/ath9k/main.c  |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index fa5eb30..419bf4e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -617,7 +617,6 @@ struct ath9k_vif_iter_data {
 	int nstations; /* number of station vifs */
 	int nwds;      /* number of WDS vifs */
 	int nadhocs;   /* number of adhoc vifs */
-	int nothers;   /* number of vifs not specified above. */
 };
 
 struct ath_softc {
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index c2edf68..35d1c8e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -738,9 +738,9 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"VIF-COUNTS: AP: %i STA: %i MESH: %i WDS: %i"
-			" ADHOC: %i OTHER: %i TOTAL: %hi BEACON-VIF: %hi\n",
+			" ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
 			iter_data.naps, iter_data.nstations, iter_data.nmeshes,
-			iter_data.nwds, iter_data.nadhocs, iter_data.nothers,
+			iter_data.nwds, iter_data.nadhocs,
 			sc->nvifs, sc->nbcnvifs);
 
 	if (len > sizeof(buf))
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fe1d796..77c61bc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1272,7 +1272,6 @@ static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		iter_data->nwds++;
 		break;
 	default:
-		iter_data->nothers++;
 		break;
 	}
 }
-- 
1.7.9.4

