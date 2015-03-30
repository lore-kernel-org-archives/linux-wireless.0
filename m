Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:39440 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753253AbbC3Qmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 12:42:50 -0400
Message-ID: <1427733767.14276.13.camel@perches.com> (sfid-20150330_184254_776415_F3A9CC8C)
Subject: Re: [PATCH 1/2] mac80211: add TX fastpath
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Mar 2015 09:42:47 -0700
In-Reply-To: <1427728036.26117.36.camel@sipsolutions.net>
References: <1427726167-17802-1-git-send-email-johannes@sipsolutions.net>
	 <1427727818.14276.7.camel@perches.com>
	 (sfid-20150330_170346_635401_65B14245) <1427728036.26117.36.camel@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-30 at 17:07 +0200, Johannes Berg wrote:
> On Mon, 2015-03-30 at 08:03 -0700, Joe Perches wrote:
> 
> > > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > []
> > > +void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp)
> > > +{
> > > +	struct ieee80211_fast_tx build = {}, *fast_tx, *old;
> > 
> > This "{}" memset should probably be moved farther down
> > because there are many return paths that are possible
> > before the memset is necessary.
> 
> True. However, this isn't actually the fast path I'm interested in; the
> function ieee80211_xmit_fast() is the one that we execute per packet,
> this one is invoked very infrequently. I prefer the more readable way
> here.

Perhaps using {} as an initializer amidst multiple declarations
on the same line isn't particularly readable and the explicit
memset is better.


