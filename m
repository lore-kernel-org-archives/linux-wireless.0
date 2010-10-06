Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59652 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759861Ab0JFTd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 15:33:27 -0400
Received: by qyk10 with SMTP id 10so4419864qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 12:33:26 -0700 (PDT)
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bill Jordan <bjordan@rajant.com>
Subject: [PATCH] iw: new command to set the wds peer
Date: Wed,  6 Oct 2010 15:33:16 -0400
Message-Id: <1286393596-24547-1-git-send-email-bjordan@rajant.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to set the wds peer bssid using the newly
implemented NL80211_CMD_SET_WDS_PEER.

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 interface.c |   31 +++++++++++++++++++++++++++++++
 nl80211.h   |    3 +++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/interface.c b/interface.c
index a64015f..34ed4cb 100644
--- a/interface.c
+++ b/interface.c
@@ -383,3 +383,34 @@ static int handle_interface_4addr(struct nl80211_state *state,
 COMMAND(set, 4addr, "<on|off>",
 	NL80211_CMD_SET_INTERFACE, 0, CIB_NETDEV, handle_interface_4addr,
 	"Set interface 4addr (WDS) mode.\n");
+
+static int handle_interface_wds_peer(struct nl80211_state *state,
+				 struct nl_cb *cb,
+				 struct nl_msg *msg,
+				 int argc, char **argv)
+{
+	enum nl80211_iftype mac_addr[ETH_ALEN];
+
+	if (argc < 1)
+		return 1;
+
+	if (mac_addr_a2n(mac_addr, argv[0])) {
+		fprintf(stderr, "invalid mac address\n");
+		return 2;
+	}
+
+	argc--;
+	argv++;
+
+	if (argc)
+		return 1;
+
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, peer, "<MAC address>",
+	NL80211_CMD_SET_WDS_PEER, 0, CIB_NETDEV, handle_interface_wds_peer,
+	"Set interface wds peer.\n");
diff --git a/nl80211.h b/nl80211.h
index f0518b0..35a9681 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -387,6 +387,8 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a WDS interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -489,6 +491,7 @@ enum nl80211_commands {
 	NL80211_CMD_NOTIFY_CQM,
 
 	NL80211_CMD_SET_CHANNEL,
+	NL80211_CMD_SET_WDS_PEER,
 
 	/* add new commands above here */
 
-- 
1.7.2.3

