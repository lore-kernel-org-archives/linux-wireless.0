Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38065 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbDUIyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 04:54:06 -0400
Received: by wiun10 with SMTP id n10so13251612wiu.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2015 01:54:05 -0700 (PDT)
From: andrei.otc@gmail.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH v2 5/7] mac80211: Adjust chan_ctx when assigning reserved vif
Date: Tue, 21 Apr 2015 11:53:12 +0300
Message-Id: <1429606392-7776-1-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150421_105411_980845_C9141F65)
In-Reply-To: <1426143210-25635-5-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-5-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

When a vif is assigned to a reserved channel context (during CSA, for example)
the width of this chanctx should be adjusted to be the maximum between the
reserved chandef and all the chandefs of other assigned vifs.
Not doing so would result in using chanctx with narrower width than actually
required. Fix this by calling ieee80211_change_chanctx with the widest common
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

