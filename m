Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:44432 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYCDRYE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 12:24:04 -0500
Date: Tue, 4 Mar 2008 18:22:27 +0100
From: Sebastian Siewior <bigeasy@tglx.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] [NET] libertas: compare the current command with response
Message-ID: <20080304172227.GA14225@www.tglx.de> (sfid-20080304_172413_008232_D539243A)
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

instead of with itself.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
Holger can please ACK/NACK this? According to my debug patch, it does
the right thing.

 drivers/net/wireless/libertas/cmdresp.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 159216a..013245b 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -562,9 +562,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 	}
 
 	resp = (void *)priv->upld_buf;
-
-	curcmd = le16_to_cpu(resp->command);
-
+	curcmd = le16_to_cpu(priv->cur_cmd->cmdbuf->command);
 	respcmd = le16_to_cpu(resp->command);
 	result = le16_to_cpu(resp->result);
 
-- 
1.5.3.5

