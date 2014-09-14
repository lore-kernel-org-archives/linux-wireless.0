Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:39757 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaINJnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:43:23 -0400
Subject: [PATCH 09/10] ath10k: reformat help text in
 ath10k_read_simulate_fw_crash()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:44 +0300
Message-ID: <20140914095044.9063.32376.stgit@x230> (sfid-20140914_114326_141104_CD57A1B5)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes it more readable and fixes checkpatch warnings:

drivers/net/wireless/ath/ath10k/debug.c:593: WARNING: quoted string split across lines
drivers/net/wireless/ath/ath10k/debug.c:594: WARNING: quoted string split across lines
drivers/net/wireless/ath/ath10k/debug.c:595: WARNING: quoted string split across lines
drivers/net/wireless/ath/ath10k/debug.c:596: WARNING: quoted string split across lines
drivers/net/wireless/ath/ath10k/debug.c:597: WARNING: quoted string split across lines
drivers/net/wireless/ath/ath10k/debug.c:599: WARNING: quoted string split across lines
drivers/net/wireless/ath/ath10k/debug.c:600: WARNING: quoted string split across lines

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index ff914b4ac0e6..3756feba3223 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -589,15 +589,11 @@ static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
 					     char __user *user_buf,
 					     size_t count, loff_t *ppos)
 {
-	const char buf[] = "To simulate firmware crash write one of the"
-			   " keywords to this file:\n `soft` - this will send"
-			   " WMI_FORCE_FW_HANG_ASSERT to firmware if FW"
-			   " supports that command.\n `hard` - this will send"
-			   " to firmware command with illegal parameters"
-			   " causing firmware crash.\n"
-			   "`assert` - this will send special illegal parameter"
-			   " to firmware to cause assert failure"
-			   " and crash.\n";
+	const char buf[] =
+		"To simulate firmware crash write one of the keywords to this file:\n"
+		"`soft` - this will send WMI_FORCE_FW_HANG_ASSERT to firmware if FW supports that command.\n"
+		"`hard` - this will send to firmware command with illegal parameters causing firmware crash.\n"
+		"`assert` - this will send special illegal parameter to firmware to cause assert failure and crash.\n";
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 }

