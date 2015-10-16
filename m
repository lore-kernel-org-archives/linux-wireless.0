Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:34542 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbbJPTE0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 15:04:26 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] airo: fix scan after SIOCSIWAP (airo_set_wap)
Date: Fri, 16 Oct 2015 21:04:14 +0200
Message-Id: <1445022254-30428-2-git-send-email-linux@rainbow-software.org> (sfid-20151016_210458_281055_9B817C69)
In-Reply-To: <1445022254-30428-1-git-send-email-linux@rainbow-software.org>
References: <1445022254-30428-1-git-send-email-linux@rainbow-software.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SIOCSIWAP (airo_set_wap) affects scan: only the AP specified by
SIOCSIWAP is present in scan results.

This makes NetworkManager work for the first time but then unable to
find any other APs.

Clear APList before starting scan and set it back after scan completes
to work-around the problem.

To avoid losing packets during scan, modify disable_MAC() to omit
netif_carrier_off() call when lock == 2.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/wireless/airo.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 4ef2f98..17c40f0 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -3037,6 +3037,11 @@ static void airo_process_scan_results (struct airo_info *ai) {
 	}
 
 out:
+	/* write APList back (we cleared it in airo_set_scan) */
+	disable_MAC(ai, 2);
+	writeAPListRid(ai, &ai->APList, 0);
+	enable_MAC(ai, 0);
+
 	ai->scan_timeout = 0;
 	clear_bit(JOB_SCAN_RESULTS, &ai->jobs);
 	up(&ai->sem);
@@ -3608,17 +3613,18 @@ static void disable_MAC( struct airo_info *ai, int lock ) {
         Cmd cmd;
 	Resp rsp;
 
-	if (lock && down_interruptible(&ai->sem))
+	if (lock == 1 && down_interruptible(&ai->sem))
 		return;
 
 	if (test_bit(FLAG_ENABLED, &ai->flags)) {
-		netif_carrier_off(ai->dev);
+		if (lock != 2) /* lock == 2 means don't disable carrier */
+			netif_carrier_off(ai->dev);
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.cmd = MAC_DISABLE; // disable in case already enabled
 		issuecommand(ai, &cmd, &rsp);
 		clear_bit(FLAG_ENABLED, &ai->flags);
 	}
-	if (lock)
+	if (lock == 1)
 		up(&ai->sem);
 }
 
@@ -7216,6 +7222,7 @@ static int airo_set_scan(struct net_device *dev,
 	Cmd cmd;
 	Resp rsp;
 	int wake = 0;
+	APListRid APList_rid_empty;
 
 	/* Note : you may have realised that, as this is a SET operation,
 	 * this is privileged and therefore a normal user can't
@@ -7233,6 +7240,13 @@ static int airo_set_scan(struct net_device *dev,
 	if (ai->scan_timeout > 0)
 		goto out;
 
+	/* Clear APList as it affects scan results */
+	memset(&APList_rid_empty, 0, sizeof(APList_rid_empty));
+	APList_rid_empty.len = cpu_to_le16(sizeof(APList_rid_empty));
+	disable_MAC(ai, 2);
+	writeAPListRid(ai, &APList_rid_empty, 0);
+	enable_MAC(ai, 0);
+
 	/* Initiate a scan command */
 	ai->scan_timeout = RUN_AT(3*HZ);
 	memset(&cmd, 0, sizeof(cmd));
-- 
Ondrej Zary

