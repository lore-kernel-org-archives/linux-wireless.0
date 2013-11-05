Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48627 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab3KETXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:23:10 -0500
Received: by mail-pd0-f169.google.com with SMTP id q10so9020368pdj.14
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:23:09 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 16/17] mac80211: initialize llid
Date: Tue,  5 Nov 2013 11:17:04 -0800
Message-Id: <1383679025-7150-16-git-send-email-thomas@cozybit.com> (sfid-20131105_202320_555701_14CD361B)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the peer doesn't have an llid for us, the event
gathering function won't use it anyway (based on
frametype), but initialize it so gcc and coverity don't
complain.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index c6d0917..e0528b9 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -960,7 +960,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_self_protected_actioncode ftype;
 	u32 changed = 0;
 	u8 ie_len = elems->peering_len;
-	__le16 plid, llid;
+	__le16 plid, llid = 0;
 
 	if (!elems->peering) {
 		mpl_dbg(sdata,
-- 
1.8.4.rc3

