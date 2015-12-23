Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30488 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012AbbLWKjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 05:39:05 -0500
From: Andrzej Hajda <a.hajda@samsung.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] NFC: nci: fix handling return value of nci_hci_create_pipe
Date: Wed, 23 Dec 2015 11:37:20 +0100
Message-id: <1450867041-729-3-git-send-email-a.hajda@samsung.com> (sfid-20151223_113957_730888_EF62AAC1)
In-reply-to: <1450867041-729-1-git-send-email-a.hajda@samsung.com>
References: <1450867041-729-1-git-send-email-a.hajda@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function return NCI_HCI_INVALID_PIPE in case of error.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2038576

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 net/nfc/nci/hci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 2aedac1..a0ab26d 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -676,7 +676,7 @@ int nci_hci_connect_gate(struct nci_dev *ndev,
 	break;
 	default:
 		pipe = nci_hci_create_pipe(ndev, dest_host, dest_gate, &r);
-		if (pipe < 0)
+		if (pipe == NCI_HCI_INVALID_PIPE)
 			return r;
 		pipe_created = true;
 		break;
-- 
1.9.1

