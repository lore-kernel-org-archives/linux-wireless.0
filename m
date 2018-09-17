Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728317AbeIQTTi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 15:19:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: sameo@linux.intel.com, davem@davemloft.net, netdev@vger.kernel.org
Cc: allen.pais@oracle.com, keescook@chromium.org, surenb@google.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] NFC: Fix the number of pipes
Date: Mon, 17 Sep 2018 15:51:41 +0200
Message-Id: <20180917135141.28328-3-gregkh@linuxfoundation.org> (sfid-20180917_155229_115184_2FF180FB)
In-Reply-To: <20180917135141.28328-1-gregkh@linuxfoundation.org>
References: <20180917135141.28328-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Suren Baghdasaryan <surenb@google.com>

According to ETSI TS 102 622 specification chapter 4.4 pipe identifier
is 7 bits long which allows for 128 unique pipe IDs. Because
NFC_HCI_MAX_PIPES is used as the number of pipes supported and not
as the max pipe ID, its value should be 128 instead of 127.

nfc_hci_recv_from_llc extracts pipe ID from packet header using
NFC_HCI_FRAGMENT(0x7F) mask which allows for pipe ID value of 127.
Same happens when NCI_HCP_MSG_GET_PIPE() is being used. With
pipes array having only 127 elements and pipe ID of 127 the OOB memory
access will result.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Allen Pais <allen.pais@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.19.0
