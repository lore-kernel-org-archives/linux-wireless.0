Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:41344 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414Ab2FZL05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 07:26:57 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Dan Rosenberg <dan.j.rosenberg@gmail.com>,
	stable@kernel.org, security@kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/2] NFC: Prevent multiple buffer overflows in NCI
Date: Tue, 26 Jun 2012 13:37:37 +0200
Message-Id: <1340710659-15555-2-git-send-email-sameo@linux.intel.com> (sfid-20120626_132700_101928_0D413AA8)
In-Reply-To: <1340710659-15555-1-git-send-email-sameo@linux.intel.com>
References: <1340710659-15555-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

Fix multiple remotely-exploitable stack-based buffer overflows due to
the NCI code pulling length fields directly from incoming frames and
copying too much data into statically-sized arrays.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: stable@kernel.org
Cc: security@kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Ilan Elias <ilane@ti.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/nci/ntf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index cb26461..2ab196a 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -106,7 +106,7 @@ static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 	nfca_poll->sens_res = __le16_to_cpu(*((__u16 *)data));
 	data += 2;
 
-	nfca_poll->nfcid1_len = *data++;
+	nfca_poll->nfcid1_len = min_t(__u8, *data++, NFC_NFCID1_MAXSIZE);
 
 	pr_debug("sens_res 0x%x, nfcid1_len %d\n",
 		 nfca_poll->sens_res, nfca_poll->nfcid1_len);
@@ -130,7 +130,7 @@ static __u8 *nci_extract_rf_params_nfcb_passive_poll(struct nci_dev *ndev,
 			struct rf_tech_specific_params_nfcb_poll *nfcb_poll,
 						     __u8 *data)
 {
-	nfcb_poll->sensb_res_len = *data++;
+	nfcb_poll->sensb_res_len = min_t(__u8, *data++, NFC_SENSB_RES_MAXSIZE);
 
 	pr_debug("sensb_res_len %d\n", nfcb_poll->sensb_res_len);
 
@@ -145,7 +145,7 @@ static __u8 *nci_extract_rf_params_nfcf_passive_poll(struct nci_dev *ndev,
 						     __u8 *data)
 {
 	nfcf_poll->bit_rate = *data++;
-	nfcf_poll->sensf_res_len = *data++;
+	nfcf_poll->sensf_res_len = min_t(__u8, *data++, NFC_SENSF_RES_MAXSIZE);
 
 	pr_debug("bit_rate %d, sensf_res_len %d\n",
 		 nfcf_poll->bit_rate, nfcf_poll->sensf_res_len);
@@ -331,7 +331,7 @@ static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 	switch (ntf->activation_rf_tech_and_mode) {
 	case NCI_NFC_A_PASSIVE_POLL_MODE:
 		nfca_poll = &ntf->activation_params.nfca_poll_iso_dep;
-		nfca_poll->rats_res_len = *data++;
+		nfca_poll->rats_res_len = min_t(__u8, *data++, 20);
 		pr_debug("rats_res_len %d\n", nfca_poll->rats_res_len);
 		if (nfca_poll->rats_res_len > 0) {
 			memcpy(nfca_poll->rats_res,
@@ -341,7 +341,7 @@ static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 
 	case NCI_NFC_B_PASSIVE_POLL_MODE:
 		nfcb_poll = &ntf->activation_params.nfcb_poll_iso_dep;
-		nfcb_poll->attrib_res_len = *data++;
+		nfcb_poll->attrib_res_len = min_t(__u8, *data++, 50);
 		pr_debug("attrib_res_len %d\n", nfcb_poll->attrib_res_len);
 		if (nfcb_poll->attrib_res_len > 0) {
 			memcpy(nfcb_poll->attrib_res,
-- 
1.7.10

