Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49391 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2HFPNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 11:13:55 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 11:13:53 -0400
Message-ID: <CAGh4K3L_nY5B22g5oMBuoY=a1OB7U10yH1ZJvn0dG_O5TVz6+Q@mail.gmail.com> (sfid-20120806_171414_314171_08D616C4)
Subject: [PATCH]: Autosleep patch.
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch (listed below), changes an old function in autosleep.c in
kernel version 3.5. It's code is listed from the first -- line to the
2nd to last -- line.
This patch was checked with checkpatch.pl with no errors:
--
--- power/autosleep.c	2012-07-21 20:58:29.000000000 +0000
+++ power/autosleepnew.c	2012-08-06 10:52:26.000000000 +0000
@@ -30,7 +30,7 @@ static void try_to_suspend(struct work_s
 	if (!pm_get_wakeup_count(&initial_count, true))
 		goto out;

-	mutex_lock(&autosleep_lock);
+	mutex_lock_interruptable();

 	if (!pm_save_wakeup_count(initial_count)) {
 		mutex_unlock(&autosleep_lock);
Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
--

-- 
Christopher
