Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:34672 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaBSKAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 05:00:51 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH 4/7] mac80211: ibss: handle cfg80211_chandef_dfs_required() error codes
Date: Wed, 19 Feb 2014 12:00:42 +0200
Message-Id: <1392804045-11258-5-git-send-email-luca@coelho.fi> (sfid-20140219_110111_559046_4DE84649)
In-Reply-To: <1392804045-11258-1-git-send-email-luca@coelho.fi>
References: <1392804045-11258-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Error codes returned by cfg80211_chandef_dfs_required() are ignored
when trying to join an IBSS.  Fix this by printing an error and
returning.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ibss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9c84b75..b558468 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -283,6 +283,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
 					    &chandef);
+	if (err < 0) {
+		sdata_info(sdata,
+			   "Failed to join IBSS, invalid chandef\n");
+		return;
+	}
 	if (err > 0) {
 		if (!ifibss->userspace_handles_dfs) {
 			sdata_info(sdata,
-- 
1.8.5.3

