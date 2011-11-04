Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44786 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1KDNEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 09:04:23 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix error in writing create_qos debugfs
Date: Fri, 4 Nov 2011 18:34:55 +0530
Message-ID: <1320411895-4828-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111104_140426_670234_CF49C4D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

100 bytes are allocated to store the parameters which are needed
to create a priority stream. These 100 bytes are not sufficiant and
throws error when running the following command.

echo "6 2 3 1 1 9999999 9999999 9999999 7777777 0 6 45000 200 56789000
 56789000 5678900 0 0 9999999 20000 0" > create_qos

179 bytes are needed when the following vlaues are given so that
a maximum possible value in that data type can be given in decimal.

echo "255 255 255 255 255 4294967295 4294967295 4294967295 4294967295
 4294967295 255 65535 65535 4294967295 4294967295 4294967295 4294967295
 4294967295 4294967295 4294967295 4294967295" > create_qos

Following takes 187 bytes when given in hex

echo "0xff 0xff 0xff 0xff 0xff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff
 0xff 0xffff 0xffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff
 0xffffffff 0xffffffff" > create_qos

Increase the size to 200 bytes so that it can hold upto the maximum
value possible for that data type.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 70ea137..370664a 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1252,7 +1252,7 @@ static ssize_t ath6kl_create_qos_write(struct file *file,
 
 	struct ath6kl *ar = file->private_data;
 	struct ath6kl_vif *vif;
-	char buf[100];
+	char buf[200];
 	ssize_t len;
 	char *sptr, *token;
 	struct wmi_create_pstream_cmd pstream;
-- 
1.7.0.4

