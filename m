Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30478 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0IQNBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 09:01:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 06:01:26 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k : Fix for displaying the channel number
Date: Fri, 17 Sep 2010 18:31:26 +0530
Message-ID: <1284728486-1058-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

In the ath9k debugging feature 'wiphy' the current channel used by the
station is incorrectly displayed.This is because the channels available
are sequentially mapped from numbers 0 to 37.This mapping cannot be
changed as the channel number is also used as an index for an array of
structures in struct ath9k_channel channels[38] .
          This fix solves the above problem by calculating the channel
number from center frequency.

Signed-off-by: Mohammed Shafi Shajakhan
<mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 54aae93..368895a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -26,6 +26,22 @@
 
 static struct dentry *ath9k_debugfs_root;
 
+static inline int center_freq_to_channel(struct ath_wiphy *aphy)
+{
+	struct ieee80211_channel *chan = aphy->hw->conf.channel ;
+	
+	if (chan->center_freq == 2484) {
+		return 14;
+	}
+	
+	if (chan->center_freq < 2484) {
+		return (chan->center_freq -2407) / 5;
+	}
+
+	return (chan->center_freq  - 5000) / 5;	
+
+}
+
 static int ath9k_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -488,6 +504,7 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
+	struct ath_wiphy *aphy =sc->pri_wiphy ;
 	char buf[512];
 	unsigned int len = 0;
 	int i;
@@ -497,7 +514,7 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 			"primary: %s (%s chan=%d ht=%d)\n",
 			wiphy_name(sc->pri_wiphy->hw->wiphy),
 			ath_wiphy_state_str(sc->pri_wiphy->state),
-			sc->pri_wiphy->chan_idx, sc->pri_wiphy->chan_is_ht);
+			center_freq_to_channel(aphy), sc->pri_wiphy->chan_is_ht);
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
 		if (aphy == NULL)
@@ -506,7 +523,7 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 				"secondary: %s (%s chan=%d ht=%d)\n",
 				wiphy_name(aphy->hw->wiphy),
 				ath_wiphy_state_str(aphy->state),
-				aphy->chan_idx, aphy->chan_is_ht);
+				center_freq_to_channel(aphy), aphy->chan_is_ht);
 	}
 
 	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
-- 
1.7.0.4

