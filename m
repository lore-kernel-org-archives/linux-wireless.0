Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:60574 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2HBW4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 18:56:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	Liang Li <liang.li@windriver.com>, <stable@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH stable] cfg80211: fix interface combinations check for ADHOC(IBSS)
Date: Thu, 2 Aug 2012 18:55:41 -0400
Message-ID: <1343948141-25005-1-git-send-email-paul.gortmaker@windriver.com> (sfid-20120803_005619_580384_689F159D)
In-Reply-To: <20120801175816.GB13879@windriver.com>
References: <20120801175816.GB13879@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liang Li <liang.li@windriver.com>

partial of commit 8e8b41f9d8c8e63fc92f899ace8da91a490ac573 upstream.

As part of commit 463454b5dbd8 ("cfg80211: fix interface
combinations check"), this extra check was introduced:

       if ((all_iftypes & used_iftypes) != used_iftypes)
               goto cont;

However, most wireless NIC drivers did not advertise ADHOC in
wiphy.iface_combinations[i].limits[] and hence we'll get -EBUSY
when we bring up a ADHOC wlan with commands similar to:

 # iwconfig wlan0 mode ad-hoc && ifconfig wlan0 up

In commit 8e8b41f9d8c8e ("cfg80211: enforce lack of interface
combinations"), the change below fixes the issue:

       if (total == 1)
               return 0;

But it also introduces other dependencies for stable. For example,
a full cherry pick of 8e8b41f9d8c8e would introduce additional
regressions unless we also start cherry picking driver specific
fixes like the following:

  9b4760e  ath5k: add possible wiphy interface combinations
  1ae2fc2  mac80211_hwsim: advertise interface combinations
  20c8e8d  ath9k: add possible wiphy interface combinations

And the purpose of the 'if (total == 1)' is to cover the specific
use case (IBSS, adhoc) that was mentioned above. So we just pick
the specific part out from 8e8b41f9d8c8e here.

Doing so gives stable kernels a way to fix the change introduced
by 463454b5dbd8, without having to make cherry picks specific to
various NIC drivers.

Cc: stable@vger.kernel.org
Signed-off-by: Liang Li <liang.li@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

3.0.35, 3.2.21 and 3.4.3 have CP of 463454b5dbd8 in them.

 net/wireless/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index b5b6890..88bd89e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -974,6 +974,9 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
+	if (total == 1)
+		return 0;
+
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
-- 
1.7.12.rc1.1.gbce1580

