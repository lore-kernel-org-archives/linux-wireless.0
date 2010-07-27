Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:26270 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752675Ab0G0Jti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 05:49:38 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0326164177
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 18:49:37 +0900 (JST)
Subject: [PATCH 2/2] iw: Add antenna configuration commands
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jul 2010 18:49:37 +0900
Message-ID: <20100727094937.27300.97445.stgit@tt-desk>
In-Reply-To: <20100727094932.27300.10253.stgit@tt-desk>
References: <20100727094932.27300.10253.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to set the antenna configuration (iw phyX set antenna ...) and
include antenna setting in wiphy information (iw phyX info).

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 info.c |    7 +++++++
 phy.c  |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/info.c b/info.c
index 512e777..dc987c7 100644
--- a/info.c
+++ b/info.c
@@ -167,6 +167,13 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 		printf("\tCoverage class: %d (up to %dm)\n", coverage, 450 * coverage);
 	}
 
+	if (tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
+	    tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
+		printf("\tAntenna: TX %d RX %d\n",
+		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX]),
+		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]));
+	}
+
 	if (!tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES])
 		goto commands;
 
diff --git a/phy.c b/phy.c
index 1f54ba3..75c80d2 100644
--- a/phy.c
+++ b/phy.c
@@ -306,3 +306,49 @@ COMMAND(set, txpower, "<auto|fixed|limit> [<tx power in mBm>]",
 COMMAND(set, txpower, "<auto|fixed|limit> [<tx power in mBm>]",
 	NL80211_CMD_SET_WIPHY, 0, CIB_NETDEV, handle_txpower,
 	"Specify transmit power level and setting type.");
+
+static int handle_antenna(struct nl80211_state *state,
+			  struct nl_cb *cb,
+			  struct nl_msg *msg,
+			  int argc, char **argv)
+{
+	char *end;
+	uint8_t tx_ant = 0, rx_ant = 0;
+
+	if (argc == 1) {
+		if (strcmp(*argv, "diversity") == 0) {
+			tx_ant = 0;
+			rx_ant = 0xf;
+		} else {
+			tx_ant = rx_ant = strtoul(argv[0], &end, 10);
+		}
+	}
+	else if (argc == 4) {
+		while (argc) {
+			if (strcmp(*argv, "tx") == 0 ||
+			    strcmp(*argv, "rx") == 0) {
+				if (strcmp(*argv, "tx") == 0)
+					tx_ant = strtoul(argv[1], &end, 10);
+				else
+					rx_ant = strtoul(argv[1], &end, 10);
+			}
+			argv = argv + 2;
+			argc = argc - 2;
+		}
+	}
+
+	if (*end)
+		return 1;
+
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_ANTENNA_TX, tx_ant);
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_ANTENNA_RX, rx_ant);
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, antenna, "<bitmap> | diversity | tx <bitmap> rx <bitmap>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_antenna,
+	"Set a bitmap of allowed antennas to use for TX and RX.\n"
+	"The driver may reject antenna configurations it cannot support.");

