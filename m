Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64461 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0H0F7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 01:59:01 -0400
Received: by bwz11 with SMTP id 11so1680063bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Aug 2010 22:58:59 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: issues with scanning in mac80211
Date: Fri, 27 Aug 2010 07:58:14 +0200
Cc: Amod Bodas <Amod.Bodas@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ext Kalle Valo <kvalo@adurom.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20100826204722.GA1745@tux>
In-Reply-To: <20100826204722.GA1745@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008270758.14393.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Thursday 26 August 2010 schrieb Luis R. Rodriguez:
> Massaging this message a bit and putting it on the public
> mailing list.
> 
> On Thu, Aug 26, 2010 at 01:14:36PM -0700, Amod Bodas wrote:
> > Thanks Jouni. Even my observations are same i.e I see 1 sec or
> > so scan before returning to home channel. Given background scan
> > issue looks to be mac80211 related.
> >
> > Who is lead scan module expert in the community?
> 
> Well Helmut worked on it:
> 
> Author: Helmut Schaa <Helmut.Schaa@gmx.de>
> Date:   Wed Feb 24 14:19:21 2010 +0100
> 
>     mac80211: Improve software scan timing
>     
>     The current software scan implemenation in mac80211 returns to the operating
>     channel after each scanned channel. However, in some situations (e.g. no
>     traffic) it would be nicer to scan a few channels in a row to speed up
>     the scan itself.
>     
>     Hence, after scanning a channel, check if we have queued up any tx frames and
>     return to the operating channel in that case.
>     
>     Unfortunately we don't know if the AP has buffered any frames for us. Hence,
>     scan only as many channels in a row as the pm_qos latency and the negotiated
>     listen interval allows us to.
>     
>     Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> but AFAICT the issues documented below were likely not considered into the
> architecture and its the first time I see them pointed out, unless I missed
> something. 

The current implementation never intended to do proper DTIM beacon handling, it
is only considering unicast traffic. And it tries to stay away of the operating
channel as long as possible (listen_interfal & pm_qos latency). 

Changing that would require a bit of work. The delayed_work scheduling needs to
take into account when the next DTIM beacon is expected and we most likely need
to shorten the time for a passive channel based on the expected time we've got
left. Furthermore, we need to know how long the channel switch will take (we
had something like that but not anymore ...).

> The above commit log shows only the pm_qos latency was taken
> into consideration, which I suppose can be modified for now as a hack
> to deal with these issues.
> 
> Jouni's observations below.
> 
> > -----Original Message-----
> > From: Jouni Malinen 
> > Sent: Thursday, August 26, 2010 12:22 PM
> > To: Amod Bodas
> > Cc: Luis Rodriguez
> > Subject: Re: issues with scanning in mac80211
> > 
> > I do not know what is in compat-wireless, but at least the current
> > wireless-testing.git background scanning algorithm in mac80211 looks
> > pretty horrible from the view point of receiving broadcast frames from
> > the current AP. I'm actually getting much worse results..
> > My tests show 1020 ms away from operating channel vs. Sam's 175 ms.
> > 
> > mac80211 does not seem to even try to receive PS buffered
> > broadcast/multicast frames. It is only limiting the off-channel scan
> > operation based on listen interval (which is 10 with ath9k) which allows
> > it to miss ten beacon intervals in row from the current AP even if the
> > DTIM period is one..

Yes, correct. The mac80211 scan implementation does not honor broad- and
multicast traffic at all. It returns to the operating channel if tx
frames are pending, the qos latency was exceeded or the liste interval was
exceeded.

> > In addition, the time when it leaves the operating
> > channel is not synchronized with the beacons at all.

Correct.

Helmut
