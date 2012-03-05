Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47242 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab2CDX5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:41 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 07/22] NFC: Clear pn533 target structure
Date: Mon,  5 Mar 2012 01:03:39 +0100
Message-Id: <1330905834-6994-8-git-send-email-sameo@linux.intel.com> (sfid-20120305_005748_427659_D80F2814)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The polled target structure should be memset to 0 in order to avoid
sel_res and sens_res garbage.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 8be0ae6..a576604 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -904,6 +904,8 @@ static int pn533_target_found(struct pn533 *dev,
 	if (resp->tg != 1)
 		return -EPROTO;
 
+	memset(&nfc_tgt, 0, sizeof(struct nfc_target));
+
 	target_data_len = resp_len - sizeof(struct pn533_poll_response);
 
 	switch (dev->poll_mod_curr) {
-- 
1.7.7.3

