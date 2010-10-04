Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0JDSjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:39:31 -0400
Subject: Re: [PATCH v2 3/3] mac80211: move to the home channel for
 disassociation when roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
In-Reply-To: <20101004172333.GK2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
	 <1285965233-11097-4-git-send-email-lrodriguez@atheros.com>
	 <1286198152.3620.35.camel@jlt3.sipsolutions.net>
	 <20101004163829.GD2105@tux>
	 <1286210516.3620.41.camel@jlt3.sipsolutions.net>
	 <20101004172333.GK2105@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 20:39:29 +0200
Message-ID: <1286217569.3620.48.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 10:23 -0700, Luis R. Rodriguez wrote:
> On Mon, Oct 04, 2010 at 09:41:56AM -0700, Johannes Berg wrote:
> > On Mon, 2010-10-04 at 09:38 -0700, Luis R. Rodriguez wrote:
> > > On Mon, Oct 04, 2010 at 06:15:52AM -0700, Johannes Berg wrote:
> > > > On Fri, 2010-10-01 at 16:33 -0400, Luis R. Rodriguez wrote:
> > > > 
> > > > > @@ -2203,6 +2204,14 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
> > > > >  			return -EALREADY;
> > > > >  		}
> > > > >  
> > > > > +		/*
> > > > > +		 * right before this was authentication, that was on
> > > > > +		 * the same the wk->chan so we need to ensure we temporarily
> > > > > +		 * go back to the operating channel to send the disassocation.
> > > > > +		 */
> > > > > +		local->tmp_channel = NULL;
> > > > > +		ieee80211_hw_config(local, 0);
> > > > > +
> > > > 
> > > > Yikes, no, you can't do this. You don't know what has been merged with
> > > > the authentication work item, etc.
> > > 
> > > What do you mean? Auth/Assoc will be handled separately and the
> > > target channel will also be handled for each work item run, what
> > > issues can arise from sending us back to the home channel towards
> > > the end of this call here?
> > 
> > Another work item, like a remain-on-channel, might have been started on
> > the same channel ("merged").
> 
> But how do this break that other work from moving forward in its respective
> channel? The work_work loop makes sure to check if we require a channel
> change on the work item.

But we already activated that other work item.

johannes

