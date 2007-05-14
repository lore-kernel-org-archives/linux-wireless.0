Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48411 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754985AbXENRhQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 13:37:16 -0400
Date: Mon, 14 May 2007 19:37:15 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Allow sleeping in set_key op
Message-ID: <20070514193715.4fffabda@griffin.suse.cz>
In-Reply-To: <200705072244.23736.mb@bu3sch.de>
References: <200705062037.35037.mb@bu3sch.de>
	<20070507185224.45f98d56@midnight.suse.cz>
	<200705072244.23736.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 7 May 2007 22:44:23 +0200, Michael Buesch wrote:
> On Monday 07 May 2007 18:52:24 Jiri Benc wrote:
> > There is a race here. You already removed the sta from sta_hash list
> > and you're not protected by any lock. Thus, it is possible to add a new
> > station with the same address before finish_sta_info_free is called.
> > When this happens, you call the set_key handler for the new key and
> > after that you call it again with DISABLE_KEY.
> > 
> > It's not easy to get this right. I remember also problems with
> > dereferencing already freed key when I thought about possible ways to
> > solve exactly this problem.
> 
> I'm not sure this race exists.
> You assume that when a new key is added with the same mac as before
> it overrides the old key.

Yes.

> I think that's a bug in the driver then.
> IMO the driver _must_ keep track of used key "slots" and don't
> re-allocate them for new keys until disable-key is called.

How the hardware will act if you supply two different keys for the same
MAC address? And later, how do you recognize which of these two keys is
being disabled?

> And that's exactly what bcm43xx does.
> 
> IMO it's a bug in the driver, when it overrides a key that's not
> DISABLEd.
> 
> Short: I don't think there is a race, and if, then it's a driver bug.

I must admit I don't know how exactly keys are handled in all possible
hardware. So I just want to be sure and keep exact serialization here.
If there is a consensus that serialization is not needed here, well,
it's easier then.

Do you know how other drivers work regarding this?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
