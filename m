Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40757 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbXLSQJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:09:54 -0500
Subject: [PATCH 132/48] libertas: change inference about buffer size in lbs_cmd()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50vJ-000220-2G@pmac.infradead.org> (sfid-20071219_160956_799362_003F33D1)
Date: Wed, 19 Dec 2007 15:33:29 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 19 Dec 2007 13:03:19 +0000

sizeof(*cmd) is going to give the total size of the data structure that
we allocated, more often than not. But the size of the command to be
_sent_ could be a lot smaller, as it is in the KEY_MATERIAL and
SUBSCRIBE_EVENT commands for example. So swap them round; let the caller
set the _command_ size explicitly in the header, and infer the
maximum response size from the data structure.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 6efb81e..b9ab85c 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -6,13 +6,15 @@
 #include "hostcmd.h"
 #include "dev.h"
 
-#define lbs_cmd(priv, cmdnr, cmd, cb, cb_arg)	\
-	__lbs_cmd(priv, cmdnr, &(cmd)->hdr, sizeof(*(cmd)), cb, cb_arg)
+/* lbs_cmd() infers the size of the buffer to copy data back into, from
+   the size of the target of the pointer. Since the command to be sent 
+   may often be smaller, that size is set in cmd->size by the caller.*/
+#define lbs_cmd(priv, cmdnr, cmd, cb, cb_arg)	({		\
+	uint16_t __sz = le16_to_cpu((cmd)->hdr.size);		\
+	(cmd)->hdr.size = cpu_to_le16(sizeof(*(cmd)));		\
+	__lbs_cmd(priv, cmdnr, &(cmd)->hdr, __sz, cb, cb_arg);	\
+})
 
-
-/* lbs_cmd_with_response() infers the size of the command to be _sent_
-   and requires that the caller sets cmd->size to the (LE) size of
-   the _response_ buffer. */
 #define lbs_cmd_with_response(priv, cmdnr, cmd)	\
 	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
 
-- 
1.5.3.4

