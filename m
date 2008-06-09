Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbYFIXpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 19:45:31 -0400
Message-Id: <200806092344.m59NiUfR015351@imap1.linux-foundation.org> (sfid-20080610_014537_029276_82119299)
Subject: [patch 1/1] airo: use simple_read_from_buffer()
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	akinobu.mita@gmail.com, dcbw@redhat.com, mschmidt@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2008 16:44:30 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/airo.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/net/wireless/airo.c~airo-use-simple_read_from_buffer drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~airo-use-simple_read_from_buffer
+++ a/drivers/net/wireless/airo.c
@@ -4561,22 +4561,13 @@ static ssize_t proc_read( struct file *f
 			  size_t len,
 			  loff_t *offset )
 {
-	loff_t pos = *offset;
-	struct proc_data *priv = (struct proc_data*)file->private_data;
+	struct proc_data *priv = file->private_data;
 
 	if (!priv->rbuffer)
 		return -EINVAL;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= priv->readlen)
-		return 0;
-	if (len > priv->readlen - pos)
-		len = priv->readlen - pos;
-	if (copy_to_user(buffer, priv->rbuffer + pos, len))
-		return -EFAULT;
-	*offset = pos + len;
-	return len;
+	return simple_read_from_buffer(buffer, len, offset, priv->rbuffer,
+					priv->readlen);
 }
 
 /*
_
