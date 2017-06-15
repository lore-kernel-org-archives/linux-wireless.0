Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37959 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751644AbdFORqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 13:46:22 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 1/3] NFC: digital: NFC-A SEL_RES must be one byte
Date: Thu, 15 Jun 2017 10:46:15 -0700
Message-Id: <20170615174617.1817-2-mgreer@animalcreek.com> (sfid-20170615_194636_699474_6913B748)
In-Reply-To: <20170615174617.1817-1-mgreer@animalcreek.com>
References: <20170615174617.1817-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Section 4.8.2 (SEL_RES Response) of NFC Forum's NFC Digital Protocol
Technical Specification dated 2010-11-17 clearly states that the size
of a SEL_RES Response is one byte.  Enforce this restriction in the
code.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 net/nfc/digital_technology.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/digital_technology.c b/net/nfc/digital_technology.c
index d9080dec5d27..06c4795ed647 100644
--- a/net/nfc/digital_technology.c
+++ b/net/nfc/digital_technology.c
@@ -27,6 +27,7 @@
 
 #define DIGITAL_SDD_RES_CT  0x88
 #define DIGITAL_SDD_RES_LEN 5
+#define DIGITAL_SEL_RES_LEN 1
 
 #define DIGITAL_SEL_RES_NFCID1_COMPLETE(sel_res) (!((sel_res) & 0x04))
 #define DIGITAL_SEL_RES_IS_T2T(sel_res) (!((sel_res) & 0x60))
@@ -299,7 +300,7 @@ static void digital_in_recv_sel_res(struct nfc_digital_dev *ddev, void *arg,
 		}
 	}
 
-	if (!resp->len) {
+	if (resp->len != DIGITAL_SEL_RES_LEN) {
 		rc = -EIO;
 		goto exit;
 	}
-- 
2.13.0
