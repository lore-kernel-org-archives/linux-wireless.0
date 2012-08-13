Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40545 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2HMTAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 15:00:44 -0400
Received: by yenl14 with SMTP id l14so2308505yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2012 12:00:43 -0700 (PDT)
Subject: Patch "cfg80211: fix interface combinations check for ADHOC(IBSS)" has been added to the 3.4-stable tree
To: paul.gortmaker@windriver.com, gregkh@linuxfoundation.org,
	johannes@sipsolutions.net, liang.li@windriver.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	stable@vger.kernel.org
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 13 Aug 2012 11:59:58 -0700
In-Reply-To: <1343948141-25005-1-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <13448843982254@kroah.org> (sfid-20120813_210047_496209_7E51BAF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    cfg80211: fix interface combinations check for ADHOC(IBSS)

to the 3.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     cfg80211-fix-interface-combinations-check-for-adhoc-ibss.patch
and it can be found in the queue-3.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From paul.gortmaker@windriver.com  Mon Aug 13 11:39:55 2012
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 2 Aug 2012 18:55:41 -0400
Subject: cfg80211: fix interface combinations check for ADHOC(IBSS)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>, Liang Li <liang.li@windriver.com>, <stable@vger.kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>
Message-ID: <1343948141-25005-1-git-send-email-paul.gortmaker@windriver.com>


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

Signed-off-by: Liang Li <liang.li@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -974,6 +974,9 @@ int cfg80211_can_change_interface(struct
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
+	if (total == 1)
+		return 0;
+
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;


Patches currently in stable-queue which might be from paul.gortmaker@windriver.com are

queue-3.4/mm-mmu_notifier-fix-freed-page-still-mapped-in-secondary-mmu.patch
queue-3.4/cfg80211-fix-interface-combinations-check-for-adhoc-ibss.patch
