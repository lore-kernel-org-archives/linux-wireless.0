Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5567 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbcDEP2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 11:28:49 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>, <kvalo@codeaurora.org>,
	<mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix return value for btcoex and peer stats debugfs
Date: Tue, 5 Apr 2016 20:58:26 +0530
Message-ID: <1459870106-2694-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160405_172852_140472_24AF877C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Return value is incorrect for btcoex and peer stats debugfs
'write' entries if the user provides a value that matches with
the already available debugfs entry, this results in the debugfs
entry getting stuck and the operation has to be terminated manually.
Fix this by returning the appropriate return 'count' as we do it for
other debugfs entries like pktlog etc

Fixes: cc61a1bbbc0e ("ath10k: enable debugfs provision to enable
Peer Stats feature")
Fixes: c28e6f06ff40 ("ath10k: fix sanity check on enabling btcoex via
debugfs")
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 76bbe17..e7d441c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2122,7 +2122,7 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 	struct ath10k *ar = file->private_data;
 	char buf[32];
 	size_t buf_size;
-	int ret = 0;
+	int ret;
 	bool val;
 
 	buf_size = min(count, (sizeof(buf) - 1));
@@ -2142,8 +2142,10 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 		goto exit;
 	}
 
-	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val))
+	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val)) {
+		ret = count;
 		goto exit;
+	}
 
 	if (val)
 		set_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
@@ -2189,7 +2191,7 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
 	struct ath10k *ar = file->private_data;
 	char buf[32];
 	size_t buf_size;
-	int ret = 0;
+	int ret;
 	bool val;
 
 	buf_size = min(count, (sizeof(buf) - 1));
@@ -2209,8 +2211,10 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
 		goto exit;
 	}
 
-	if (!(test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags) ^ val))
+	if (!(test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags) ^ val)) {
+		ret = count;
 		goto exit;
+	}
 
 	if (val)
 		set_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags);
-- 
1.7.9.5

