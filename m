Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:35038 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbZHXSvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 14:51:33 -0400
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KOW00MP79PYYHG0@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 24 Aug 2009 20:51:34 +0200 (CEST)
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: linux-wireless@vger.kernel.org
Cc: joe@perches.com, proski@gnu.org,
	Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: [PATCH v2] mac80211: Fix output of minstrels rc_stats
Date: Mon, 24 Aug 2009 20:51:46 +0200
Message-id: <1251139906-31813-1-git-send-email-hannemann@nets.rwth-aachen.de>
In-reply-to: <1251138015.13464.2.camel@mj>
References: <1251138015.13464.2.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An integer overflow in the minstrel debug code prevented the
throughput to be displayed correctly. This patch fixes that,
by permutating operations like proposed by Pavel Roskin.

Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
---
 net/mac80211/rc80211_minstrel_debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 98f4807..3d72ec5 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -83,7 +83,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		p += sprintf(p, "%3u%s", mr->bitrate / 2,
 				(mr->bitrate & 1 ? ".5" : "  "));
 
-		tp = ((mr->cur_tp * 96) / 18000) >> 10;
+		tp = mr->cur_tp / ((18000 << 10) / 96);
 		prob = mr->cur_prob / 18;
 		eprob = mr->probability / 18;
 
-- 
1.6.4.1

