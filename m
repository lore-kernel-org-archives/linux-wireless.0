Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:65404 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2FIOXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 10:23:30 -0400
Received: by weyu7 with SMTP id u7so1154085wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 07:23:29 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: BA session issue due to old BARs?
Date: Sat, 9 Jun 2012 16:23:24 +0200
Cc: Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com> <201206090218.27603.chunkeey@googlemail.com> <CAGXE3d-qQNoXkGhPHFX0vxq0VMto36S5zuZP4gKGkGJ4JA=NXw@mail.gmail.com>
In-Reply-To: <CAGXE3d-qQNoXkGhPHFX0vxq0VMto36S5zuZP4gKGkGJ4JA=NXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206091623.25232.chunkeey@googlemail.com> (sfid-20120609_162334_628782_1527C298)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 09 June 2012 14:20:48 Helmut Schaa wrote:
> On Sat, Jun 9, 2012 at 2:18 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Friday 08 June 2012 09:57:26 Sean Patrick Santos wrote:
> >> I believe that I have found the commit that introduced this problem,
> >> which was a change in mac80211. However, I'm out of my depth in
> >> figuring out what a really "correct" solution is; all I've done is a
> >> trial-and-error bisection. The commit in question:
> >>
> >> commit f0425beda4d404a6e751439b562100b902ba9c98
> >> Author: Felix Fietkau <nbd@openwrt.org>
> >> Date:   Sun Aug 28 21:11:01 2011 +0200
> >>
> >>     mac80211: retry sending failed BAR frames later instead of tearing down aggr
> >>
> >>     Unfortunately failed BAR tx attempts happen more frequently than I
> >>     expected, and the resulting aggregation teardowns cause performance
> >>     issues, as the aggregation session does not always get re-established
> >>     properly.
> >>     Instead of tearing down the entire aggr session, we can simply store the
> >>     SSN of the last failed BAR tx attempt, wait for the first successful
> >>     tx status event, and then send another BAR with the same SSN.
> >>
> >>     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >>     Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> >>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >>
> >> This looks relevant. As a matter of personal convenience, I might try
> >> backing out the change tomorrow if it seems that it'll help.
> > Felix,
> >
> > is there any way we can restore the old behavior of tearing
> > down BAs due to BAR transmission failures without breaking
> > ath9k (or rt2x00)?
> 
> No problem with rt2x00 since it has problems reporting the
> tx status of BARs :(
hm, does the hardware pass BA to the driver? Because, the
BA which results from a BAR usually contains the ssn from
the BAR (just the ra / ta is switched). Come to think of it
the ssn and the bitmap might also be useful to map tx_status
to a specific skb. 
 
> > Or am I misinterpreting the commit and
> > this patch was just a temporary fix since back then mac80211
> > had problems with setting up BA session (and they might
> > have been fixed in the meantime?!).
> >
> > Quote from the first paragraph of the commit:
> >> ... the resulting aggregation teardowns cause performance
> >> issues, as the aggregation session does not always get
> >> re-established properly.
> 
> As far as I understood tearing down the BA session and then
> starting it again has a much higher impact onto throughput
> then just resending the BAR after the next successfully sent
> AMPDU.
Well, at least in case of carl9170 it looks like the resending
BARs are confusing the receiver reorder buffer on the other 
HT peer. Since it looks like the HT peer dump hardware is still
ACKs incoming frames from a carl9170 station, but the software
reorder buffer on the HT peer is silently dropping the data frames.
[Of course, data frames from other TIDs, MGMT (probes) or null-
frames are not reordered... so the connection polling with
null-frames does not detect the bad state and won't try to
recover).

Regards,
	Christian
