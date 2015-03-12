Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbbCLGxp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 02:53:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/7] mac80211: Adjust chan_ctx when assigning reserved vif
Date: Thu, 12 Mar 2015 08:53:28 +0200
Message-Id: <1426143210-25635-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_075351_074602_CB3D6FF6)
In-Reply-To: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

It is possible to reserve a narrower channel context during csa (as long as
the chandefs are compatible). However when the reservation is used, the
channel context should be adjusted. Not doing so would result in attempts
to use higher rates than the chan_ctx supports.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/chan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index ff0d2db..aef28fd 100644
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
1.9.1

