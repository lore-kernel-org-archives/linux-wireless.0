Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50062 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2FUGVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 02:21:15 -0400
Message-ID: <4FE2BD58.60805@tieto.com> (sfid-20120621_082150_880562_8934A1E4)
Date: Thu, 21 Jun 2012 08:21:12 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vivek Natarajan <vivek.natraj@gmail.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	"jouni@qca.qualcomm.com" <jouni@qca.qualcomm.com>,
	"kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] cfg80211: Support for automatic channel selection
 in AP mode
References: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>  <1340182500.4655.47.camel@jlt3.sipsolutions.net>  <CAJqpcCQ34PFxAapy0q1WCQQO8NehV+niwEHpbbTDL+e=rJ7X=w@mail.gmail.com>  (sfid-20120620_114256_209959_B1E0B5E9) <1340206900.4655.77.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340206900.4655.77.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-20 at 15:12 +0530, Vivek Natarajan wrote:
>
>>>> For P2P, the operating channel needs to be known before group negotiation starts.
>>>> This is true in case of P2P GO or client. It needs a separate p2p command from
>>>> wpa_cli to get the acs-based best channel information from the driver.
>>>
>>> So .. is there any reason to not do only the second, and then pass that
>>> channel back here instead?
>>
>> So, what you recommend is, for both AP and P2P GO modes, the logic
>> should be to request the driver for best channel, then the best
>> channel information event to be passed to userspace and then starting
>> the AP/GO mode of operation.
>
> That's what I'm thinking, yes.
>
>> The current ath6kl firmware has some limitation for getting this
>> channel information separately and hence not yet implemented this.
>> Moreover this needs to be a synchronous operation: to request and get
>> the event for best channel after a full cycle of channel assessment is
>> done.
>
> Right, but if you're working on this surely you can do without this
> particular patch for now?
>
> The reason I'm talking about this is the channel concurrency framework
> that Michal is working on, which would conflict somehow with this I
> think.

Hmm.. we should be able to deal with it. I have a couple of ideas:

  a) treat ACS AP as a non-fixed channel IBSS (i.e. reserve a single
     channel resource); once channel notifications comes in we'd drop
     the behaviour

  b) trust the driver it won't do anything funny (we already trust it
     with channel switch notification)


The a) requires more tricks to be done. Once we run out of channels to 
run on we need to either:

  1) reject it and leave it to userspace to handle (i.e. retry .start_ap
     without ACS)

  2) disable ACS implicitly and pick a channel ourselves (we'd need to
     do a synthetic channel switch notification to userspace)

  3) extend ACS to accept channel list, so we could implicitly reduce it
     to channels we're already on (probably involves some nice hackery)


The b) seems to have an issue. Consider the following scenario:

     [ no channels are used, max 1 channel concurrency, max 2 APs ]
  1. wlan0: .start_ap with ACS
     [ driver is starting ACS AP.. ]
  2. wlan1: .start_ap on channel 1
     [ the driver is probably locked right now
       as it needs to complete (1); even if it's not locked
       (1) probably can't be influenced by (2) anymore.
       once it completes (1) it might end up on channel 6 on wlan0.
       this means (2) fails kind of unexpectedly ]


-- 
Pozdrawiam / Best regards, Michal Kazior.
