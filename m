Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.colab.de ([195.226.127.114]:38702 "EHLO mail.colab.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab0JBRyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 13:54:43 -0400
From: Jochen Friedrich <jochen@scram.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jochen Friedrich <jochen@scram.de>
Subject: [Patch] iw: Implement set 4addr.
Date: Sat,  2 Oct 2010 19:40:39 +0200
Message-Id: <1286041239-19169-1-git-send-email-jochen@scram.de>
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

