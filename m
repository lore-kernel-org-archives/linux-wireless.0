Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62281 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbYKHVvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 16:51:00 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: rc80211_pid eliminate sparse warnings
Date: Sat,  8 Nov 2008 23:50:55 +0200
Message-Id: <1226181055-713-1-git-send-email-tomas.winkler@intel.com> (sfid-20081108_225108_075032_004D9FC6)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch eliminates sparse warnings in pid rate scale algorithm
'debugfs: allow access to signed values' patch hit the dead end
year ago w/o much echo so I guess there is no real need to address this
properly.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/rc80211_pid_algo.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 2328ba5..96ceb7e 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -403,11 +403,11 @@ static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
 						 S_IRUSR | S_IWUSR, debugfsdir,
 						 &pinfo->sampling_period);
 	de->coeff_p = debugfs_create_u32("coeff_p", S_IRUSR | S_IWUSR,
-					 debugfsdir, &pinfo->coeff_p);
+					 debugfsdir, (u32 *)&pinfo->coeff_p);
 	de->coeff_i = debugfs_create_u32("coeff_i", S_IRUSR | S_IWUSR,
-					 debugfsdir, &pinfo->coeff_i);
+					 debugfsdir, (u32 *)&pinfo->coeff_i);
 	de->coeff_d = debugfs_create_u32("coeff_d", S_IRUSR | S_IWUSR,
-					 debugfsdir, &pinfo->coeff_d);
+					 debugfsdir, (u32 *)&pinfo->coeff_d);
 	de->smoothing_shift = debugfs_create_u32("smoothing_shift",
 						 S_IRUSR | S_IWUSR, debugfsdir,
 						 &pinfo->smoothing_shift);
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

