Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47384 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbbC3PHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 11:07:20 -0400
Message-ID: <1427728036.26117.36.camel@sipsolutions.net> (sfid-20150330_170723_841717_64D494C7)
Subject: Re: [PATCH 1/2] mac80211: add TX fastpath
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Mar 2015 17:07:16 +0200
In-Reply-To: <1427727818.14276.7.camel@perches.com> (sfid-20150330_170346_635401_65B14245)
References: <1427726167-17802-1-git-send-email-johannes@sipsolutions.net>
	 <1427727818.14276.7.camel@perches.com>
	 (sfid-20150330_170346_635401_65B14245)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-30 at 08:03 -0700, Joe Perches wrote:

> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> []
> > +void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp)
> > +{
> > +	struct ieee80211_fast_tx build = {}, *fast_tx, *old;
> 
> This "{}" memset should probably be moved farther down
> because there are many return paths that are possible
> before the memset is necessary.

True. However, this isn't actually the fast path I'm interested in; the
function ieee80211_xmit_fast() is the one that we execute per packet,
this one is invoked very infrequently. I prefer the more readable way
here.

johannes

