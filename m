Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:26259 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2EGKcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:21 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 07/20] NFC: Remove unneeded pn533 dev NULL check
Date: Mon,  7 May 2012 12:31:18 +0200
Message-Id: <1336386691-24840-8-git-send-email-sameo@linux.intel.com> (sfid-20120507_123225_297880_3B3D2F1A)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

container_of() works by subtracting the offset of the member.  The math
can't really return a zero here.  Sometimes people check it when they
actually meant to check something else but in this case we can just
remove the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 766e0bb..19110f0 100644
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
-- 
1.7.9.1

