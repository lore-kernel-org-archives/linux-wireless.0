Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26194 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1IFP3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 11:29:35 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 1/2] ath9k: Take the samples in unassociated state
Date: Tue, 6 Sep 2011 21:00:06 +0530
Message-ID: <1315323007-1853-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110906_172944_048114_4DA6B7F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the samples debugfs which maintains the snapshorts of
mac/bb only on associated state. Hence to cover issues on idle
state, the samples are taken whenever the driver is ready.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 727e8de..bafb7b7 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1373,6 +1373,9 @@ static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
 	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	u8 nread;
 
+	if (sc->sc_flags & SC_OP_INVALID)
+		return -EAGAIN;
+
 	buf = vmalloc(size);
 	if (!buf)
 		return -ENOMEM;
@@ -1381,6 +1384,8 @@ static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
 		vfree(buf);
 		return -ENOMEM;
 	}
+	/* Account the current state too */
+	ath9k_debug_samp_bb_mac(sc);
 
 	spin_lock_bh(&sc->debug.samp_lock);
 	memcpy(bb_mac_samp, sc->debug.bb_mac_samp,
-- 
1.7.6.1

