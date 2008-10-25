Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:60189 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbYJYDW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 23:22:57 -0400
Message-ID: <4902910E.1000604@lwfinger.net> (sfid-20081025_052303_063402_5A6441E8)
Date: Fri, 24 Oct 2008 20:22:54 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Problem booting wireless-testing 2.6.28-rc1
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you download and boot 2.6.28-rc1 from wireless-testing, you may have a
problem in the boot process finding your hard drive. The fix has been found in
mainline and consists of the following patch:

commit e013e13bf605b9e6b702adffbe2853cfc60e7806
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Oct 24 09:22:42 2008 +0200

    libata: fix bug with non-ncq devices

    The recent commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e ("libata:
    switch to using block layer tagging support") to enable support for
    block layer tagging in libata was broken for non-NCQ devices

    The block layer initializes the tag field to -1 to detect invalid uses
    of a tag, and if the libata devices does NOT support NCQ, we just used
    that field to index the internal command list.  So we need to check for
    -1 first and only use the tag field if it's valid.

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
    Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
    Tested-by: Paul Mundt <lethal@linux-sh.org>
    Tested-by: Dave Young <hidave.darkstar@gmail.com>
    Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d5b9b72..4b95c43 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -708,7 +708,11 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct
ata_device *dev,
 {
 	struct ata_queued_cmd *qc;

-	qc = ata_qc_new_init(dev, cmd->request->tag);
+	if (cmd->request->tag != -1)
+		qc = ata_qc_new_init(dev, cmd->request->tag);
+	else
+		qc = ata_qc_new_init(dev, 0);
+
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = done;


Larry

