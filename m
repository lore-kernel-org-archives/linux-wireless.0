Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24276 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1IFOuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 10:50:37 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: Take the samples in unassociated state
Date: Tue, 6 Sep 2011 20:21:07 +0530
Message-ID: <1315320668-2882-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110906_165041_325560_B7AEEB03)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the samples debugfs which maintains the snapshorts of
mac/bb only on associated state. Hence to cover the unassociated
issues, the samples are taken whenever the debugfs entry is read.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 727e8de..3d377ee 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1381,6 +1381,8 @@ static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
 		vfree(buf);
 		return -ENOMEM;
 	}
+	/* Account the current state too */
+	ath9k_debug_samp_bb_mac(sc);
 
 	spin_lock_bh(&sc->debug.samp_lock);
 	memcpy(bb_mac_samp, sc->debug.bb_mac_samp,
-- 
1.7.6.1

