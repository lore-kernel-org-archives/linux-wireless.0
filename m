Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35355 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaANGi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 01:38:28 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so8447196pdj.39
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 22:38:28 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: use VHT phymodes for 20/40MHz channels
Date: Tue, 14 Jan 2014 12:08:17 +0530
Message-Id: <1389681497-18267-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20140114_073831_730886_CE0B0E63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

chandef does not provide 11n / 11ac split. Use the highest
phymodes for 20/40MHz channels, firmware can operate on.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7aa6c4d..e0b1a2a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -256,10 +256,10 @@ chan_to_phymode(const struct cfg80211_chan_def *chandef)
 			phymode = MODE_11A;
 			break;
 		case NL80211_CHAN_WIDTH_20:
-			phymode = MODE_11NA_HT20;
+			phymode = MODE_11AC_VHT20;
 			break;
 		case NL80211_CHAN_WIDTH_40:
-			phymode = MODE_11NA_HT40;
+			phymode = MODE_11AC_VHT40;
 			break;
 		case NL80211_CHAN_WIDTH_80:
 			phymode = MODE_11AC_VHT80;
-- 
1.7.9.5

