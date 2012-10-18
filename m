Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41366 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab2JRKKu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 06:10:50 -0400
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Cc: fengguang.wu@intel.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] brcmfmac: fix potential NULL dereference
Date: Thu, 18 Oct 2012 18:10:56 +0800
Message-Id: <1350555056-17775-1-git-send-email-yuanhan.liu@linux.intel.com> (sfid-20121018_121054_517585_5ED06320)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a samtch warnings catched by Fengguang's 0-DAY system:
+ drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3572 brcmf_cfg80211_sched_scan_start() error: we previously assumed 'request' could be null (see line 3571)

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c1abaa6..eaeabee 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3569,7 +3569,7 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 
 	if (!request || !request->n_ssids || !request->n_match_sets) {
 		WL_ERR("Invalid sched scan req!! n_ssids:%d\n",
-		       request->n_ssids);
+		       request ? request->n_ssids : 0);
 		return -EINVAL;
 	}
 
-- 
1.7.7.6

