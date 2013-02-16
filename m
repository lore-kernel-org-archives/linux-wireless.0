Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37949 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3BPSmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 13:42:24 -0500
Received: by mail-pa0-f45.google.com with SMTP id kl14so2166390pab.4
        for <linux-wireless@vger.kernel.org>; Sat, 16 Feb 2013 10:42:23 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/3] mac80211: stringify mesh peering events
Date: Sat, 16 Feb 2013 10:41:05 -0800
Message-Id: <1361040066-5771-2-git-send-email-thomas@cozybit.com> (sfid-20130216_194226_970592_6C6808F9)
In-Reply-To: <1361040066-5771-1-git-send-email-thomas@cozybit.com>
References: <1361040066-5771-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert mesh peering events into strings and make the
debug output a little easier to read. Also stop printing
the llid and plid since these don't change across peering
states and are random numbers anyway so they just amount
to noise.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index d74bdf9..07d396d 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -37,6 +37,28 @@ enum plink_event {
 	CLS_IGNR
 };
 
+static const char * const mplstates[] = {
+	[NL80211_PLINK_LISTEN] = "LISTEN",
+	[NL80211_PLINK_OPN_SNT] = "OPN-SNT",
+	[NL80211_PLINK_OPN_RCVD] = "OPN-RCVD",
+	[NL80211_PLINK_CNF_RCVD] = "CNF_RCVD",
+	[NL80211_PLINK_ESTAB] = "ESTAB",
+	[NL80211_PLINK_HOLDING] = "HOLDING",
+	[NL80211_PLINK_BLOCKED] = "BLOCKED"
+};
+
+static const char * const mplevents[] = {
+	[PLINK_UNDEFINED] = "NONE",
+	[OPN_ACPT] = "OPN_ACPT",
+	[OPN_RJCT] = "OPN_RJCT",
+	[OPN_IGNR] = "OPN_IGNR",
+	[CNF_ACPT] = "CNF_ACPT",
+	[CNF_RJCT] = "CNF_RJCT",
+	[CNF_IGNR] = "CNF_IGNR",
+	[CLS_ACPT] = "CLS_ACPT",
+	[CLS_IGNR] = "CLS_IGNR"
+};
+
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_self_protected_actioncode action,
 			       u8 *da, __le16 llid, __le16 plid, __le16 reason);
@@ -668,15 +690,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	u8 *baseaddr;
 	u32 changed = 0;
 	__le16 plid, llid, reason;
-	static const char * const mplstates[] = {
-		[NL80211_PLINK_LISTEN] = "LISTEN",
-		[NL80211_PLINK_OPN_SNT] = "OPN-SNT",
-		[NL80211_PLINK_OPN_RCVD] = "OPN-RCVD",
-		[NL80211_PLINK_CNF_RCVD] = "CNF_RCVD",
-		[NL80211_PLINK_ESTAB] = "ESTAB",
-		[NL80211_PLINK_HOLDING] = "HOLDING",
-		[NL80211_PLINK_BLOCKED] = "BLOCKED"
-	};
 
 	/* need action_code, aux */
 	if (len < IEEE80211_MIN_ACTION_SIZE + 3)
@@ -849,11 +862,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	mpl_dbg(sdata,
-		"Mesh plink (peer, state, llid, plid, event): %pM %s %d %d %d\n",
-		mgmt->sa, mplstates[sta->plink_state],
-		le16_to_cpu(sta->llid), le16_to_cpu(sta->plid),
-		event);
+	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", mgmt->sa,
+		       mplstates[sta->plink_state], mplevents[event]);
 	reason = 0;
 	spin_lock_bh(&sta->lock);
 	switch (sta->plink_state) {
-- 
1.7.10.4

