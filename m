Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:43260 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933266Ab0GONpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 09:45:22 -0400
Message-ID: <4C3F10DD.70206@bu3sch.de>
Date: Thu, 15 Jul 2010 15:45:01 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: Simon Richter <sjr@debian.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Ben Hutchings <ben@decadent.org.uk>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, 588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
References: <1278887148.6139.91.camel@localhost> <4C3A4C6E.6060801@lwfinger.net> <20100713051430.GA2625@honey.hogyros.de> <4C3BFB87.5030907@lwfinger.net> <20100713073751.GB3089@richter> <4C3C6350.50304@bu3sch.de> <20100713130614.GB25565@richter> <4C3C7296.3070700@bu3sch.de> <20100714075037.GA6128@richter> <4C3DB065.70009@bu3sch.de> <20100715085149.GA9922@richter> (sfid-20100715_105156_128831_049F8D0E)
In-Reply-To: <20100715085149.GA9922@richter> (sfid-20100715_105156_128831_049F8D0E)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/15/2010 10:51 AM, Simon Richter wrote:
>> The same applies to receiving. The RX queue is also dropped on switch
>> from DMA to PIO.
>
> Sure, but the packet is repeated every ten seconds. The problem is that
> none of those packets is received, even long after the switch to PIO.

The filter flags are not updated because (as I already said) the reinit
happens without mac80211's knowledge.

>> The actual switch from DMA to PIO mode completely reinitializes
>> the hardware and drops all queues.
>
> Would it be possible to reinitialize the multicast filter at this point?

Yeah everything is possible.
I'd rather like to see the actual _problem_ fixed instead of
continuing to waste hours and hours on the hackish workaround.
So in the end the workaround (aka PIO fallback) can be removed.

If this problem is fixed, the next one will show up. (For example
the fact that the PIO fallback won't work on an AP, too, for these
reasons).

Please work on fixing up the PCI core code, which most likely
causes the problem, instead of extending the workaround hack.

-- 
Greetings Michael.
