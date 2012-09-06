Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36088 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2IFFUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 01:20:54 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 13:20:53 +0800
Message-ID: <CAPgLHd_VrjzzfPDsd3KKzgX2bKJ47zUCJmsQO+Q49ajNVLnTVg@mail.gmail.com> (sfid-20120906_072102_638265_74D0E9F0)
Subject: [PATCH] mac80211: use list_move instead of list_del/list_add
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/mac80211/offchannel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 635c325..7fbf99d 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -227,8 +227,7 @@ static void ieee80211_hw_roc_start(struct work_struct *work)
 			u32 dur = dep->duration;
 			dep->duration = dur - roc->duration;
 			roc->duration = dur;
-			list_del(&dep->list);
-			list_add(&dep->list, &roc->list);
+			list_move(&dep->list, &roc->list);
 		}
 	}
  out_unlock:


