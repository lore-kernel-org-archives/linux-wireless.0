Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30005 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2DMT2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 15:28:22 -0400
Date: Fri, 13 Apr 2012 22:28:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] NFC: remove unneeded NULL check
Message-ID: <20120413192812.GE18505@elgon.mountain> (sfid-20120413_212826_374965_7E9FC1BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

container_of() works by subtracting the offset of the member.  The math
can't really return a zero here.  Sometimes people check it when they
actually meant to check something else but in this case we can just
remove the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index e6ec16d..2e11da0 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -394,9 +394,6 @@ static void pn533_wq_cmd_complete(struct work_struct *work)
 	struct pn533_frame *in_frame;
 	int rc;
 
-	if (dev == NULL)
-		return;
-
 	in_frame = dev->wq_in_frame;
 
 	if (dev->wq_in_error)
