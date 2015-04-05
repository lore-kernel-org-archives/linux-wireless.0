Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21103
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243AbbDEMOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2015 08:14:52 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: kernel-janitors@vger.kernel.org,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] NFC: pn533: fix error return code
Date: Sun,  5 Apr 2015 14:06:36 +0200
Message-Id: <1428235596-4757-17-git-send-email-Julia.Lawall@lip6.fr> (sfid-20150405_141547_117574_D414963F)
In-Reply-To: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/nfc/pn533.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index d46a700..732e607 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2554,8 +2554,10 @@ static int pn533_data_exchange_complete(struct pn533 *dev, void *_arg,
 	}
 
 	skb = pn533_build_response(dev);
-	if (!skb)
+	if (!skb) {
+		rc = -ENOMEM;
 		goto error;
+	}
 
 	arg->cb(arg->cb_context, skb, 0);
 	kfree(arg);

