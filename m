Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:21046 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751876Ab0LVBy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 20:54:26 -0500
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0630032863
	for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 10:54:24 +0900 (JST)
Subject: [PATCH v9] iw: Add antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 22 Dec 2010 10:54:39 +0900
Message-ID: <20101222015439.16569.9985.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to set the antenna configuration (iw phyX set antenna ...) and
include available antennas and antenna setting in wiphy information.

iw phyX info:
        Available Antennas: TX 0x3 RX 0x3
        Configured Antennas: TX 0x1 RX 0x1

iw phyX set antenna <bitmap> | all | <tx bitmap> <rx bitmap>

Signed-off-by: Bruno Randolf <br1@einfach.org>

---

v9:	Add available antennas
---
 info.c |   12 ++++++++++++
 phy.c  |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/info.c b/info.c
index 0783701..de4777f 100644
--- a/info.c
+++ b/info.c
@@ -168,6 +168,18 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 		printf("\tCoverage class: %d (up to %dm)\n", coverage, 450 * coverage);
 	}
 
+	if (tb_msg[NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX] &&
+	    tb_msg[NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX])
+		printf("\tAvailable Antennas: TX %#x RX %#x\n",
+		       nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX]),
+		       nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX]));
+
+	if (tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
+	    tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX])
+		printf("\tConfigured Antennas: TX %#x RX %#x\n",
+		       nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX]),
+		       nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]));
+
 	if (tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES]) {
 		printf("\tSupported interface modes:\n");
 		nla_for_each_nested(nl_mode, tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES], rem_mode)
diff --git a/phy.c b/phy.c
index 7c6c7c8..e3bd4e8 100644
--- a/phy.c
+++ b/phy.c
@@ -307,3 +307,42 @@ COMMAND(set, txpower, "<auto|fixed|limit> [<tx power in mBm>]",
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
+	uint32_t tx_ant = 0, rx_ant = 0;
+
+	if (argc == 1 && strcmp(argv[0], "all") == 0) {
+		tx_ant = 0xffffffff;
+		rx_ant = 0xffffffff;
+	} else if (argc == 1) {
+		tx_ant = rx_ant = strtoul(argv[0], &end, 0);
+		if (*end)
+			return 1;
+	}
+	else if (argc == 2) {
+		tx_ant = strtoul(argv[0], &end, 0);
+		if (*end)
+			return 1;
+		rx_ant = strtoul(argv[1], &end, 0);
+		if (*end)
+			return 1;
+	} else
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
+COMMAND(set, antenna, "<bitmap> | all | <tx bitmap> <rx bitmap>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_antenna,
+	"Set a bitmap of allowed antennas to use for TX and RX.\n"
+	"The driver may reject antenna configurations it cannot support.");

