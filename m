Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38384 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbeHOBZg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 21:25:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id k3-v6so9745699pgq.5
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 15:36:18 -0700 (PDT)
From: Suren Baghdasaryan <surenb@google.com>
Cc: security@kernel.org, dan.carpenter@oracle.com, kdeus@google.com,
        surenb@google.com, Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] NFC: Fix the number of pipes
Date: Tue, 14 Aug 2018 15:35:19 -0700
Message-Id: <20180814223519.13610-1-surenb@google.com> (sfid-20180815_003620_630465_140ED191)
MIME-Version: 1.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to ETSI TS 102 622 specification chapter 4.4 pipe identifier
is 7 bits long which allows for 128 unique pipe IDs. Because
NFC_HCI_MAX_PIPES is used as the number of pipes supported and not
as the max pipe ID, its value should be 128 instead of 127.

nfc_hci_recv_from_llc extracts pipe ID from packet header using
NFC_HCI_FRAGMENT(0x7F) mask which allows for pipe ID value of 127.
Same happens when NCI_HCP_MSG_GET_PIPE() is being used. With
pipes array having only 127 elements and pipe ID of 127 the OOB memory
access will result.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/net/nfc/hci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index 316694dafa5b..008f466d1da7 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -87,7 +87,7 @@ struct nfc_hci_pipe {
  * According to specification 102 622 chapter 4.4 Pipes,
  * the pipe identifier is 7 bits long.
  */
-#define NFC_HCI_MAX_PIPES		127
+#define NFC_HCI_MAX_PIPES		128
 struct nfc_hci_init_data {
 	u8 gate_count;
 	struct nfc_hci_gate gates[NFC_HCI_MAX_CUSTOM_GATES];
-- 
2.18.0.865.gffc8e1a3cd6-goog
