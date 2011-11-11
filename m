Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54678 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1KKTYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 14:24:44 -0500
Date: Fri, 11 Nov 2011 14:16:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix warning in ieee80211_probe_client
Message-ID: <20111111191643.GD2485@tuxdriver.com> (sfid-20111111_202447_644874_0101EEB1)
References: <1321036348-32272-1-git-send-email-linville@tuxdriver.com>
 <4EBD7183.3080008@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4EBD7183.3080008@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 11, 2011 at 01:03:31PM -0600, Larry Finger wrote:
> On 11/11/2011 12:32 PM, John W. Linville wrote:
> >   CC [M]  net/mac80211/cfg.o
> >net/mac80211/cfg.c: In function ‘ieee80211_probe_client’:
> >net/mac80211/cfg.c:2567:7: warning: ‘qos’ may be used uninitialized in this function
> >
> >Signed-off-by: John W. Linville<linville@tuxdriver.com>
> >---
> >  net/mac80211/cfg.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> >index c2416fb..1d82d2b 100644
> >--- a/net/mac80211/cfg.c
> >+++ b/net/mac80211/cfg.c
> >@@ -2564,7 +2564,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
> >  	struct sk_buff *skb;
> >  	int size = sizeof(*nullfunc);
> >  	__le16 fc;
> >-	bool qos;
> >+	bool qos = NULL;
> >  	struct ieee80211_tx_info *info;
> >  	struct sta_info *sta;
> 
> Shouldn't the initialization for a bool be "false"? Doesn't
> checkpatch.pl complain about that? I know it does if you try to
> initialize a pointer to 0 rather than NULL.

That's why we post patches to the list. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
