Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566Ab2CHUHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 15:07:39 -0500
Date: Thu, 8 Mar 2012 14:07:34 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: "Quan, David" <dquan@qca.qualcomm.com>,
	"Green, Michael" <green@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120308200734.GC28133@ubuntu-macmini> (sfid-20120308_210750_965974_FF893E8A)
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

brcmsmac

> > It is possible that this card is only regulatory tested for non DFS channels, but now you enable them for passive.
> 
> That's a good point.
> 
> > This means that yes, you are save and not violate DFS rules because you are in passive mode. However, you are in complete violation if the STA finds an AP on that DFS channel and then connects and transmits as this STA is not allow to transmit on that channel since it is not approved.
> 
> If the driver being used is a supported vendor driver then I'll punt
> this to the vendor (Broadcom). If this is the reversed engineered
> driver (b43) that Broadcom to this day seems to blindly ignore even
> for regulatory, then I'm happy to recommend based on your input to
> leave the regulatory domain as-is given that we cannot guarantee what
> the vendor meant as they have not done any work on releasing either
> documentation or code to help with their regulatory situation.

It would be nice if Broadcom could weigh in. Cc-ing Arend.

This is actually a special case. This is an Apple machine, and it's not
that there's no regulatory hint in the ROM, it's that the hint is the
bogus country code "X0". From reading online, Apple uses this to
indicate the regulatory domain is unknown, and it uses the first
regulatory hint it sees in a country IE. I can connect to DFS channels
using MacOS on the machine, so I'll assume it was approved for DFS
channels.

Since Linux (afaict) only uses hits from country IEs for APs it's
connected to, much of the time this card ends up using the world domain
and is unable to scan DFS channels.

Thanks,
Seth

