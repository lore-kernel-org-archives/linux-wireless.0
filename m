Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:57947 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934642Ab3DHWTM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 18:19:12 -0400
Message-ID: <1365459552.2029.20.camel@joe-AO722> (sfid-20130409_001916_973578_3856413D)
Subject: Re: [PATCH 5/6] mac80211: stringify another plink state
From: Joe Perches <joe@perches.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Mon, 08 Apr 2013 15:19:12 -0700
In-Reply-To: <1365456467.2029.16.camel@joe-AO722>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 <1782507887.154.1365455855469.JavaMail.mail@webmail12>
	 <1365456467.2029.16.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 14:27 -0700, Joe Perches wrote:
> On Mon, 2013-04-08 at 11:06 -0700, Thomas Pedersen wrote:
> > The patch "mac80211: stringify mesh peering events" missed
> > an opportunity to print the peering state as a string.
> 
> Perhaps it's better to use functions for these instead of
> indexing in case an index is somehow incorrectly set.

Maybe:

 net/mac80211/mesh_plink.c | 73 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 937e06f..55d01d4 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -37,27 +37,55 @@ enum plink_event {
 	CLS_IGNR
 };
 
-static const char * const mplstates[] = {
-	[NL80211_PLINK_LISTEN] = "LISTEN",
-	[NL80211_PLINK_OPN_SNT] = "OPN-SNT",
-	[NL80211_PLINK_OPN_RCVD] = "OPN-RCVD",
-	[NL80211_PLINK_CNF_RCVD] = "CNF_RCVD",
-	[NL80211_PLINK_ESTAB] = "ESTAB",
-	[NL80211_PLINK_HOLDING] = "HOLDING",
-	[NL80211_PLINK_BLOCKED] = "BLOCKED"
-};
+static const char *mplstates(enum nl80211_plink_state state)
+{
+	switch (state) {
+	case NL80211_PLINK_LISTEN:
+		return "LISTEN";
+	case NL80211_PLINK_OPN_SNT:
+		return "OPN-SNT";
+	case NL80211_PLINK_OPN_RCVD:
+		return "OPN-RCVD";
+	case NL80211_PLINK_CNF_RCVD:
+		return "CNF_RCVD";
+	case NL80211_PLINK_ESTAB:
+		return "ESTAB";
+	case NL80211_PLINK_HOLDING:
+		return "HOLDING";
+	case NL80211_PLINK_BLOCKED:
+		return "BLOCKED";
+	default:
+		break;
+	}
+	return "UNKNOWN_PLINK_STATE";
+}
 
-static const char * const mplevents[] = {
-	[PLINK_UNDEFINED] = "NONE",
-	[OPN_ACPT] = "OPN_ACPT",
-	[OPN_RJCT] = "OPN_RJCT",
-	[OPN_IGNR] = "OPN_IGNR",
-	[CNF_ACPT] = "CNF_ACPT",
-	[CNF_RJCT] = "CNF_RJCT",
-	[CNF_IGNR] = "CNF_IGNR",
-	[CLS_ACPT] = "CLS_ACPT",
-	[CLS_IGNR] = "CLS_IGNR"
-};
+static const char *mplevents(enum plink_event event)
+{
+	switch (event) {
+	case PLINK_UNDEFINED:
+		return "NONE";
+	case OPN_ACPT:
+		return "OPN_ACPT";
+	case OPN_RJCT:
+		return "OPN_RJCT";
+	case OPN_IGNR:
+		return "OPN_IGNR";
+	case CNF_ACPT:
+		return "CNF_ACPT";
+	case CNF_RJCT:
+		return "CNF_RJCT";
+	case CNF_IGNR:
+		return "CNF_IGNR";
+	case CLS_ACPT:
+		return "CLS_ACPT";
+	case CLS_IGNR:
+		return "CLS_IGNR";
+	default:
+		break;
+	}
+	return "UNKNOWN_PLINK_EVENT";
+}
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_self_protected_actioncode action,
@@ -841,8 +869,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", mgmt->sa,
-		       mplstates[sta->plink_state], mplevents[event]);
+	mpl_dbg(sdata, "peer %pM in state %d (%s) got event %d (%s)\n",
+		mgmt->sa, sta->plink_state, mplstates(sta->plink_state),
+		event, mplevents(event));
 	reason = 0;
 	spin_lock_bh(&sta->lock);
 	switch (sta->plink_state) {


