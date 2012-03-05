Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab2CDX6B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:01 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 13/22] NFC: Export sensf from pn533
Date: Mon,  5 Mar 2012 01:03:45 +0100
Message-Id: <1330905834-6994-14-git-send-email-sameo@linux.intel.com> (sfid-20120305_005807_337290_BB769EF8)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sensf is the detection response for Felica NFC tags.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index a576604..353bab7 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -783,6 +783,9 @@ static int pn533_target_found_felica(struct nfc_target *nfc_tgt, u8 *tgt_data,
 	else
 		nfc_tgt->supported_protocols = NFC_PROTO_FELICA_MASK;
 
+	memcpy(nfc_tgt->sensf_res, &tgt_felica->opcode, 9);
+	nfc_tgt->sensf_res_len = 9;
+
 	return 0;
 }
 
-- 
1.7.7.3

