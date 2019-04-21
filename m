Return-Path: <SRS0=xK5X=SX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2704CC10F14
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Apr 2019 09:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2C132080D
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Apr 2019 09:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfDUJV0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Apr 2019 05:21:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:26174 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfDUJVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Apr 2019 05:21:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Apr 2019 02:21:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,377,1549958400"; 
   d="scan'208";a="339373167"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.48])
  by fmsmga006.fm.intel.com with ESMTP; 21 Apr 2019 02:21:24 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/2] nfc/pn544: fix inconsistent indenting
Date:   Sun, 21 Apr 2019 12:12:35 +0300
Message-Id: <20190421091236.19168-2-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190421091236.19168-1-tomas.winkler@intel.com>
References: <20190421091236.19168-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Drop redunant space in indentation.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/nfc/pn544/pn544.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn544/pn544.c b/drivers/nfc/pn544/pn544.c
index 70e898e38b16..2aaf521f367c 100644
--- a/drivers/nfc/pn544/pn544.c
+++ b/drivers/nfc/pn544/pn544.c
@@ -704,9 +704,10 @@ static int pn544_hci_check_presence(struct nfc_hci_dev *hdev,
 		    target->nfcid1_len != 10)
 			return -EOPNOTSUPP;
 
-		 return nfc_hci_send_cmd(hdev, NFC_HCI_RF_READER_A_GATE,
-				     PN544_RF_READER_CMD_ACTIVATE_NEXT,
-				     target->nfcid1, target->nfcid1_len, NULL);
+		return nfc_hci_send_cmd(hdev, NFC_HCI_RF_READER_A_GATE,
+					PN544_RF_READER_CMD_ACTIVATE_NEXT,
+					target->nfcid1, target->nfcid1_len,
+					NULL);
 	} else if (target->supported_protocols & (NFC_PROTO_JEWEL_MASK |
 						NFC_PROTO_FELICA_MASK)) {
 		return -EOPNOTSUPP;
-- 
2.20.1

