Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:49067 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818Ab0GNMlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 08:41:24 -0400
Message-ID: <4C3DB065.70009@bu3sch.de>
Date: Wed, 14 Jul 2010 14:41:09 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: Simon Richter <Simon.Richter@hogyros.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Ben Hutchings <ben@decadent.org.uk>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, 588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
References: <20100706021937.11147.78230.reportbug@debian.hogyros.de> <1278887148.6139.91.camel@localhost> <4C3A4C6E.6060801@lwfinger.net> <20100713051430.GA2625@honey.hogyros.de> <4C3BFB87.5030907@lwfinger.net> <20100713073751.GB3089@richter> <4C3C6350.50304@bu3sch.de> <20100713130614.GB25565@richter> <4C3C7296.3070700@bu3sch.de> <20100714075037.GA6128@richter> (sfid-20100714_095042_113832_34B70D3D)
In-Reply-To: <20100714075037.GA6128@richter> (sfid-20100714_095042_113832_34B70D3D)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/14/2010 09:50 AM, Simon Richter wrote:
> Hi,
>
> On Tue, Jul 13, 2010 at 04:05:10PM +0200, Michael Büsch wrote:
>
>> So it is up to the upper layer to detect the failure. I don't think
>> it's possible to automatically detect such incidents for multicast
>> transmissions. So the mechanism fails here.
>
> Well, it is about *receiving* a multicast transmission

The same applies to receiving. The RX queue is also dropped on switch
from DMA to PIO.

> advertisement, sent to 33:33:00:00:00:01). I have no idea where the
> packet is dropped; from my somewhat limited understanding of 802.11, I'd
> expect the frames to be treated like broadcast frames by the AP, so it'd
> be the receiver dropping them in the MAC filter.

The actual switch from DMA to PIO mode completely reinitializes
the hardware and drops all queues.

-- 
Greetings Michael.
