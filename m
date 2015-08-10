Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33312 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbbHJIBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 04:01:00 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Benjamin Romer <benjamin.romer@unisys.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>, HPDD-discuss@lists.01.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 2/3] Staging: lustre: libcfs: Remove unnecessary cast on void*
Date: Mon, 10 Aug 2015 13:30:34 +0530
Message-Id: <1439193635-6063-2-git-send-email-shraddha.6596@gmail.com> (sfid-20150810_100219_512502_53AB92B3)
In-Reply-To: <1439193635-6063-1-git-send-email-shraddha.6596@gmail.com>
References: <1439193635-6063-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch does away with the cast on void * as it is unnecessary.

Semantic patch used is as follows:

@r@
expression x;
void* e;
type T;
identifier f;
@@
(
  *((T *)e)
|
  ((T *)x)[...]
|
  ((T *)x)->f
|
- (void *)
  e
)

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index 1ab4232..ef8f126 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -335,7 +335,7 @@ static int libcfs_ioctl(struct cfs_psdev_file *pfile, unsigned long cmd, void *a
 		return -ENOMEM;
 
 	/* 'cmd' and permissions get checked in our arch-specific caller */
-	if (libcfs_ioctl_getdata(buf, buf + 800, (void *)arg)) {
+	if (libcfs_ioctl_getdata(buf, buf + 800, arg)) {
 		CERROR("PORTALS ioctl: data error\n");
 		err = -EINVAL;
 		goto out;
-- 
2.1.0

