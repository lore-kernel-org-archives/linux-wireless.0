Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3AUKVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 05:21:32 -0500
Message-ID: <1358763714.5190.4.camel@jlt4.sipsolutions.net> (sfid-20130121_112135_796065_6368A301)
Subject: Re: [PATCHv3] mac80211: mesh power save basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Mon, 21 Jan 2013 11:21:54 +0100
In-Reply-To: <50FD1395.1020106@cozybit.com> (sfid-20130121_110825_942769_F64A6C63)
References: <1358509570-31602-1-git-send-email-marco@cozybit.com>
	  (sfid-20130118_124620_310760_705AD973) <1358543924.7922.22.camel@jlt4.sipsolutions.net>
	 <50FD1395.1020106@cozybit.com> (sfid-20130121_110825_942769_F64A6C63)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-21 at 11:08 +0100, Marco Porsch wrote:

> > That comment might do with exanding a bit? Without more explanation,
> > transmission order doesn't really require BK -- except that this is done
> > after potentially releasing multiple frames on different ACs, so it has
> > to be BK to not pass any released BK frames. It's reasonable if you look
> > at the (only) caller though, so I'm not worried about it.
> 
> /*
>   * This frame has to be transmitted last. Assign lowest priority to
>   * make sure it cannot pass other frames when releasing multiple ACs.
>   */
> 
> I am not sure if this really correct. Isn't it that all ACs are served 
> in parallel and thus, a BK frame could be transmitted earlier than the 
> last of multiple BE/VI/VO frames? On the other hand, this code has 
> worked pretty reliably so far...

No, they are priority queues, not round robin, so (locally) BK should
always be last.

> > Ultimately, this is where you should also call
> > drv_allow_buffered_frames() and/or driver_release_buffered_frames(). In
> > fact, the *driver* might be buffering frames, so that would be necessary
> > for proper A-MPDU operation etc. I can merge it anyway, but be aware
> > that it is not implementing the full API correctly, so once more drivers
> > get fixed to rely on that API (really is a fix, especially with A-MPDU)
> > you won't have much fun. But you said it doesn't really work with 11n
> > anyway, so ... :)
> 
> Adding driver_allow_buffered_frames and a frame release reason for MPSPs 
> may be pretty straightforward. But I cannot foresee how it is going to 
> work for driver_release_buffered_frames on the driver side.
> 
> I guess eventually this whole MPSP frame release should be merged into 
> (and bloat) ieee80211_sta_ps_deliver_response. I would really like to 
> postpone that hoping that others may pick it up once mesh PS is upstream 
> in a proof of concept fashion.

Sure.

> >> +		ps = &sdata->u.mesh.ps;

> Isn't that what ieee80211_vif_is_mesh is for? Everything compiled fine 
> with CONFIG_MAC80211_MESH turned off.

Never mind, you're right. I thought "u.mesh" was (still) under ifdef.


> >> +				    256 + /* TIM IE */
> >
> > If wonder if that should be 2 + 255? But I haven't looked up the TIM IE
> > format again now ...
> 
> I did:
> IEEE802.11-2012 8.4.2.7 says the size is 5 + [1...251]. 
> ieee80211_beacon_get_tim also uses 256 for AP mode correctly.

Ok, thanks :-)

johannes

