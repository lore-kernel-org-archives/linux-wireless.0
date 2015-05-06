Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38061 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbbEFPb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 11:31:27 -0400
Received: by wiun10 with SMTP id n10so27018023wiu.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2015 08:31:26 -0700 (PDT)
From: andrei.otc@gmail.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH v3 5/7] mac80211: Adjust reserved chan_ctx when assigned to vif
Date: Wed,  6 May 2015 18:30:50 +0300
Message-Id: <1430926250-14732-1-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150506_173147_108944_E93E6250)
In-Reply-To: <1430916630.1954.2.camel@sipsolutions.net>
References: <1430916630.1954.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

When a vif starts using a reserved channel context (during CSA, for example)
the required chandef was recalculated, however it was never applied.
This could result in using chanctx with narrower width than actually
required. Fix this by calling ieee80211_change_chanctx with the recalculated
chandef. This both changes the chanctx's width and recalcs min_def.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/chan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5bcd4e5..0fd9274 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1008,6 +1008,8 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 	if (WARN_ON(!chandef))
 		return -EINVAL;
 
+	ieee80211_change_chanctx(local, new_ctx, chandef);
+
 	vif_chsw[0].vif = &sdata->vif;
 	vif_chsw[0].old_ctx = &old_ctx->conf;
 	vif_chsw[0].new_ctx = &new_ctx->conf;
@@ -1079,6 +1081,8 @@ ieee80211_vif_use_reserved_assign(struct ieee80211_sub_if_data *sdata)
 	if (WARN_ON(!chandef))
 		return -EINVAL;
 
+	ieee80211_change_chanctx(local, new_ctx, chandef);
+
 	list_del(&sdata->reserved_chanctx_list);
 	sdata->reserved_chanctx = NULL;
 
-- 
1.8.3

