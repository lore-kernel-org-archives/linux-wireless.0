Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51447 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0J0Syx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 14:54:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: fix regression:
Date: Wed, 27 Oct 2010 20:54:34 +0200
Message-Id: <1288205675-25061-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ifdef was accidentally removed in bb0324638d7301b8f87dfbee63b9633a8150cebc,
add it again.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/04-netns.patch |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/patches/04-netns.patch b/patches/04-netns.patch
index 2e17bc2..fbd9164 100644
--- a/patches/04-netns.patch
+++ b/patches/04-netns.patch
@@ -4,6 +4,18 @@ for the other changes. It'd be nice to figure out a way to
 bring thise here cleanly and seprately but they touch the same
 files...
 
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -3904,7 +3904,9 @@ static int nl80211_wiphy_netns(struct sk
+ 	if (!net_eq(wiphy_net(&rdev->wiphy), net))
+ 		err = cfg80211_switch_netns(rdev, net);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
+ 	put_net(net);
++#endif
+ 	return err;
+ }
+ 
 --- a/net/wireless/core.c
 +++ b/net/wireless/core.c
 @@ -224,6 +224,7 @@ int cfg80211_dev_rename(struct cfg80211_
-- 
1.7.1

