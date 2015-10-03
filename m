Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:52759 "EHLO
	smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbJCUgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 16:36:24 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Dan Williams <dcbw@redhat.com>
Subject: airo: SIOCSIWAP (airo_set_wap) breaks scan
Date: Sat, 3 Oct 2015 22:29:58 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201510032229.58460.linux@rainbow-software.org> (sfid-20151003_223658_371892_F0B67B21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
found a weird problem while testing airo with multiple APs: the first scan
correctly shows all APs. After associating to one of them, subsequent scans
only show this single AP.

Tracked the problem down to SIOCSIWAP (airo_set_wap) - the APList rid affects
scan results. 

Clearing APList before starting scan and setting it back after scan completes
makes it work (see the patch below). Is that an acceptable solution?

BTW. Instead of being dynamically allocated, APList should be a member of
struct airo_info and track the real card's state. That would simplify this
work-around and also suspend/resume.

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 8ae838d..b4f79a7 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -3042,6 +3042,11 @@ static void airo_process_scan_results (struct airo_info *ai) {
 	}
 
 out:
+	if (ai->APList) {
+		disable_MAC(ai, 0);
+		writeAPListRid(ai, ai->APList, 0);
+		enable_MAC(ai, 0);
+	}
 	ai->scan_timeout = 0;
 	clear_bit(JOB_SCAN_RESULTS, &ai->jobs);
 	up(&ai->sem);
@@ -7233,6 +7238,7 @@ static int airo_set_scan(struct net_device *dev,
 	Cmd cmd;
 	Resp rsp;
 	int wake = 0;
+	APListRid APList_rid_empty;
 
 	/* Note : you may have realised that, as this is a SET operation,
 	 * this is privileged and therefore a normal user can't
@@ -7242,6 +7248,12 @@ static int airo_set_scan(struct net_device *dev,
 	 * Jean II */
 	if (ai->flags & FLAG_RADIO_MASK) return -ENETDOWN;
 
+	if (!ai->APList)
+		ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL);
+	if (!ai->APList)
+		return -ENOMEM;
+	readAPListRid(ai, ai->APList);
+
 	if (down_interruptible(&ai->sem))
 		return -ERESTARTSYS;
 
@@ -7250,6 +7262,13 @@ static int airo_set_scan(struct net_device *dev,
 	if (ai->scan_timeout > 0)
 		goto out;
 
+	/* Clear APList as it affects scan results */
+	memset(&APList_rid_empty, 0, sizeof(APList_rid_empty));
+	APList_rid_empty.len = cpu_to_le16(sizeof(APList_rid_empty));
+	disable_MAC(ai, 0);
+	writeAPListRid(ai, &APList_rid_empty, 0);
+	enable_MAC(ai, 0);
+
 	/* Initiate a scan command */
 	ai->scan_timeout = RUN_AT(3*HZ);
 	memset(&cmd, 0, sizeof(cmd));

-- 
Ondrej Zary
