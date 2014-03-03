Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbaCCMzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 07:55:39 -0500
Message-ID: <1393851336.10039.1.camel@jlt4.sipsolutions.net> (sfid-20140303_135543_346848_AD333A9B)
Subject: Re: [PATCH] cfg80211: fix cfg80211_leave() locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Mar 2014 13:55:36 +0100
In-Reply-To: <1393599480-27908-1-git-send-email-michal.kazior@tieto.com> (sfid-20140228_160318_717439_75478E89)
References: <1393599480-27908-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140228_160318_717439_75478E89)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-28 at 15:58 +0100, Michal Kazior wrote:
> The beacon_interval was set unprotected by
> wdev.mtx. This could possibly lead to inconsistent
> cfg80211 states.

Why not just this patch? The beacon_interval is already set to 0 in
stop_ap(), and is irrelevant for the other modes.

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 010892b81a06..a3bf18d11609 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -788,8 +788,6 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 	default:
 		break;
 	}
-
-	wdev->beacon_interval = 0;
 }
 
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,


johannes

