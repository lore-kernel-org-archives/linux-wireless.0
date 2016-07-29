Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34844 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbcG2PJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2016 11:09:43 -0400
Subject: Re: [PATCH] ath10k: Allow setting coverage class
To: Benjamin Berg <benjamin@sipsolutions.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
References: <1469608424-11370-1-git-send-email-benjamin@sipsolutions.net>
 <5798EEC3.5040008@candelatech.com>
 <1469803947.7306.139.camel@sipsolutions.net>
Cc: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	ath10k@lists.infradead.org,
	Simon Wunderlich <sw@simonwunderlich.de>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <579B71B4.7080206@candelatech.com> (sfid-20160729_170947_408846_FC848D82)
Date: Fri, 29 Jul 2016 08:09:40 -0700
MIME-Version: 1.0
In-Reply-To: <1469803947.7306.139.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2016 07:52 AM, Benjamin Berg wrote:
> On Mi, 2016-07-27 at 10:26 -0700, Ben Greear wrote:
>> On 07/27/2016 01:33 AM, Benjamin Berg wrote:
>>>
>>> Unfortunately ath10k does not generally allow modifying the coverage class
>>> with the stock firmware and Qualcomm has so far refused to implement this
>>> feature so that it can be properly supported in ath10k. If we however know
>>> the registers that need to be modified for proper operation with a higher
>>> coverage class, then we can do these modifications from the driver.
>>>
>>> This patch implements this hack for first generation cards which are based
>>> on a core that is similar to ath9k. The registers are modified in place and
>>> need to be re-written every time the firmware sets them. To achieve this
>>> the register status is verified after any event from the firmware.
>>>
>>> The coverage class may not be modified temporarily right after the card
>>> re-initializes the registers. This is for example the case during scanning.
>>>
>>> A warning will be generated if the hack is not supported on the card or
>>> unexpected values are hit. There is no error reporting for userspace
>>> applications though (this is a limitation in the mac80211 driver
>>> interface).
>>>
>>>>> Thanks to Sebastian Gottschall <s.gottschall@dd-wrt.com> for initially
>>> working on a userspace support for this. This patch wouldn't have been
>>> possible without this documentation.
>>
>> I would be concerned about the various resets firmware does to work around
>> hardware hangs as well.  I don't think any events are generated for these, unless
>> you count the dbglog messages?
>
> Yeah, I am aware of the fact that the firmware may do internal resets
> from time to time. The interesting question (and one for which I do not
> know the answer) is whether we get a wmi or other event under all
> conditions where the register may be rewritten due to a reset.
>
> The current code will re-set the register value after any wmi event
> including debug messages. If this is not enough, then the only solution
> might be to periodically poll the register values instead of relying on
> a received event.

You will get a dbglog event at least most of the time, so maybe that
will be good enough.

Someone with src code and that cared could audit the code I guess, but then
that person could also just implement the feature properly in the firmware
to begin with...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

