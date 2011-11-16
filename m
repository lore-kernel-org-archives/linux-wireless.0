Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35324 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1KPMbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:31:48 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH] iw: add support for wmm NoAck per WMM Queue
Date: Wed, 16 Nov 2011 13:31:07 +0100
Message-Id: <1321446667-8348-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111116_133155_477381_250E718A)
In-Reply-To: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for the new NoAck feature in nl80211/mac80211

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 nl80211.h |    2 ++
 phy.c     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 8049bf7..3d199c6 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -2065,6 +2065,7 @@ enum nl80211_mesh_setup_params {
  * @NL80211_TXQ_ATTR_CWMAX: Maximum contention window [a value of the form
  *	2^n-1 in the range 1..32767]
  * @NL80211_TXQ_ATTR_AIFS: Arbitration interframe space [0..255]
+ * @NL80211_TXQ_ATTR_NOACK: NoAck Mode, 0 meaning normal Ack operation
  * @__NL80211_TXQ_ATTR_AFTER_LAST: Internal
  * @NL80211_TXQ_ATTR_MAX: Maximum TXQ attribute number
  */
@@ -2075,6 +2076,7 @@ enum nl80211_txq_attr {
 	NL80211_TXQ_ATTR_CWMIN,
 	NL80211_TXQ_ATTR_CWMAX,
 	NL80211_TXQ_ATTR_AIFS,
+	NL80211_TXQ_ATTR_NOACK,
 
 	/* keep last */
 	__NL80211_TXQ_ATTR_AFTER_LAST,
diff --git a/phy.c b/phy.c
index d9090fd..e5f36be 100644
--- a/phy.c
+++ b/phy.c
@@ -131,6 +131,57 @@ COMMAND(set, frag, "<fragmentation threshold|off>",
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_fragmentation,
 	"Set fragmentation threshold.");
 
+static int handle_wmm_noack(struct nl80211_state *state,
+				struct nl_cb *cb, struct nl_msg *msg,
+				int argc, char **argv)
+{
+	enum nl80211_txq_q queue;
+	unsigned int noack;
+	struct nlattr *txq, *params;
+
+	if (argc != 2)
+		return 1;
+
+	if (strcmp("VO", argv[0]) == 0)
+		queue = NL80211_TXQ_Q_VO;
+	else if (strcmp("VI", argv[0]) == 0)
+		queue = NL80211_TXQ_Q_VI;
+	else if (strcmp("BE", argv[0]) == 0)
+		queue = NL80211_TXQ_Q_BE;
+	else if (strcmp("BK", argv[0]) == 0)
+		queue = NL80211_TXQ_Q_BK;
+	else
+		return 1;
+
+	if (strcmp("off", argv[1]) == 0)
+		noack = 0;
+	else if (strcmp("on", argv[1]) == 0)
+		noack = 1;
+	else
+		return 1;
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
+	NLA_PUT_U8(msg, NL80211_TXQ_ATTR_NOACK, noack);
+	nla_nest_end(msg, params);
+	nla_nest_end(msg, txq);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, wmm_noack, "<VO|VI|BE|BK> <on|off>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_NETDEV, handle_wmm_noack,
+	"Set WMM noack policy");
+
+
 static int handle_rts(struct nl80211_state *state,
 		      struct nl_cb *cb, struct nl_msg *msg,
 		      int argc, char **argv)
-- 
1.7.7.2

