Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:25845 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753403Ab0KJDvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 22:51:08 -0500
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0344841067
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 12:51:07 +0900 (JST)
Subject: [PATCH v7] iw: Add antenna configuration commands
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, mcgrof@gmail.com, linux-wireless@vger.kernel.org
Date: Wed, 10 Nov 2010 12:51:22 +0900
Message-ID: <20101110035122.23770.72735.stgit@localhost6.localdomain6>
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
index 512e777..ec6ff63 100644
--- a/info.c
+++ b/info.c
@@ -167,6 +167,13 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 		printf("\tCoverage class: %d (up to %dm)\n", coverage, 450 * coverage);
 	}
 
+	if (tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
+	    tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
+		printf("\tAntenna: TX %#x RX %#x\n",
+		       nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX]),
+		       nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]));
+	}
+
 	if (!tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES])
 		goto commands;
 
diff --git a/phy.c b/phy.c
index 1f54ba3..d46c5f2 100644
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
+	char *end = NULL;
+	uint32_t tx_ant = 0, rx_ant = 0;
+
+	if (argc == 1) {
+		if (strcmp(*argv, "all") == 0) {
+			tx_ant = 0xffffffff;
+			rx_ant = 0xffffffff;
+		} else {
+			tx_ant = rx_ant = strtoul(argv[0], &end, 0);
+		}
+	}
+	else if (argc == 4) {
+		while (argc) {
+			if (strcmp(*argv, "tx") == 0 ||
+			    strcmp(*argv, "rx") == 0) {
+				if (strcmp(*argv, "tx") == 0)
+					tx_ant = strtoul(argv[1], &end, 0);
+				else
+					rx_ant = strtoul(argv[1], &end, 0);
+			}
+			argv = argv + 2;
+			argc = argc - 2;
+		}
+	}
+
+	if (end && *end)
+		return 1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_TX, tx_ant);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_RX, rx_ant);
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, antenna, "<bitmap> | all | tx <bitmap> rx <bitmap>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_antenna,
+	"Set a bitmap of allowed antennas to use for TX and RX.\n"
+	"The driver may reject antenna configurations it cannot support.");

