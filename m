Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaAUPOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 10:14:46 -0500
Message-ID: <1390317277.6199.33.camel@jlt4.sipsolutions.net> (sfid-20140121_161450_203765_A040C101)
Subject: Re: [PATCH 6/7] mac80211: deny attempts at using chanctx during CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, Luca Coelho <luca@coelho.fi>
Date: Tue, 21 Jan 2014 16:14:37 +0100
In-Reply-To: <1390227670-19030-7-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152543_881447_A83022A4)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-7-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140120_152543_881447_A83022A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
> It was possible to connect STA when AP CSA was in
> progress which clearly was a bug.
> 
> Deny attempts to increase chanctx refcount or
> create chanctx.
> 
> This effectively denies starting a new interface
> and radar detection while CSA is in progress.
> 
> Existing interfaces (including those with active
> CSA) can be stopped though.

I think this is the wrong approach. This makes more special cases for
non-chanctx code, whereas I think the code should gain more channel
context awareness. Luca has a patch to make channel switch work with
channel contexts (by creating one on the new channel and then later
switching to it), and I think this mechanism should be subsumed into the
channel context reservation code, rather than being CSA specific.

However, if there's only one channel context (or no support for channel
contexts) then CSA becomes a special case in Luca's patch, I guess,
because we can't be reserving a new one?

Luca, this is probably something you need to look into - this goes back
to the exact timing thing we just talked about. If we don't support
channel contexts, then we can create a fake one to switch to, but then
this fake one can't accept any further interfaces being bound to it
since it will not be able to coexist with the other one.

As far as this particular behaviour is concerned, I would then say that
then the old channel context should also be marked as incompatible for
the time of the CSA, so that no other (station) vif can attempt to use
it.

That'll result in a better solution overall, I think.

johannes

