Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13408 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab2CDX6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:04 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 14/22] NFC: Export Jewel/Topaz ID from pn533
Date: Mon,  5 Mar 2012 01:03:46 +0100
Message-Id: <1330905834-6994-15-git-send-email-sameo@linux.intel.com> (sfid-20120305_005809_749603_91D2DFD7)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The jewel ID is the NFCID1 for Topaz NFC tags.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 353bab7..f5da5ae 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -828,6 +828,8 @@ static int pn533_target_found_jewel(struct nfc_target *nfc_tgt, u8 *tgt_data,
 
 	nfc_tgt->supported_protocols = NFC_PROTO_JEWEL_MASK;
 	nfc_tgt->sens_res = be16_to_cpu(tgt_jewel->sens_res);
+	nfc_tgt->nfcid1_len = 4;
+	memcpy(nfc_tgt->nfcid1, tgt_jewel->jewelid, nfc_tgt->nfcid1_len);
 
 	return 0;
 }
-- 
1.7.7.3

