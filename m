Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44571 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1J1FMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 01:12:06 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [wireless-next PATCH 5/5] wifi-debugfs: Fix AMSDU rate printout.
Date: Thu, 27 Oct 2011 22:11:20 -0700
Message-Id: <1319778680-11405-5-git-send-email-greearb@candelatech.com> (sfid-20111028_071211_282287_FE1890EF)
In-Reply-To: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It was flipped.  See section 7.3.2.56 of the 802.11n
spec for details.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 1ceec86... 4310431... M	net/mac80211/debugfs_sta.c
 net/mac80211/debugfs_sta.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 1ceec86..4310431 100644
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

