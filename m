Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m15-22.126.com ([220.181.15.22]:56110 "EHLO m15-22.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab2INNAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 09:00:46 -0400
Date: Fri, 14 Sep 2012 20:29:32 +0800 (CST)
From: =?GBK?B?wO7J6g==?= <lishen565@126.com>
To: devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re:[PATCH] mac80211: allow re-open the blocked peer link in mesh
In-Reply-To: <1347603511-31165-1-git-send-email-yeohchunyeow@gmail.com>
References: <1347603511-31165-1-git-send-email-yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <61696420.fc66.139c4c167b7.Coremail.lishen565@126.com> (sfid-20120914_150050_201458_497937F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have modified the souce code as the patch shows.I'm sorry that it doesn't work and station plink state is still BLOCKED.
At 2012-09-14 14:18:31,"Chun-Yeow Yeoh" <yeohchunyeow@gmail.com> wrote:
>Peer link which is blocked using the "iw mesh0 station
>set <MAC addr> plink_action block" is previously not able
>to re-open using "iw mesh0 station set <MAC addr>
>plink_action open". This patch is intended to solve this.
>
>If the station plink state remains at OPN_SNT once open,
>try block and open again should solve this problem.
>
>Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>---
> net/mac80211/mesh_plink.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
>diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
>index 9d7ad36..3ab34d8 100644
>--- a/net/mac80211/mesh_plink.c
>+++ b/net/mac80211/mesh_plink.c
>@@ -537,7 +537,8 @@ int mesh_plink_open(struct sta_info *sta)
> 	spin_lock_bh(&sta->lock);
> 	get_random_bytes(&llid, 2);
> 	sta->llid = llid;
>-	if (sta->plink_state != NL80211_PLINK_LISTEN) {
>+	if (sta->plink_state != NL80211_PLINK_LISTEN &&
>+	    sta->plink_state != NL80211_PLINK_BLOCKED) {
> 		spin_unlock_bh(&sta->lock);
> 		return -EBUSY;
> 	}
>-- 
>1.7.0.4
>
>_______________________________________________
>Devel mailing list
>Devel@lists.open80211s.org
>http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel

