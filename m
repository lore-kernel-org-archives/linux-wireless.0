Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52469 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab1KRNVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 08:21:18 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv4 2/2] iw: add support for NoAck per tid
Date: Fri, 18 Nov 2011 14:20:46 +0100
Message-Id: <1321622446-2477-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111118_142129_702986_EA4B86E2)
In-Reply-To: <1321622446-2477-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321622446-2477-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for the new NoAck feature in nl80211/mac80211

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 interface.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/interface.c b/interface.c
index 3a345ba..274103e 100644
--- a/interface.c
+++ b/interface.c
@@ -386,6 +386,33 @@ COMMAND(set, 4addr, "<on|off>",
 	NL80211_CMD_SET_INTERFACE, 0, CIB_NETDEV, handle_interface_4addr,
 	"Set interface 4addr (WDS) mode.");
 
+static int handle_interface_noack_map(struct nl80211_state *state,
+				      struct nl_cb *cb,
+				      struct nl_msg *msg,
+				      int argc, char **argv)
+{
+	uint16_t noack_map;
+	char *end;
+
+	if (argc != 1)
+		return 1;
+
+	noack_map = strtoul(argv[0], &end, 16);
+	if (*end)
+		return 1;
+
+	NLA_PUT_U16(msg, NL80211_ATTR_NOACK_MAP, noack_map);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+
+}
+COMMAND(set, noack_map, "<map>",
+	NL80211_CMD_SET_NOACK_MAP, 0, CIB_NETDEV, handle_interface_noack_map,
+	"Set the NoAck map for the TIDs. (0x0009 = BE, 0x0006 = BK, 0x0030 = VI, 0x00C0 = VO)");
+
+
 static int handle_interface_wds_peer(struct nl80211_state *state,
 				     struct nl_cb *cb,
 				     struct nl_msg *msg,
-- 
1.7.7.3

