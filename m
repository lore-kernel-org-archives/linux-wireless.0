Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:17842 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753888Ab1AGF7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 00:59:38 -0500
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0796339977
	for <linux-wireless@vger.kernel.org>; Fri,  7 Jan 2011 14:59:37 +0900 (JST)
Subject: [PATCH 3/4] iw: add multicast rates to IBSS join
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Date: Fri, 07 Jan 2011 15:00:36 +0900
Message-ID: <20110107060036.21507.71864.stgit@localhost6.localdomain6>
In-Reply-To: <20110107060025.21507.11061.stgit@localhost6.localdomain6>
References: <20110107060025.21507.11061.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add multicast rates to IBSS join command.

This patch comes from OpenWRT. Original author: Felix Fietkau.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 ibss.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/ibss.c b/ibss.c
index 84ea7f2..ca8a4ec 100644
--- a/ibss.c
+++ b/ibss.c
@@ -95,6 +95,20 @@ static int join_ibss(struct nl80211_state *state,
 		argc--;
 	}
 
+	/* multicast rate */
+	if (argc > 1 && strcmp(argv[0], "mcast-rate") == 0) {
+		argv++;
+		argc--;
+
+		rate = strtod(argv[0], &end);
+		if (*end != '\0')
+			return 1;
+
+		NLA_PUT_U32(msg, NL80211_ATTR_MCAST_RATE, (int) rate * 10);
+		argv++;
+		argc--;
+	}
+
 	if (!argc)
 		return 0;
 
@@ -120,12 +134,13 @@ COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
 COMMAND(ibss, join,
-	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [beacon-interval "
-	"<TU>] [basic-rates <rate in Mbps,rate2,...>] [key d:0:abcde]",
+	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [beacon-interval <TU>]"
+	" [basic-rates <rate in Mbps,rate2,...>] [mcast-rate <rate in Mbps>] "
+	"[key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
 	"Join the IBSS cell with the given SSID, if it doesn't exist create\n"
 	"it on the given frequency. When fixed frequency is requested, don't\n"
 	"join/create a cell on a different frequency. When a fixed BSSID is\n"
 	"requested use that BSSID and do not adopt another cell's BSSID even\n"
 	"if it has higher TSF and the same SSID. If an IBSS is created, create\n"
-	"it with the specified basic-rates and beacon-interval (in TU).");
+	"it with the specified basic-rates, multicast-rate and beacon-interval.");

