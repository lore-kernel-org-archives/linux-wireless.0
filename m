Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:47488 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab2K0VPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 16:15:16 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2] iw: allow to set wmm parameters from iw
Date: Tue, 27 Nov 2012 22:14:51 +0100
Message-Id: <1354050891-1788-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121127_221527_363862_34C8376C)
In-Reply-To: <1354042232-32428-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042232-32428-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is especially useful in IBSS mode.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
PATCHv2: rework parameter description in usage text
---
 phy.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/phy.c b/phy.c
index 860f299..5ff127a 100644
--- a/phy.c
+++ b/phy.c
@@ -359,3 +359,80 @@ COMMAND(set, antenna, "<bitmap> | all | <tx bitmap> <rx bitmap>",
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_antenna,
 	"Set a bitmap of allowed antennas to use for TX and RX.\n"
 	"The driver may reject antenna configurations it cannot support.");
+
+static int handle_wmm_params(struct nl80211_state *state,
+			     struct nl_cb *cb,
+			     struct nl_msg *msg,
+			     int argc, char **argv,
+			     enum id_input id)
+{
+	char *end;
+	struct nlattr *txq, *params;
+	int queue, cw_min, cw_max, aifs, txop;
+
+	if (argc != 5)
+		return 1;
+
+	if (!strcmp(argv[0], "VO"))
+		queue = NL80211_TXQ_Q_VO;
+	else if (!strcmp(argv[0], "VI"))
+		queue = NL80211_TXQ_Q_VI;
+	else if (!strcmp(argv[0], "BK"))
+		queue = NL80211_TXQ_Q_BK;
+	else if (!strcmp(argv[0], "BE"))
+		queue = NL80211_TXQ_Q_BE;
+	else {
+		printf("Invalid parameter: %s\n", argv[0]);
+		return 2;
+	}
+
+	if (!*argv[1] || !*argv[2] || !*argv[3] || !*argv[4])
+		return 1;
+
+	cw_min = strtoul(argv[1], &end, 0);
+	if (*end)
+		return 1;
+
+	cw_max = strtoul(argv[2], &end, 0);
+	if (*end)
+		return 1;
+
+	aifs = strtoul(argv[3], &end, 0);
+	if (*end)
+		return 1;
+
+	txop = strtoul(argv[4], &end, 0);
+	if (*end)
+		return 1;
+
+
+	txq = nla_nest_start(msg, NL80211_ATTR_WIPHY_TXQ_PARAMS);
+	if (!txq)
+		goto nla_put_failure;
+
+	params = nla_nest_start(msg, 1);
+	if (!params)
+		goto nla_put_failure;
+
+	NLA_PUT_U8(msg, NL80211_TXQ_ATTR_QUEUE, queue);
+	NLA_PUT_U16(msg, NL80211_TXQ_ATTR_CWMIN, cw_min);
+	NLA_PUT_U16(msg, NL80211_TXQ_ATTR_CWMAX, cw_max);
+	NLA_PUT_U8(msg, NL80211_TXQ_ATTR_AIFS, aifs);
+	NLA_PUT_U16(msg, NL80211_TXQ_ATTR_TXOP, txop);
+
+	nla_nest_end(msg, params);
+	nla_nest_end(msg, txq);
+
+return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, wmm_params, "<VO|VI|BE|BK> <cw_min> <cw_max> <aifs> <txop>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_NETDEV, handle_wmm_params,
+	"Set WMM parameters for a queue (VO, VI, BE, or BK):\n"
+	" * cw_min/cw_max - contention window minimum/maximum\n"
+	"                   (a value of the form 2^n-1 in the range 1..32767)\n"
+	" * aifs - arbitration interframe spacing (0..255)\n"
+	" * txop - maximum burst time in units of 32 usecs, 0 meaning disabled\n"
+	);
-- 
1.7.10.4

