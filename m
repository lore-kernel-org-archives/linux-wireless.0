Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:33406 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753995AbcLOW7T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 17:59:19 -0500
Date: Fri, 16 Dec 2016 00:58:27 +0200
From: Jouni Malinen <j@w1.fi>
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
Cc: 'Ben Greear' <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: ath10k firmware sends probes on DFS channels without radar
 detection
Message-ID: <20161215225827.GB24883@w1.fi> (sfid-20161215_235923_401157_F6402262)
References: <004a01d24fe2$94da8dc0$be8fa940$@acksys.fr>
 <20161214195805.GA15022@w1.fi>
 <00f501d256e7$0f8d5380$2ea7fa80$@acksys.fr>
 <5852C5AC.6090408@candelatech.com>
 <00fd01d256fc$2f780db0$8e682910$@acksys.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <00fd01d256fc$2f780db0$8e682910$@acksys.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2016 at 06:53:47PM +0100, Jean-Pierre Tosoni wrote:
> > > Thanks for the suggestion, I already tried something like this in
> > > wmi.c, with the same result:
> > >
> > > - Before patching the firmware scans DFS channels actively (with
> > probes).
> > >
> > > - After patching, the firmware scans DFS channels passively *until*
> > > any beacon is received on the DFS channel. When *any* beacon is seen,
> > > the firmware decides to scan actively on its own, without any new
> > > IR/RADAR info from the driver.
> > >
> > > So, your patch is required but not sufficient.
> > >
> > > Somehow I was able to overcome this by reloading the regulation domain
> > > in the radio card before each scan request:

Interesting.. I'm not completely sure what could have changed the
behavior based on beacon hint. I thought it was cfg80211, but if the
simple change for doing NO_IR | RADAR is not sufficient, it would seem
to imply that something else can do this. Some more debugging to do, I
guess.

> The distinction between NO_IR and CHAN_RADAR is not very clear to me.
> NO_IR appears only in the world regulatory domain so it's not relevant here.

NO_IR is a combination of not allowing AP, IBSS, or active scanning
without having somehow been enabled by another device. RADAR has that
same impact and in addition, requirement for doing radar detection and
DFS by a master device.

> I'd say
>  "the CHAN_RADAR flag should always make the firmware never do IR when
> probing"
> ...maybe, except if the channel is the operating channel. (this should
> exclude
> unassociated stations)

For most cases, I'd agree that active scanning should not be used on DFS
channels. That said, unicast Probe Request frame to the current AP while
associated could be a reasonable exception. In addition, WPS with PBC
depends on Probe Request frames to allow PBC session overlap detection,
so there might be sufficient justification to allow Probe Request frame
to be sent out for a very short duration (couple of seconds) after
seeing a Beacon frame on the channel for such special cases.

-- 
Jouni Malinen                                            PGP id EFC895FA
