Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2ECU3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 16:29:04 -0400
Message-ID: <1336076941.5167.20.camel@jlt3.sipsolutions.net> (sfid-20120503_222909_626147_3567E559)
Subject: Re: [PATCH v2 3/4] mac80211: Allow nonHT/HT peering in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Thu, 03 May 2012 22:29:01 +0200
In-Reply-To: <CACcxo+rNUbiitNUvZewaNpXnT8BJTtSvJLsgDnZ44+MYAzbVuA@mail.gmail.com> (sfid-20120503_222353_103064_B67FCEEA)
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
	 <1335820832-18887-3-git-send-email-ashok@cozybit.com>
	 <1336074010.5167.19.camel@jlt3.sipsolutions.net>
	 <CACcxo+rNUbiitNUvZewaNpXnT8BJTtSvJLsgDnZ44+MYAzbVuA@mail.gmail.com>
	 (sfid-20120503_222353_103064_B67FCEEA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-03 at 13:23 -0700, Ashok Nagarajan wrote:
> On Thu, May 3, 2012 at 12:40 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2012-04-30 at 14:20 -0700, Ashok Nagarajan wrote:
> >
> >> -         (local->_oper_channel_type !=
> >> -          ieee80211_ht_oper_to_channel_type(ie->ht_operation)))
> >> +         local->_oper_channel_type > NL80211_CHAN_HT20 &&
> >> +         sta_channel_type > NL80211_CHAN_HT20 &&
> >> +         local->_oper_channel_type != sta_channel_type)
> >
> > I don't think you should use > operators since we may later have to add
> > other channel types like 5 and 10 MHz.
> >
> Sure. I will send a fix patch reflecting this change.

I think all of this has been merged so please send fixes for the other
things too.

Thanks,
johannes

