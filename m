Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40763 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXLSQKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:03 -0500
Subject: [PATCH 124/48] libertas: discard DEFER responses to commands; let the timeout trigger
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50v2-00021A-29@pmac.infradead.org> (sfid-20071219_162048_789579_E9A5DC06)
Date: Wed, 19 Dec 2007 15:33:12 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 15:41:30 -0500

When the firmware returns 0x0004, it wants us to try again later. We can
achieve that simply by throwing out the response and letting the command
timeout code kick in.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmdresp.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 4d38461..0cd9662 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -665,6 +665,16 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		goto done;
 	}
 
+	if (resp->result == cpu_to_le16(0x0004)) {
+		/* 0x0004 means -EAGAIN. Drop the response, let it time out
+		   and be resubmitted */
+		lbs_pr_info("Firmware returns DEFER to command %x. Will let it time out...\n",
+			    le16_to_cpu(resp->command));
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
+		ret = -1;
+		goto done;
+	}
+
 	/* Now we got response from FW, cancel the command timer */
 	del_timer(&priv->command_timer);
 	priv->cmd_timed_out = 0;
-- 
1.5.3.4

