Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:44826 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757835Ab0JSHbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 03:31:46 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0332923503
	for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 16:31:43 +0900 (JST)
Subject: [PATCH] iw: Add ibss join parameter for beacon interval
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Oct 2010 16:31:41 +0900
Message-ID: <20101019073141.14128.29518.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_ATTR_BEACON_INTERVAL already exists, we just have to use it.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 ibss.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/ibss.c b/ibss.c
index e85ef1d..e1b6765 100644
--- a/ibss.c
+++ b/ibss.c
@@ -26,6 +26,7 @@ static int join_ibss(struct nl80211_state *state,
 	int n_rates = 0;
 	char *value = NULL, *sptr = NULL;
 	float rate;
+	int bintval;
 
 	if (argc < 2)
 		return 1;
@@ -57,6 +58,15 @@ static int join_ibss(struct nl80211_state *state,
 		}
 	}
 
+	if (argc > 1 && strcmp(argv[0], "bintval") == 0) {
+		argv++;
+		argc--;
+		bintval = strtoul(argv[0], &end, 10);
+		NLA_PUT_U32(msg, NL80211_ATTR_BEACON_INTERVAL, bintval);
+		argv++;
+		argc--;
+	}
+
 	/* basic rates */
 	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
 		argv++;
@@ -108,7 +118,7 @@ COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
 COMMAND(ibss, join,
-	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] "
+	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [bintval <ms>] "
 	"[basic-rates <rate in Mbps,rate2,...>] [key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
 	"Join the IBSS cell with the given SSID, if it doesn't exist create\n"

