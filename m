Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34606 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYGAHo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 03:44:56 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: fix warning: unused variable ifsta
Date: Tue,  1 Jul 2008 10:44:50 +0300
Message-Id: <1214898291-6232-3-git-send-email-tomas.winkler@intel.com> (sfid-20080701_094501_229689_9CD6BA4D)
In-Reply-To: <1214898291-6232-2-git-send-email-tomas.winkler@intel.com>
References: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com>
 <1214898291-6232-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes warning unused variable ifsta
when compiling without CONFIG_MAC80211_VERBOSE_DEBUG

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4fc843e..283e55f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -366,8 +366,10 @@ static u32 ieee80211_handle_protect_preamb(struct ieee80211_sub_if_data *sdata,
 					   bool use_short_preamble)
 {
 	struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	DECLARE_MAC_BUF(mac);
+#endif
 	u32 changed = 0;
 
 	if (use_protection != bss_conf->use_cts_prot) {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

