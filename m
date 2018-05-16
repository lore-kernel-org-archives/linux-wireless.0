Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35186 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752585AbeEPNcy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 09:32:54 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 2/2] NFC: st95hf: drop illegal kfree_skb()
Date: Wed, 16 May 2018 15:32:47 +0200
Message-Id: <20180516133247.25986-2-daniel@zonque.org> (sfid-20180516_153355_440838_EAACDC5A)
In-Reply-To: <20180516133247.25986-1-daniel@zonque.org>
References: <20180516133247.25986-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The skb that is passed in to ->in_send_cmd() is freed by the core when the
function returns. Calling kfree_skb() on it from the driver callback will
hence lead to a double-free.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 394bdc7b0cf2..a50a95cfcfd8 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -995,8 +995,6 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 		goto free_skb_resp;
 	}
 
-	kfree_skb(skb);
-
 	return rc;
 
 free_skb_resp:
-- 
2.14.3
