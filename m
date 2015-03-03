Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:42318 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbCCFHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 00:07:44 -0500
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: christophe.ricard@gmail.com, sameo@linux.intel.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: st21nfca: fix st21nfca_get_iso14443_3_uid data copy
Date: Tue,  3 Mar 2015 12:58:52 +0800
Message-Id: <1425358732-31752-1-git-send-email-nicolas.iooss_linux@m4x.org> (sfid-20150303_060800_819768_D730A6C9)
In-Reply-To: <54F17F43.7060605@m4x.org>
References: <54F17F43.7060605@m4x.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

st21nfca_get_iso14443_3_uid() does not correctly copy the uid from
uid_skb->data to its gate parameter.  "gate = uid_skb->data;" only puts
a pointer to uid_skb->data to the local variable gate.  This means that
in st21nfca_hci_target_from_gate() the content of "u8
uid[NFC_NFCID1_MAXSIZE]" local variable is never initialized before
being used in memcpy(target->nfcid1, uid, len).

Fix this by replacing the local variable assignment with a memcpy.

This was found by compiling Linux with "gcc -Wunused-but-set-parameter".

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---

As I did not get any reply from https://lkml.org/lkml/2015/2/28/25 and
got confirmation by other people that this may be a real bug, I am now
sending a patch to fix it.

 drivers/nfc/st21nfca/st21nfca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/st21nfca.c b/drivers/nfc/st21nfca/st21nfca.c
index 24d3d240d5f4..ff70d2838b29 100644
--- a/drivers/nfc/st21nfca/st21nfca.c
+++ b/drivers/nfc/st21nfca/st21nfca.c
@@ -588,7 +588,7 @@ static int st21nfca_get_iso14443_3_uid(struct nfc_hci_dev *hdev, u8 *gate,
 		goto exit;
 	}
 
-	gate = uid_skb->data;
+	memcpy(gate, uid_skb->data, uid_skb->len);
 	*len = uid_skb->len;
 exit:
 	kfree_skb(uid_skb);
-- 
2.3.1

