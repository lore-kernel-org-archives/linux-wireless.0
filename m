Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:56108 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569Ab3F0OSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 10:18:09 -0400
Date: Thu, 27 Jun 2013 19:33:58 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Jonathan Bither <jonbither@gmail.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	Matt Smith <smithm@qca.qualcomm.com>
Subject: Re: ACS and Hostapd
Message-ID: <20130627140358.GC440@markyou.marvell.com> (sfid-20130627_161815_465191_8857E37D)
References: <20121123081444.GA6028@markyou.marvell.com>
 <20121211194249.GT15974@pogo>
 <50C9F3FA.6000906@gmail.com>
 <7DDF37406E10F0438561DBB78326DF390391C15265@SC-VEXCH1.marvell.com>
 <CAB=NE6WYYzgOWeG=2UHccp74=-qp2Cvv=SZGY75+5jN4-y0orA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB=NE6WYYzgOWeG=2UHccp74=-qp2Cvv=SZGY75+5jN4-y0orA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, Dec 13, 2012 at 12:33:06PM -0800, Luis R. Rodriguez wrote:
> On Thu, Dec 13, 2012 at 10:54 AM, Yogesh Powar <yogeshp@marvell.com> wrote:
> > Hi Jouni/Luis,
> >
> > It seems that, we have some resources that can be utilized to test this
> > feature of ACS for hostapd.
> >
> > Before we begin on this work of Luis and optimize/enhance it further, would you
> > like to recommend some immediate changes from the last test results?
> 
> By my part:
> 
> The algorithm I wrote was pretty complex and although I did review it
> with some folks who liked it and it made sense the algorithm can be
> simplified by taking the input elements and using a multiplier for
> each one and letting the user configure the multiplier. In other words
> all the log stuff I did and linearizing it some way was not all that
> necessary except for mental masturbation.
> 
> Apart from that its just a matter of testing and proving it works.
Hi Luis,
   We tried your code of ACS from hostapd mailing list archieve, after
resolving some merge conflicts, on latest hostapd. Following are some
of our observations

a) The code can work for the drivers that dont support offchannel-tx.
   For such drivers, setting channel_time_tx to zero will make
   interference factor to depend only on busy time from passive
   listener's point of view.
b) HT 40 Mhz might have some issues with current ACS. When primary
   channel with least interference factor is selected secondary channel
   is set to offset from the primary instead of actual secondary
   channel.

Apart from the existing complex logic, explained here
http://wireless.kernel.org/en/users/Documentation/acs, can simple scan
based ACS algorithm feasible?

Lets say one just scans all the channel and gathers the beacons. Based
on the information based on collected beacons one can find out which
channel has least number of APs residing. One can even look into
detail IE informations in the beacons for detail study of wireless
environment.

This could help drivers that do not have access to parameters needed for
interference factor calculation.

Thanks
Yogesh
