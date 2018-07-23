Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:49950 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388125AbeGWPCC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 11:02:02 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 09/10] NFC: st95hf: two small style nits
Date: Mon, 23 Jul 2018 16:00:14 +0200
Message-Id: <20180723140015.11663-10-daniel@zonque.org> (sfid-20180723_160041_834184_54002FE4)
In-Reply-To: <20180723140015.11663-1-daniel@zonque.org>
References: <20180723140015.11663-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Address two minor style issues that I came across while working on the
driver.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 835a1e61c817..4db3c020921c 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -662,7 +662,8 @@ static int st95hf_error_handling(struct st95hf_context *stcontext,
 			result = -ETIMEDOUT;
 		else
 			result = -EIO;
-	return  result;
+
+		return result;
 	}
 
 	/* Check for CRC err only if CRC is present in the tag response */
@@ -844,6 +845,7 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	/* call of callback with error */
 	cb_arg->complete_cb(stcontext->ddev, cb_arg->cb_usrarg, skb_resp);
 	mutex_unlock(&stcontext->rm_lock);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.17.1
