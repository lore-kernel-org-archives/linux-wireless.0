Return-Path: <SRS0=xK5X=SX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92E9C282E1
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Apr 2019 09:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF0DC2080D
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Apr 2019 09:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfDUJV1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Apr 2019 05:21:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:26174 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfDUJV1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Apr 2019 05:21:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Apr 2019 02:21:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,377,1549958400"; 
   d="scan'208";a="339373173"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.48])
  by fmsmga006.fm.intel.com with ESMTP; 21 Apr 2019 02:21:25 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/2] nfc/microread: use correct casting in microread_target_discovered()
Date:   Sun, 21 Apr 2019 12:12:36 +0300
Message-Id: <20190421091236.19168-3-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190421091236.19168-1-tomas.winkler@intel.com>
References: <20190421091236.19168-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix sparse warnings:

drivers/nfc/microread/microread.c:502:26: warning: cast to restricted __be16
drivers/nfc/microread/microread.c:502:26: warning: cast to restricted __be16
drivers/nfc/microread/microread.c:502:26: warning: cast to restricted __be16
drivers/nfc/microread/microread.c:502:26: warning: cast to restricted __be16
drivers/nfc/microread/microread.c:516:26: warning: cast to restricted __be16
drivers/nfc/microread/microread.c:516:26: warning: cast to restricted __be16
drivers/nfc/microread/microread.c:516:26: warning: cast to restricted __be16
drivers/nfc/microread/microread.c:516:26: warning: cast to restricted __be16
drivers/nfc/microread/microread.c:534:25: warning: cast to restricted __le16

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/nfc/microread/microread.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
index e5d5d2d97409..cc1fc8d2b04d 100644
--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -499,7 +499,7 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
 		targets->supported_protocols =
 		      nfc_hci_sak_to_protocol(skb->data[MICROREAD_EMCF_A_SAK]);
 		targets->sens_res =
-			 be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A_ATQA]);
+			 be16_to_cpup((__be16 *)&skb->data[MICROREAD_EMCF_A_ATQA]);
 		targets->sel_res = skb->data[MICROREAD_EMCF_A_SAK];
 		targets->nfcid1_len = skb->data[MICROREAD_EMCF_A_LEN];
 		if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
@@ -513,7 +513,7 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
 		targets->supported_protocols =
 		      nfc_hci_sak_to_protocol(skb->data[MICROREAD_EMCF_A3_SAK]);
 		targets->sens_res =
-			 be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A3_ATQA]);
+			 be16_to_cpup((__be16 *)&skb->data[MICROREAD_EMCF_A3_ATQA]);
 		targets->sel_res = skb->data[MICROREAD_EMCF_A3_SAK];
 		targets->nfcid1_len = skb->data[MICROREAD_EMCF_A3_LEN];
 		if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
@@ -531,7 +531,7 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
 	case MICROREAD_GATE_ID_MREAD_NFC_T1:
 		targets->supported_protocols = NFC_PROTO_JEWEL_MASK;
 		targets->sens_res =
-			le16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_T1_ATQA]);
+			le16_to_cpup((__le16 *)&skb->data[MICROREAD_EMCF_T1_ATQA]);
 		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_T1_UID], 4);
 		targets->nfcid1_len = 4;
 		break;
-- 
2.20.1

