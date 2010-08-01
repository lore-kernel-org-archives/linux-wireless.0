Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.colab.de ([195.226.127.114]:53857 "EHLO mail.colab.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab0HATYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 15:24:43 -0400
From: Jochen Friedrich <jochen@scram.de>
To: linux-wireless@vger.kernel.org
Cc: Jochen Friedrich <jochen@scram.de>
Subject: [iw] Implement set 4addr.
Date: Sun,  1 Aug 2010 21:03:52 +0200
Message-Id: <1280689432-14741-1-git-send-email-jochen@scram.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 interface.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/interface.c b/interface.c
index c092aa2..e6cca4f 100644
--- a/interface.c
+++ b/interface.c
@@ -365,3 +365,16 @@ COMMAND(set, type, "<type>",
 	NL80211_CMD_SET_INTERFACE, 0, CIB_NETDEV, handle_interface_type,
 	"Set interface type/mode.\n"
 	IFACE_TYPES);
+
+static int handle_interface_4addr(struct nl80211_state *state,
+				 struct nl_cb *cb,
+				 struct nl_msg *msg,
+				 int argc, char **argv)
+{
+	if (argc != 1)
+		return 1;
+	return parse_4addr_flag(argv[0], msg);
+}
+COMMAND(set, 4addr, "<on|off>",
+	NL80211_CMD_SET_INTERFACE, 0, CIB_NETDEV, handle_interface_4addr,
+	"Set interface 4addr (WDS) mode.\n");
-- 
1.7.1

