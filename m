Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:20538 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYKLGR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 01:17:56 -0500
Received: by fg-out-1718.google.com with SMTP id 19so280124fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 22:17:54 -0800 (PST)
Message-ID: <8e92b4100811112217p167f5f2ue5fa96475e6bdd44@mail.gmail.com> (sfid-20081112_071801_352965_B15F2290)
Date: Wed, 12 Nov 2008 11:47:54 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211 dynamic powersave
Cc: "Kalle Valo" <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1226399895.3890.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	 <8e92b4100811102032j7698254ct7020879e4cd5af1d@mail.gmail.com>
	 <1226399895.3890.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:

> Vivek Natarajan wrote:
>> 2) Do you intend to leave the NULL frame formation, waking up the chip
>>      for TIM and modifying sleep/awake time according to  DTIM to
>>     the driver since I did not see this in your TODO list?( I understand from
>>     the iwlwifi code that it just sends a request to the firmware for sending
>>     NULL frame and the firmware takes care of the rest. But it may not be
>>     so in the case of other vendor drivers.)
>
> Can you elaborate on this? I don't think we're concerned with that in
> dynPS.

I'm listing  whatever I have understood about 'Power save'.
It might be too basic but do correct me if I'm wrong somewhere.

NULL DATA frame:
a) A NULL data frame with PM bit ON is to be sent to the AP before
going to sleep.
b) After sending Null frame, the chip should not go to sleep before
getting ack: move to sleep pending state
c) In sleep pending state, wait for one more 'timeout' period before
sending null frame again
d) If ack is received, goto sleep.
    This is to make sure that the AP buffers frames for us.
 Sanity check:
Check if the hw has been sleeping too long! It could imply that the
sleep timers have gotten out of sync with the TSF. If so, force wake
until the sleep timers get resynced.

Tx:
If there is a frame to transmit, send null data with PM bit off and start Tx.
Rx:
If there is any buffered frames, it is indicated in TIM.
TIPS on TIM:
Some hardware processes the TIM IE and fires an interrupt when the TIM
bit is set.
For hardware that doesn't,  we should process the TIM in software as
part of processing the received Beacon
→ A function to check if TIM bit is set based on the offset in the beacon.
→ A function to put the chip to awake(if TIM is set) and send a null
data with PM bit off.

DTIM:
The period after which multicast traffic may be transmitted. So be
awake even if there is no unicast packets
as indicated by TIM.
There are some registers related to TIM and DTIM periods in ath5k
registers.(Thanks Nick for pointing
them out)Need to dig more to see if it is enough to program these
registers to be awake for post-DTIM muticast traffic.

--
Vivek
