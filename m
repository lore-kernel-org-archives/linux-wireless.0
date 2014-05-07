Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44578 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaEGHXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 03:23:12 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so374807eei.5
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 00:23:11 -0700 (PDT)
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	ath9k-devel@lists.ath9k.org,
	Oleksij Rempel <linux@rempel-privat.de>,
	David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] ath9k: fix NULL-deref in hw_per_calibration() for ar9002
Date: Wed,  7 May 2014 09:22:58 +0200
Message-Id: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com> (sfid-20140507_092316_904231_00DDF297)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ah->caldata may be NULL if no channel is selected. Check for that before
accessing it.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
Hi

This is _definitely_ only a workaround, given that no-one guarantees ah->caldata
is freed while we run in hw_per_calibration(). However, this patch fixes serious
kernel panics with wifi-P2P on my machine.

I'm not sure why ah->caldata can be NULL, but it definitely is. I think the
correct fix would be to synchronously stop any running hw-calibration before
setting ah->caldata to NULL. I don't know whether/where that is done, so I wrote
this small workaround.

Thanks
David

 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index cdc7400..4667ab9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -99,14 +99,16 @@ static bool ar9002_hw_per_calibration(struct ath_hw *ah,
 				}
 
 				currCal->calData->calPostProc(ah, numChains);
-				caldata->CalValid |= currCal->calData->calType;
+				if (caldata)
+					caldata->CalValid |= currCal->calData->calType;
+
 				currCal->calState = CAL_DONE;
 				iscaldone = true;
 			} else {
 				ar9002_hw_setup_calibration(ah, currCal);
 			}
 		}
-	} else if (!(caldata->CalValid & currCal->calData->calType)) {
+	} else if (caldata && !(caldata->CalValid & currCal->calData->calType)) {
 		ath9k_hw_reset_calibration(ah, currCal);
 	}
 
-- 
1.9.2

