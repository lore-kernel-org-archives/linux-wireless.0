Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51455 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2EHEAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 00:00:46 -0400
Received: by mail-ob0-f174.google.com with SMTP id tb18so9215680obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 21:00:46 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 2/4] mac80211: Fix don't use '>' operator for matching channel types
Date: Mon,  7 May 2012 21:00:30 -0700
Message-Id: <1336449632-9057-2-git-send-email-ashok@cozybit.com> (sfid-20120508_060115_131107_E11AE312)
In-Reply-To: <1336449632-9057-1-git-send-email-ashok@cozybit.com>
References: <1336449632-9057-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes pointed out that the use of > operators for checking channel type
mismatch maynot be correct way as we may add other channel types in future.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/mesh.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0a21e4e..d3a9a6c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -109,8 +109,10 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 
 	/* Disallow HT40+/- mismatch */
 	if (ie->ht_operation &&
-	    local->_oper_channel_type > NL80211_CHAN_HT20 &&
-	    sta_channel_type > NL80211_CHAN_HT20 &&
+	    (local->_oper_channel_type == NL80211_CHAN_HT40MINUS ||
+	    local->_oper_channel_type == NL80211_CHAN_HT40PLUS) &&
+	    (sta_channel_type == NL80211_CHAN_HT40MINUS ||
+	     sta_channel_type == NL80211_CHAN_HT40PLUS) &&
 	    local->_oper_channel_type != sta_channel_type)
 		goto mismatch;
 
-- 
1.7.5.4

