Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32219 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab0JAJzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 05:55:12 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 02:55:04 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH v3] ath9k : Fix for displaying the channel number
Date: Fri, 1 Oct 2010 15:25:05 +0530
Message-ID: <1285926905-16905-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

In the ath9k debugging feature 'wiphy' the current channel used by the
station is incorrectly displayed.This is because the channels available
are sequentially mapped from numbers 0 to 37.This mapping cannot be
changed as the channel number is also used as an array index
          This fix solves the above problem by calculating the channel
number from center frequency.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d65a896..7a5932a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -488,6 +488,8 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
+	struct ath_wiphy *aphy = sc->pri_wiphy;
+	struct ieee80211_channel *chan = aphy->hw->conf.channel;
 	char buf[512];
 	unsigned int len = 0;
 	int i;
@@ -498,7 +500,8 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 			"primary: %s (%s chan=%d ht=%d)\n",
 			wiphy_name(sc->pri_wiphy->hw->wiphy),
 			ath_wiphy_state_str(sc->pri_wiphy->state),
-			sc->pri_wiphy->chan_idx, sc->pri_wiphy->chan_is_ht);
+			ieee80211_frequency_to_channel(chan->center_freq),
+			aphy->chan_is_ht);
 
 	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
 	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
@@ -545,11 +548,13 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
 		if (aphy == NULL)
 			continue;
+		chan = aphy->hw->conf.channel;
 		len += snprintf(buf + len, sizeof(buf) - len,
-				"secondary: %s (%s chan=%d ht=%d)\n",
-				wiphy_name(aphy->hw->wiphy),
-				ath_wiphy_state_str(aphy->state),
-				aphy->chan_idx, aphy->chan_is_ht);
+			"secondary: %s (%s chan=%d ht=%d)\n",
+			wiphy_name(aphy->hw->wiphy),
+			ath_wiphy_state_str(aphy->state),
+			ieee80211_frequency_to_channel(chan->center_freq),
+			aphy->chan_is_ht);
 	}
 	if (len > sizeof(buf))
 		len = sizeof(buf);
-- 
1.7.0.4

