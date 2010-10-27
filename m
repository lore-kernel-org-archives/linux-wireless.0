Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:22177 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757033Ab0J0GCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 02:02:37 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0951579353
	for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 15:02:35 +0900 (JST)
Subject: [PATCH v3] iw: Add ibss join parameter for beacon interval
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 27 Oct 2010 15:02:37 +0900
Message-ID: <20101027060237.30291.48316.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_ATTR_BEACON_INTERVAL already exists, we just have to use it.

Signed-off-by: Bruno Randolf <br1@einfach.org>

--
v3: add minimal error checking
v2: rename from 'bintval' to 'beacon-interval' and use correct units (TU)
---
 ibss.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/ibss.c b/ibss.c
index e85ef1d..84ea7f2 100644
--- a/ibss.c
+++ b/ibss.c
@@ -26,6 +26,7 @@ static int join_ibss(struct nl80211_state *state,
 	int n_rates = 0;
 	char *value = NULL, *sptr = NULL;
 	float rate;
+	int bintval;
 
 	if (argc < 2)
 		return 1;
@@ -57,6 +58,17 @@ static int join_ibss(struct nl80211_state *state,
 		}
 	}
 
+	if (argc > 1 && strcmp(argv[0], "beacon-interval") == 0) {
+		argv++;
+		argc--;
+		bintval = strtoul(argv[0], &end, 10);
+		if (*end != '\0')
+			return 1;
+		NLA_PUT_U32(msg, NL80211_ATTR_BEACON_INTERVAL, bintval);
+		argv++;
+		argc--;
+	}
+
 	/* basic rates */
 	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
 		argv++;
@@ -108,11 +120,12 @@ COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
 COMMAND(ibss, join,
-	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] "
-	"[basic-rates <rate in Mbps,rate2,...>] [key d:0:abcde]",
+	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [beacon-interval "
+	"<TU>] [basic-rates <rate in Mbps,rate2,...>] [key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
 	"Join the IBSS cell with the given SSID, if it doesn't exist create\n"
 	"it on the given frequency. When fixed frequency is requested, don't\n"
 	"join/create a cell on a different frequency. When a fixed BSSID is\n"
 	"requested use that BSSID and do not adopt another cell's BSSID even\n"
-	"if it has higher TSF and the same SSID.");
+	"if it has higher TSF and the same SSID. If an IBSS is created, create\n"
+	"it with the specified basic-rates and beacon-interval (in TU).");

