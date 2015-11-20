Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:62628 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932659AbbKTLku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 06:40:50 -0500
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc] PATCH v5 1/3] NFC: digital: Add Type4A tags support
Date: Fri, 20 Nov 2015 06:40:19 -0500
Message-ID: <1448019621-14259-2-git-send-email-shikha.singh@st.com> (sfid-20151120_124054_170547_EEBB0A09)
In-Reply-To: <1448019621-14259-1-git-send-email-shikha.singh@st.com>
References: <1448019621-14259-1-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The definition of DIGITAL_PROTO_NFCA_RF_TECH is modified to support
ISO14443 Type4A tags. Without this change it is not possible to start
polling for ISO14443 Type4A tags from the initiator side.

Signed-off-by: Shikha Singh <shikha.singh@st.com>
---
 net/nfc/digital_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index 23c2a11..dd9003f 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -20,7 +20,8 @@
 #include "digital.h"
 
 #define DIGITAL_PROTO_NFCA_RF_TECH \
-	(NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK | NFC_PROTO_NFC_DEP_MASK)
+	(NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK | \
+	NFC_PROTO_NFC_DEP_MASK | NFC_PROTO_ISO14443_MASK)
 
 #define DIGITAL_PROTO_NFCB_RF_TECH	NFC_PROTO_ISO14443_B_MASK
 
-- 
1.8.2.1

