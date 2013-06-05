Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:41463
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751046Ab3FEDhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 23:37:11 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next] cw1200:  Sanity-check arguments in copy_from_user()
Date: Tue,  4 Jun 2013 23:37:05 -0400
Message-Id: <1370403425-22131-1-git-send-email-pizza@shaftnet.org> (sfid-20130605_053714_676103_2436B73B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The optional debugfs interface to the vendor's engineering tools wasn't
bounds checking at all, which made it trivial to perform a buffer
overflow if this interface was compiled in and then explicitly enabled 
at runtime.

This patch checks both the length supplied as part of the data to ensure
it is sane, and also the amount of data compared to the remaining buffer
space.  If either is too large, fail immediately.

(This bug was spotted by Dan Carpenter <dan.carpenter@oracle.com>)

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/debug.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/cw1200/debug.c b/drivers/net/wireless/cw1200/debug.c
index b815181..1aeef5e 100644
--- a/drivers/net/wireless/cw1200/debug.c
+++ b/drivers/net/wireless/cw1200/debug.c
@@ -403,13 +403,13 @@ struct etf_req_msg;
 static int etf_request(struct cw1200_common *priv,
 		       struct etf_req_msg *msg, u32 len);
 
-#define MAX_RX_SZE 2600
+#define MAX_RX_SIZE 2600
 
 struct etf_in_state {
 	struct cw1200_common *priv;
-	u32 total_len;
-	u8 buf[MAX_RX_SZE];
-	u32 written;
+	u16 total_len;
+	u16 written;
+	u8 buf[MAX_RX_SIZE];
 };
 
 static int cw1200_etf_in_open(struct inode *inode, struct file *file)
@@ -454,6 +454,11 @@ static ssize_t cw1200_etf_in_write(struct file *file,
 			return -EFAULT;
 		}
 
+		if (etf->total_len > MAX_RX_SIZE) {
+			pr_err("requested length > MAX_RX_SIZE\n");
+			return -EINVAL;
+		}
+
 		written += sizeof(etf->total_len);
 		count -= sizeof(etf->total_len);
 	}
@@ -461,6 +466,11 @@ static ssize_t cw1200_etf_in_write(struct file *file,
 	if (!count)
 		goto done;
 
+	if (count > (etf->total_len - written)) {
+		pr_err("Tried to write > MAX_RX_SIZE\n");
+		return -EINVAL;
+	}
+
 	if (copy_from_user(etf->buf + etf->written, user_buf + written,
 			   count)) {
 		pr_err("copy_from_user (payload %zu) failed\n", count);
-- 
1.8.2.1

