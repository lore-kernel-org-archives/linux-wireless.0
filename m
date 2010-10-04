Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51910 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab0JDQic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 12:38:32 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 09:38:24 -0700
Date: Mon, 4 Oct 2010 09:38:29 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH v2 3/3] mac80211: move to the home channel for
 disassociation when roaming
Message-ID: <20101004163829.GD2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1285965233-11097-4-git-send-email-lrodriguez@atheros.com>
 <1286198152.3620.35.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286198152.3620.35.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 06:15:52AM -0700, Johannes Berg wrote:
> On Fri, 2010-10-01 at 16:33 -0400, Luis R. Rodriguez wrote:
> 
> > @@ -2203,6 +2204,14 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
> >  			return -EALREADY;
> >  		}
> >  
> > +		/*
> > +		 * right before this was authentication, that was on
> > +		 * the same the wk->chan so we need to ensure we temporarily
> > +		 * go back to the operating channel to send the disassocation.
> > +		 */
> > +		local->tmp_channel = NULL;
> > +		ieee80211_hw_config(local, 0);
> > +
> 
> Yikes, no, you can't do this. You don't know what has been merged with
> the authentication work item, etc.

What do you mean? Auth/Assoc will be handled separately and the
target channel will also be handled for each work item run, what
issues can arise from sending us back to the home channel towards
the end of this call here?

  Luis
