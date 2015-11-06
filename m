Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:26483 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965406AbbKFTed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 14:34:33 -0500
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc] PATCH v3 1/3] NFC: digital: Type4A tags support
Date: Fri, 6 Nov 2015 14:34:00 -0500
Message-ID: <1446838442-10964-2-git-send-email-shikha.singh@st.com> (sfid-20151106_203442_082593_25977E7C)
In-Reply-To: <1446838442-10964-1-git-send-email-shikha.singh@st.com>
References: <1446838442-10964-1-git-send-email-shikha.singh@st.com>
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
index 009bcf3..7067970 100644
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

