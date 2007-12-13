Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55901 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762691AbXLMG7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:22 -0500
Subject: [PATCH 60/48] libertas: add simple copyback command callback
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2d-0005ro-Fh@shinybook.infradead.org> (sfid-20071213_065942_411468_19CC101A)
Date: Thu, 13 Dec 2007 01:59:31 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 11 Dec 2007 12:40:35 -0500

A simple callback which copies the response back into the
command buffer that was used to send the command to the
card.  Will allow for direct command processing outside
the mega-switches in cmd.c and cmdresp.c.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   29 ++++++++++++++++++++++++++++-
 drivers/net/wireless/libertas/cmd.h |    7 +++++++
 2 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 78870c7..c4b32a0 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1972,6 +1972,34 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
 
 
 /**
+ *  @brief Simple callback that copies response back into command
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param extra  	A pointer to the original command structure for which
+ *                      'resp' is a response
+ *  @param resp         A pointer to the command response
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
+			struct cmd_header *resp)
+{
+	struct cmd_header *buf = (void *)extra;
+	uint16_t copy_len;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	copy_len = min(le16_to_cpu(buf->size), le16_to_cpu(resp->size));
+	lbs_deb_cmd("Copying back %u bytes; command response was %u bytes, "
+		    "copy back buffer was %u bytes", copy_len, resp->size,
+		    buf->size);
+	memcpy(buf, resp, copy_len);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
+/**
  *  @brief Simple way to call firmware functions
  *
  *  @param priv    	A pointer to struct lbs_private structure
@@ -1987,7 +2015,6 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
  *  @return 	   	-1 in case of a higher level error, otherwise
  *                      the result code from the firmware
  */
-
 int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	      struct cmd_header *in_cmd, int in_cmd_size,
 	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 259d3e8..72857a1 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -10,9 +10,16 @@
 	__lbs_cmd(priv, cmdnr, (struct cmd_header *) &cmd, sizeof(cmd), \
 			callback, callback_arg)
 
+#define lbs_cmd_with_response(priv, cmdnr, cmd) \
+	__lbs_cmd(priv, cmdnr, (struct cmd_header *) &cmd, sizeof(cmd), \
+		  lbs_cmd_copyback, (unsigned long) &cmd)
+ 
 int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	      struct cmd_header *in_cmd, int in_cmd_size, 
 	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	      unsigned long callback_arg);
 
+int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
+		     struct cmd_header *resp);
+
 #endif /* _LBS_CMD_H */
-- 
1.5.3.4

