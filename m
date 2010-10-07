Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab0JGHSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 03:18:18 -0400
Subject: Re: [PATCH] mac80211: Deny new BA agreements from being started
 during offchannel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
	Matt Smith <Matt.Smith@atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinOTsYKFpQkg2B7GVMF-eKykFd8LM1m8xmtXX7j@mail.gmail.com>
References: <20101006185000.GJ7070@tux>
	 <1286391301.3655.403.camel@jlt3.sipsolutions.net>
	 <20101006191215.GM7070@tux>
	 <1286392799.3655.414.camel@jlt3.sipsolutions.net>
	 <AANLkTinOTsYKFpQkg2B7GVMF-eKykFd8LM1m8xmtXX7j@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 09:18:12 +0200
Message-ID: <1286435892.3657.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 13:48 -0700, Luis R. Rodriguez wrote:
> On Wed, Oct 6, 2010 at 12:19 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2010-10-06 at 12:12 -0700, Luis R. Rodriguez wrote:
> >
> >> Good question, will ieee80211_offchannel_ps_disable() possibly be
> >> called during suspend? I can imagine its possible. So how about we
> >> check for local->quiescing prior to lifting the flag only:
> >
> > Or suspended?
> 
> If we're suspended we would be quiesced so I do not see us calling
> ieee80211_offchannel_ps_disable() then, but we can also just bail out
> if quescing or suspended on  ieee80211_offchannel_ps_disable() and
> friends.

Oh, wait, yeah, while quiescing we stop the workqueue so we can't be
processing this, so we should be fine. We might still be off-channel
while suspending which is odd, and then we might lift the BA block
earlier than you'd want.

But then again, come to think of it, why are you doing this anyway? I'm
not convinced of the whole idea, it's all racy. I'm starting to think
that this patch won't help anything since we'll still be racy and start
BA agreements just before we block, _and_ if we're a station and going
off-channel we'll be going into powersave which means we won't actually
get the addBA frame until we return.

johannes

