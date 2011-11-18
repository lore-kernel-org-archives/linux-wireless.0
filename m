Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47204 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1KRLCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 06:02:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv3 2/2] iw: add support for NoAck per tid
Date: Fri, 18 Nov 2011 12:01:50 +0100
Message-Id: <1321614110-32392-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111118_120220_739723_87985BC5)
In-Reply-To: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for the new NoAck feature in nl80211/mac80211

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 interface.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/interface.c b/interface.c
index 3a345ba..db38b6a 100644
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
+	if (end != (argv[0] + strlen(argv[0])))
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
+	"Set the NoAck map for the TIDs. (0x0001 = BE, 0x000e = BK, 0x0030 = VI, 0x00C0 = VO)");
+
+
 static int handle_interface_wds_peer(struct nl80211_state *state,
 				     struct nl_cb *cb,
 				     struct nl_msg *msg,
-- 
1.7.7.3

