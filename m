Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33852 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbZFBOEx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 10:04:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 07:04:55 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix write callback of 'debug' which configures debug mask
Date: Tue, 2 Jun 2009 19:28:55 +0530
Message-ID: <1243951136-4033-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle error condition on copy_from_user() properly and
make sure a NUL terminated char[] is sent to strict_strtoul()
for proper conversion.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index a42d631..6d20725 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -49,8 +49,9 @@ static ssize_t read_file_debug(struct file *file, char __user *user_buf,
 {
 	struct ath_softc *sc = file->private_data;
 	char buf[32];
-	unsigned int len = 0;
-	len += snprintf(buf, sizeof(buf), "0x%08x\n", sc->debug.debug_mask);
+	unsigned int len;
+
+	len = snprintf(buf, sizeof(buf), "0x%08x\n", sc->debug.debug_mask);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -60,12 +61,17 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 	struct ath_softc *sc = file->private_data;
 	unsigned long mask;
 	char buf[32];
-	if (copy_from_user(buf, user_buf, (sizeof(buf) - 1) < count ?
-		(sizeof(buf) - 1) : count))
-		return 0;
-	buf[sizeof(buf)-1] = 0;
-	if (strict_strtoul(buf, 0, &mask) == 0)
-		sc->debug.debug_mask = mask;
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EINVAL;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &mask))
+		return -EINVAL;
+
+	sc->debug.debug_mask = mask;
 	return count;
 }
 
-- 
1.5.5.1

