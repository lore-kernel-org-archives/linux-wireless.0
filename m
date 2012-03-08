Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54414 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab2CHV7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 16:59:16 -0500
Date: Thu, 8 Mar 2012 15:59:13 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: "Quan, David" <dquan@qca.qualcomm.com>,
	"Green, Michael" <green@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120308215913.GC13667@ubuntu-macmini> (sfid-20120308_225920_235441_1A0E8D17)
References: <20120307194001.GA2506@ubuntu-macmini>
 <20120308174101.GB28133@ubuntu-macmini>
 <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
 <CAB=NE6U04a0XNrvt6HLCwqbHMtGL8CWh8No_=Bx0mwQZYEgGxQ@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
 <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 08, 2012 at 11:51:03AM -0800, Luis R. Rodriguez wrote:
> On Thu, Mar 8, 2012 at 11:45 AM, Quan, David <dquan@qca.qualcomm.com> wrote:
> > I think there is to it more than SW.
> > Where ever you get this card, is the card tested and regulatory approved for those countries, DFS or not?
> 
> Seth, what driver are you using? I know you are using a BCM43224 card.
> 
> > It is possible that this card is only regulatory tested for non DFS channels, but now you enable them for passive.
> 
> That's a good point.
> 
> > This means that yes, you are save and not violate DFS rules because you are in passive mode. However, you are in complete violation if the STA finds an AP on that DFS channel and then connects and transmits as this STA is not allow to transmit on that channel since it is not approved.

I was thinking about this some more. I still don't understand why it
makes sense to omit these frequencies from the world domain. Isn't the
point of geographic domains to communicate the rules for wherever the
user happens to be at the time? Does the core regulatory support really
ever know which frequencies the hardware has ben approved for, even
among those it already allows?

It seems to me that it's the job of the driver to communicate
hardware-specific regulatory hints. So _if_ passive scanning of the DFS
frequencies is allowed worldwide (I emphasize the if because I don't
know whether or not that's true), why should the world domain not allow
this?

Seth

