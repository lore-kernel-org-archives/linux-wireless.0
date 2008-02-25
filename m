Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYBYVRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 16:17:42 -0500
Subject: [PATCH] mac80211: reorder a few fields in sta_info
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 22:17:30 +0100
Message-Id: <1203974251.13162.171.camel@johannes.berg> (sfid-20080225_211746_503938_A761A90B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Three __le16s followed by an enum (int) leave a two-byte hole
of padding which we can use for two of the other fields.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/sta_info.h	2008-02-25 22:15:37.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-25 22:15:38.000000000 +0100
@@ -249,11 +249,11 @@ struct sta_info {
 	__le16 llid;		/* Local link ID */
 	__le16 plid;		/* Peer link ID */
 	__le16 reason;		/* Buffer for cancel reason on HOLDING state */
+	u8 plink_retries;	/* Retries in establishment */
+	bool ignore_plink_timer;
 	enum plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
-	u8 plink_retries;	/* Retries in establishment */
-	bool ignore_plink_timer;
 	spinlock_t plink_lock;	/* For peer_state reads / updates and other
 				   updates in the structure. Ensures robust
 				   transitions for the peerlink FSM */


