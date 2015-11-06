Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:38802 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161067AbbKFL0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 06:26:32 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Christophe Ricard <christophe.ricard@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] NFC: nci: Fix error check of nci_hci_create_pipe() result
Date: Fri,  6 Nov 2015 12:26:34 +0100
Message-Id: <1446809194-25993-1-git-send-email-geert@linux-m68k.org> (sfid-20151106_122639_438803_B2D283EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/nfc/nci/hci.c: In function ‘nci_hci_connect_gate’:
net/nfc/nci/hci.c:679: warning: comparison is always false due to limited range of data type

In case of error, nci_hci_create_pipe() returns NCI_HCI_INVALID_PIPE,
and not a negative error code.

Correct the check to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/nfc/nci/hci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 2aedac15cb592353..a0ab26d535dca749 100644
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

