Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762793AbXLMG7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:32 -0500
Subject: [PATCH 68/48] libertas: remove casts from lbs_cmd() and lbs_cmd_with_response() macros
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2p-0005sU-1D@shinybook.infradead.org> (sfid-20071213_070630_801516_CAB6841B)
Date: Thu, 13 Dec 2007 01:59:43 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 15:28:18 -0500

If stupid people like me give it arguments with the wrong type (like a
pointer to the structure, for example, instead of the structure itself),
then we should probably notice that at compile time. Otherwise, much
confusion ensues.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 716f25b..950acce 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -7,11 +7,11 @@
 #include "dev.h"
 
 #define lbs_cmd(priv, cmdnr, cmd, callback, callback_arg) \
-	__lbs_cmd(priv, cmdnr, (struct cmd_header *) &cmd, sizeof(cmd), \
+	__lbs_cmd(priv, cmdnr, &(cmd).hdr, sizeof(cmd),	  \
 			callback, callback_arg)
 
 #define lbs_cmd_with_response(priv, cmdnr, cmd) \
-	__lbs_cmd(priv, cmdnr, (struct cmd_header *) &cmd, sizeof(cmd), \
+	__lbs_cmd(priv, cmdnr, &(cmd).hdr, sizeof(cmd), \
 		  lbs_cmd_copyback, (unsigned long) &cmd)
  
 int __lbs_cmd(struct lbs_private *priv, uint16_t command,
-- 
1.5.3.4

