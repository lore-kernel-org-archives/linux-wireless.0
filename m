Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:46725 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2HAQOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 12:14:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	liang.li@windriver.com,
	Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] cfg80211: fix combination check for ADHOC
Date: Wed,  1 Aug 2012 12:14:23 -0400
Message-Id: <1343837663-12645-2-git-send-email-paul.gortmaker@windriver.com> (sfid-20120801_181447_474214_E2C93654)
In-Reply-To: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com>
References: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liang Li <liang.li@windriver.com>

As part of commit 463454b5dbd8 ("cfg80211: fix interface
combinations check"), this extra check was introduced:

       if ((all_iftypes & used_iftypes) != used_iftypes)
               goto cont;

However, most wireless NIC drivers did not advertise ADHOC in
wiphy.iface_combinations[i].limits[] hence we'll get -EBUSY when
we bring up a ADHOC wlan by commands similar to:

 # iwconfig wlan0 mode ad-hoc && ifconfig wlan0 up

In commit 8e8b41f9d8c8e ("cfg80211: enforce lack of interface
combinations"), the change below happens to fix the issue:

       if (total == 1)
               return 0;

But it also introduces other dependencies, at least for stable.
For example, a full cherry pick of 8e8b41f9d8c8e would introduce
additional regressions unless we also start cherry picking driver
specific fixes like the following:

9b4760e  ath5k: add possible wiphy interface combinations
1ae2fc2  mac80211_hwsim: advertise interface combinations
20c8e8d  ath9k: add possible wiphy interface combinations

It seems like we should add an exception for NL80211_IFTYPE_ADHOC, since
it is a kind of 'basic' mode, being supported by almost all wifi cards
but currently most drivers don't advertise it at all.  So making the
NL80211_IFTYPE_ADHOC a part of all_iftypes seems reasonable.

Doing so also gives stable kernels a way to fix the change introduced
by 463454b5dbd8, without having to make cherry picks specific to
various NIC drivers.

Signed-off-by: Liang Li <liang.li@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/wireless/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 26f8cd3..4a4749c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1129,6 +1129,8 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 			}
 		}
 
+		all_iftypes |= BIT(NL80211_IFTYPE_ADHOC);
+
 		/*
 		 * Finally check that all iftypes that we're currently
 		 * using are actually part of this combination. If they
-- 
1.7.11.1

