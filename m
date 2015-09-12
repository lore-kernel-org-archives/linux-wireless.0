Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41562 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752103AbbILH20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 03:28:26 -0400
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>
Subject: [[linux-nfc] PATCH v1.0 1/3] NFC: digital: Type4A tags support
Date: Sat, 12 Sep 2015 03:21:33 -0400
Message-ID: <1442042495-2407-2-git-send-email-shikha.singh@st.com> (sfid-20150912_092829_930150_04AAE85C)
In-Reply-To: <1442042495-2407-1-git-send-email-shikha.singh@st.com>
References: <1442042495-2407-1-git-send-email-shikha.singh@st.com>
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

