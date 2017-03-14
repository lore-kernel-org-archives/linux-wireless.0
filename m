Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39872 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdCNONP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:13:15 -0400
Message-ID: <1489500792.10872.13.camel@sipsolutions.net> (sfid-20170314_151451_283752_8CF5C77D)
Subject: Re: [PATCH] mac80211: Allow multiple listeners for management
 frames.
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@openmesh.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: linux-wireless@vger.kernel.org,
        Benjamin Berg <benjamin@sipsolutions.net>
Date: Tue, 14 Mar 2017 15:13:12 +0100
In-Reply-To: <3029516.gVNlmVZjU3@prime> (sfid-20170314_151031_045293_89F882D3)
References: <20170310093454.27664-1-sven.eckelmann@openmesh.com>
         <1489499461.10872.4.camel@sipsolutions.net> <33102038.DFbxuT1K2h@bentobox>
         <3029516.gVNlmVZjU3@prime> (sfid-20170314_151031_045293_89F882D3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-14 at 15:10 +0100, Simon Wunderlich wrote:
> On Tuesday, March 14, 2017 3:06:35 PM CET Sven Eckelmann wrote:
> > On Dienstag, 14. März 2017 14:51:01 CET Johannes Berg wrote:
> > [...]
> > 
> > > I'm not sure I mentioned it to him, or even remembered it when we
> > > were
> > > discussing it, but I don't think this patch is a good idea, at
> > > least
> > > for action frames.
> > 
> > [...]
> > 
> > > If you restrict it to non-action I can live with it, but I don't
> > > know
> > > what you really want to do with this.
> > 
> > I think he required it only for probe requests.

Similar situation for probe requests though - who answers them? :-)

Though at least in that case the kernel doesn't care (unlike in the
action frame case) since it never does.

> The idea was to grab probe requests from userspace with a program
> running next to hostapd.

I guess there are some efficiency problems with that right now, but a
monitor mode interface should work just as well. Perhaps we can allow
attaching a BPF program to a monitor mode interface, and run that
without cloning the SKB etc.?

johannes
