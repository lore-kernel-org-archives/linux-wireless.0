Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57090 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbeGXLFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:33 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v3 01/11] Revert "NFC: st95hf: drop illegal kfree_skb()"
Date: Tue, 24 Jul 2018 11:59:31 +0200
Message-Id: <20180724095941.25777-2-daniel@zonque.org> (sfid-20180724_120136_983613_87124ABD)
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
References: <20180724095941.25777-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit c99f996b2ba49 ("NFC: st95hf: drop illegal
kfree_skb()").

It turns out that the st95hf_in_send_cmd() is in fact the sole owner of
this skb, and by not freeing it here, we not only causing a memory leak
but also mess up the refcount of the socket that holds it. This will in
turn lead to activated targets not being cleaned up, even after
stopping userspace processes.

The memory corruption that I was hunting was caused by another
kfree_skb(). This will be fixed in a later commit.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Fixes: c99f996b2ba49 ("NFC: st95hf: drop illegal kfree_skb()")
---
 drivers/nfc/st95hf/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 36ef0e905ba3..bc1a2070f9bb 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -991,6 +991,8 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 		goto free_skb_resp;
 	}
 
+	kfree_skb(skb);
+
 	return rc;
 
 free_skb_resp:
-- 
2.17.1
