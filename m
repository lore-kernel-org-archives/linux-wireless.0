Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1AaMLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 07:11:51 -0500
Subject: Re: [PATCH v2 06/10] mac80211: add HW flag for disabling auto
 link-PS in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <AANLkTin9vOQJqDJezzBMjjRyGNDYGEwOwgT_aFk2NBYD@mail.gmail.com>
References: <1296472589-26401-1-git-send-email-arik@wizery.com>
	 <1296472589-26401-7-git-send-email-arik@wizery.com>
	 <1296473043.3812.10.camel@jlt3.sipsolutions.net>
	 <AANLkTin9vOQJqDJezzBMjjRyGNDYGEwOwgT_aFk2NBYD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 13:11:50 +0100
Message-ID: <1296475910.3812.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 13:49 +0200, Arik Nemtsov wrote:
> On Mon, Jan 31, 2011 at 13:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> > It'd be nicer if you could separate out mac80211 patches, but then Luca
> > needs to hold off merging until John picked up the mac80211 patch.
> 
> Yea that would complicate matters a bit. Does the ordering of the
> patches bother you?

It just makes it more complicated for me to pick out the right thing --
I almost missed that there was a mac80211 patch in this huge series.

> > Also, come to think of it, the ieee80211_sta_block_awake will not be
> > effective I think? Or will it?
> 
> Haven't noticed any adverse effects. ap_sta_ps_end() still checks if
> the station is blocked before delivering queued packets.
> 
> Also is should be pretty hard to find a driver that uses both mechanisms.
> If it wants to block a station from waking up, it can simply not call
> ieee80211_sta_ps_transition().
> 
> Should work though.

Good point, thanks for looking.

johannes

