Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64914 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab2CDX5V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:21 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 01/22] NFC: Export NFCID1 from pn533
Date: Mon,  5 Mar 2012 01:03:33 +0100
Message-Id: <1330905834-6994-2-git-send-email-sameo@linux.intel.com> (sfid-20120305_005724_817416_E9D1FA60)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 1a1500b..8be0ae6 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -736,6 +736,8 @@ static int pn533_target_found_type_a(struct nfc_target *nfc_tgt, u8 *tgt_data,
 
 	nfc_tgt->sens_res = be16_to_cpu(tgt_type_a->sens_res);
 	nfc_tgt->sel_res = tgt_type_a->sel_res;
+	nfc_tgt->nfcid1_len = tgt_type_a->nfcid_len;
+	memcpy(nfc_tgt->nfcid1, tgt_type_a->nfcid_data, nfc_tgt->nfcid1_len);
 
 	return 0;
 }
-- 
1.7.7.3

