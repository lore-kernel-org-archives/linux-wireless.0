Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaFYGLv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 02:11:51 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v3] mac80211: fix dtim period propagation to the driver
Date: Wed, 25 Jun 2014 09:11:47 +0300
Message-Id: <1403676707-9568-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140625_081158_015235_62672B6D)
In-Reply-To: <1403282419-8468-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1403282419-8468-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case the beacon is heard before we try to associate,
the dtim_period was not communicated to the low level
driver. This led to disconnections with iwlmvm which needs
to know the dtim_period before it can move its firmware to
'associated' state. The following print would appear in the
log prior the disconnection.

iwlwifi: No association and the time event is over already...

Note that we usually hear the beacon only after the
association because we associate based on the probe
responses from the scan. This is why this bug has not been
discovered until now.

https://bugzilla.kernel.org/show_bug.cgi?id=78101

Cc: <stable@vger.kernel.org> [3.9+]
Fixes: c65dd1477b6f ("mac80211: inform the driver about update of dtim_period")
Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: fix typos in commit message
v3: move the assignment to the proper place (if tim)
    change the "Fixes" + stable tag
---
 net/mac80211/mlme.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e37b97d..92fd200 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4427,6 +4427,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			const struct ieee80211_tim_ie *tim;
 			tim = (void *)(tim_ie + 2);
 			ifmgd->dtim_period = tim->dtim_period;
+			sdata->vif.bss_conf.dtim_period =
+				ifmgd->dtim_period ? : 1;
 			dtim_count = tim->dtim_count;
 		}
 		ifmgd->have_beacon = true;
-- 
1.8.1.msysgit.1

