Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762376AbYCDXAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 18:00:31 -0500
Message-Id: <200803042258.m24Mwx2X001409@imap1.linux-foundation.org> (sfid-20080304_230049_572808_65037133)
Subject: [patch (for 2.6.25?) 1/1] drivers/net/wireless/iwlwifi/iwl-4965.c: correct use of ! and &
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	julia@diku.dk, guy.cohen@intel.com, reinette.chatre@intel.com,
	tomas.winkler@intel.com, yi.zhu@intel.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2008 14:58:59 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Guy Cohen <guy.cohen@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-4965.c~drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and drivers/net/wireless/iwlwifi/iwl-4965.c
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c~drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and
+++ a/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4589,7 +4589,7 @@ static u8 iwl4965_is_fat_tx_allowed(stru
 
 	if (sta_ht_inf) {
 		if ((!sta_ht_inf->ht_supported) ||
-		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
+		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
 			return 0;
 	}
 
_
