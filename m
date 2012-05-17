Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:52898 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761446Ab2EQJ70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 05:59:26 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 2/2] iw: handle rts threshold per netdev
Date: Thu, 17 May 2012 11:58:43 +0200
Message-ID: <1337248723-10946-3-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120517_115930_016684_22D68CC5)
In-Reply-To: <1337248723-10946-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1337248723-10946-1-git-send-email-lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
---
 info.c      |    8 --------
 interface.c |    2 ++
 phy.c       |    3 +++
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/info.c b/info.c
index e896eb5..72bd97c 100644
--- a/info.c
+++ b/info.c
@@ -178,14 +178,6 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			printf("\tFragmentation threshold: %d\n", frag);
 	}
 
-	if (tb_msg[NL80211_ATTR_WIPHY_RTS_THRESHOLD]) {
-		unsigned int rts;
-
-		rts = nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_RTS_THRESHOLD]);
-		if (rts != (unsigned int)-1)
-			printf("\tRTS threshold: %d\n", rts);
-	}
-
 	if (tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
 		unsigned char coverage;
 
diff --git a/interface.c b/interface.c
index 6c90f9d..3fb4df4 100644
--- a/interface.c
+++ b/interface.c
@@ -281,6 +281,8 @@ static int print_iface_handler(struct nl_msg *msg, void *arg)
 		printf("%s\tifindex %d\n", indent, nla_get_u32(tb_msg[NL80211_ATTR_IFINDEX]));
 	if (tb_msg[NL80211_ATTR_IFTYPE])
 		printf("%s\ttype %s\n", indent, iftype_name(nla_get_u32(tb_msg[NL80211_ATTR_IFTYPE])));
+	if (tb_msg[NL80211_ATTR_WIPHY_RTS_THRESHOLD])
+		printf("%s\tRTS threshold: %d\n", indent, nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_RTS_THRESHOLD]));
 	if (!wiphy && tb_msg[NL80211_ATTR_WIPHY])
 		printf("%s\twiphy %d\n", indent, nla_get_u32(tb_msg[NL80211_ATTR_WIPHY]));
 	if (tb_msg[NL80211_ATTR_WIPHY_FREQ]) {
diff --git a/phy.c b/phy.c
index 839aead..2073261 100644
--- a/phy.c
+++ b/phy.c
@@ -161,6 +161,9 @@ static int handle_rts(struct nl80211_state *state,
 COMMAND(set, rts, "<rts threshold|off>",
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_rts,
 	"Set rts threshold.");
+COMMAND(set, rts, "<rts threshold|off>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_NETDEV, handle_rts,
+	"Set rts threshold.");
 
 static int handle_netns(struct nl80211_state *state,
 			struct nl_cb *cb,
-- 
1.7.0.4

