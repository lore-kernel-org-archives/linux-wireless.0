Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53577 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0KPA1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 19:27:46 -0500
Received: by ywg8 with SMTP id 8so41862ywg.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 16:27:46 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: johannes@sipsolutions.net
Cc: nbd@openwrt.org, Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iw: Resolve namespace clash between station plink and vlan commands
Date: Mon, 15 Nov 2010 16:27:31 -0800
Message-Id: <1289867251-21559-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch: http://osdir.com/ml/linux-wireless/2009-11/msg00981.html
kicked the command to manage mesh plinks into non-existence.  Here we
bring it back under a different name.
---
 station.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/station.c b/station.c
index 7639553..8f7fac1 100644
--- a/station.c
+++ b/station.c
@@ -204,7 +204,7 @@ COMMAND(station, del, "<MAC address>",
 	NL80211_CMD_DEL_STATION, 0, CIB_NETDEV, handle_station_get,
 	"Remove the given station entry (use with caution!)");
 
-static int handle_station_set_plink(struct nl80211_state *state,
+static int handle_station_plink(struct nl80211_state *state,
 			      struct nl_cb *cb,
 			      struct nl_msg *msg,
 			      int argc, char **argv)
@@ -222,7 +222,7 @@ static int handle_station_set_plink(struct nl80211_state *state,
 	argc--;
 	argv++;
 
-	if (strcmp("plink_action", argv[0]) != 0)
+	if (strcmp("action", argv[0]) != 0)
 		return 1;
 	argc--;
 	argv++;
@@ -248,8 +248,8 @@ static int handle_station_set_plink(struct nl80211_state *state,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(station, set, "<MAC address> plink_action <open|block>",
-	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_plink,
+COMMAND(station, plink, "<MAC address> action <open|block>",
+	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_plink,
 	"Set mesh peer link action for this station (peer).");
 
 static int handle_station_set_vlan(struct nl80211_state *state,
-- 
1.7.1

