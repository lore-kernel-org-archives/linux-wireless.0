Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53528 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbbAMSZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 13:25:25 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so4594596wgg.5
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 10:25:24 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Axel Lin <axel.lin@ingics.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: hci: llc: Remove unused function
Date: Tue, 13 Jan 2015 19:28:31 +0100
Message-Id: <1421173711-4320-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20150113_192549_960913_D0BD347E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the function nfc_llc_unregister() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 net/nfc/hci/llc.c |   13 -------------
 net/nfc/hci/llc.h |    1 -
 2 files changed, 14 deletions(-)

diff --git a/net/nfc/hci/llc.c b/net/nfc/hci/llc.c
index 1b90c05..91b71e8 100644
--- a/net/nfc/hci/llc.c
+++ b/net/nfc/hci/llc.c
@@ -85,19 +85,6 @@ static struct nfc_llc_engine *nfc_llc_name_to_engine(const char *name)
 	return NULL;
 }
 
-void nfc_llc_unregister(const char *name)
-{
-	struct nfc_llc_engine *llc_engine;
-
-	llc_engine = nfc_llc_name_to_engine(name);
-	if (llc_engine == NULL)
-		return;
-
-	list_del(&llc_engine->entry);
-	kfree(llc_engine->name);
-	kfree(llc_engine);
-}
-
 struct nfc_llc *nfc_llc_allocate(const char *name, struct nfc_hci_dev *hdev,
 				 xmit_to_drv_t xmit_to_drv,
 				 rcv_to_hci_t rcv_to_hci, int tx_headroom,
diff --git a/net/nfc/hci/llc.h b/net/nfc/hci/llc.h
index 5dad4c5..f8ac1dc 100644
--- a/net/nfc/hci/llc.h
+++ b/net/nfc/hci/llc.h
@@ -51,7 +51,6 @@ struct nfc_llc {
 void *nfc_llc_get_data(struct nfc_llc *llc);
 
 int nfc_llc_register(const char *name, struct nfc_llc_ops *ops);
-void nfc_llc_unregister(const char *name);
 
 int nfc_llc_nop_register(void);
 
-- 
1.7.10.4

