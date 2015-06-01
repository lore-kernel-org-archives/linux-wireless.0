Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:50344 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751078AbbFAAos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 20:44:48 -0400
Message-ID: <1433119485.2984.36.camel@perches.com> (sfid-20150601_024507_380747_742D8C62)
Subject: [PATCH] NFC: nci: hci: Fix releasing uninitialized skbs
From: Joe Perches <joe@perches.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 31 May 2015 17:44:45 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several of these goto exit; uses should be direct returns
as skb is not yet initialized by nci_hci_get_param().

Miscellanea:

o Use !memcmp instead of memcmp() == 0
o Remove unnecessary goto from if () {... goto exit;} else {...} exit:

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/nfc/nci/hci.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index ed54ec5..af002df 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -639,22 +639,19 @@ int nci_hci_dev_session_init(struct nci_dev *ndev)
 				 ndev->hci_dev->init_data.gates[0].gate,
 				 ndev->hci_dev->init_data.gates[0].pipe);
 	if (r < 0)
-		goto exit;
+		return r;
 
 	r = nci_hci_get_param(ndev, NCI_HCI_ADMIN_GATE,
 			      NCI_HCI_ADMIN_PARAM_SESSION_IDENTITY, &skb);
 	if (r < 0)
-		goto exit;
+		return r;
 
 	if (skb->len &&
 	    skb->len == strlen(ndev->hci_dev->init_data.session_id) &&
-	    memcmp(ndev->hci_dev->init_data.session_id,
-		   skb->data, skb->len) == 0 &&
+	    !memcmp(ndev->hci_dev->init_data.session_id, skb->data, skb->len) &&
 	    ndev->ops->hci_load_session) {
 		/* Restore gate<->pipe table from some proprietary location. */
 		r = ndev->ops->hci_load_session(ndev);
-		if (r < 0)
-			goto exit;
 	} else {
 		r = nci_hci_dev_connect_gates(ndev,
 					      ndev->hci_dev->init_data.gate_count,
@@ -667,8 +664,6 @@ int nci_hci_dev_session_init(struct nci_dev *ndev)
 				      ndev->hci_dev->init_data.session_id,
 				      strlen(ndev->hci_dev->init_data.session_id));
 	}
-	if (r == 0)
-		goto exit;
 
 exit:
 	kfree_skb(skb);


