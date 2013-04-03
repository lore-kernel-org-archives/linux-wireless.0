Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38721 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759911Ab3DCQbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:31:50 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, siwu@hrz.tu-chemnitz.de,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 2/3] ath9k: add debugfs based DFS radar simulation
Date: Wed,  3 Apr 2013 18:31:30 +0200
Message-Id: <1365006691-16705-3-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_183211_821909_69FFB3C5)
In-Reply-To: <1365006691-16705-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1365006691-16705-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps testing DFS without radar generating
equipment and is required for certification.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs_debug.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 55d2807..b7611b7 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -105,6 +105,24 @@ static ssize_t write_file_dfs(struct file *file, const char __user *user_buf,
 	return count;
 }
 
+static ssize_t write_file_simulate_radar(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+
+	ieee80211_radar_detected(sc->hw);
+
+	return count;
+}
+
+static const struct file_operations fops_simulate_radar = {
+	.write = write_file_simulate_radar,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static const struct file_operations fops_dfs_stats = {
 	.read = read_file_dfs,
 	.write = write_file_dfs,
@@ -117,4 +135,6 @@ void ath9k_dfs_init_debug(struct ath_softc *sc)
 {
 	debugfs_create_file("dfs_stats", S_IRUSR,
 			    sc->debug.debugfs_phy, sc, &fops_dfs_stats);
+	debugfs_create_file("dfs_simulate_radar", S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_simulate_radar);
 }
-- 
1.7.4.1

