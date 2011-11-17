Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35354 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1KQVsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:48:12 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wifi-debugfs: Fix AMSDU rate printout.
Date: Thu, 17 Nov 2011 13:48:07 -0800
Message-Id: <1321566487-31705-1-git-send-email-greearb@candelatech.com> (sfid-20111117_224815_705423_97548BC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It was flipped.  See section 7.3.2.56 of the 802.11n
spec for details.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c5f3417... 3110cbd... M	net/mac80211/debugfs_sta.c
 net/mac80211/debugfs_sta.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index c5f3417..3110cbd 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -274,9 +274,9 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 
 		PRINT_HT_CAP((htc->cap & BIT(10)), "HT Delayed Block Ack");
 
-		PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: "
-			     "3839 bytes");
 		PRINT_HT_CAP(!(htc->cap & BIT(11)), "Max AMSDU length: "
+			     "3839 bytes");
+		PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: "
 			     "7935 bytes");
 
 		/*
-- 
1.7.3.4

