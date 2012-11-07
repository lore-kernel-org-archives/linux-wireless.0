Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:61770 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2KGJ6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 04:58:53 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] iw: add set_mcast_rate command support
Date: Wed,  7 Nov 2012 10:58:03 +0100
Message-Id: <1352282283-31254-1-git-send-email-ordex@autistici.org> (sfid-20121107_105905_880726_D79DA8EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the support to run the set_mcast_rate() command on
adhoc and mesh_point vifs. With this command it is possible to tune
the bitrate to use when sending group frames. This command can be used
even if the vifs has already joint the ibss/mesh network.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 interface.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/interface.c b/interface.c
index 945362f..87ac617 100644
--- a/interface.c
+++ b/interface.c
@@ -490,3 +490,32 @@ static int handle_interface_wds_peer(struct nl80211_state *state,
 COMMAND(set, peer, "<MAC address>",
 	NL80211_CMD_SET_WDS_PEER, 0, CIB_NETDEV, handle_interface_wds_peer,
 	"Set interface WDS peer.");
+
+static int set_mcast_rate(struct nl80211_state *state,
+			  struct nl_cb *cb,
+			  struct nl_msg *msg,
+			  int argc, char **argv,
+			  enum id_input id)
+{
+	float rate;
+	char *end;
+
+	if (argc != 1) {
+		printf("Invalid parameters!\n");
+		return 2;
+	}
+
+	rate = strtod(argv[0], &end);
+	if (*end != '\0')
+		return 1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_MCAST_RATE, (int)(rate * 10));
+
+	return 0;
+nla_put_failure:
+	return -ENOBUFS;
+}
+
+COMMAND(set, mcast_rate, "<rate in Mbps>",
+	NL80211_CMD_SET_MCAST_RATE, 0, CIB_NETDEV, set_mcast_rate,
+	"Set the multicast bitrate.");
-- 
1.8.0

