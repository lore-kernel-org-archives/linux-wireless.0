Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdBSHzP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 02:55:15 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Nils Holland <nholland@tisys.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix rtl8187 multicast reception
References: <20170219013520.GA3190@tisys.org>
        <2eb1dd33-4d71-86b7-c579-412419e2a2e5@lwfinger.net>
Date: Sun, 19 Feb 2017 09:46:16 +0200
In-Reply-To: <2eb1dd33-4d71-86b7-c579-412419e2a2e5@lwfinger.net> (Larry
        Finger's message of "Sat, 18 Feb 2017 21:26:59 -0600")
Message-ID: <87lgt28vxz.fsf@purkki.adurom.net> (sfid-20170219_085527_909679_6A441C31)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 02/18/2017 07:35 PM, Nils Holland wrote:
>> The rtl8187 doesn't seem to receive multicast data, which, among other
>> thinks, make it fail to receive RAs in IPv6 networks.
>>
>> The cause seems to be that the RTL818X_RX_CONF_MULTICAST flag doesn't
>> have any effect at all. Fix this issue by setting
>> RTL818X_RX_CONF_MONITOR instead, which puts the card into monitor mode,
>> and fixes the problem.
>>
>> Signed-off-by: Nils Holland <nholland@tisys.org>
>> ---
>> The problem and solution have been tested on an rtl8187b (0bda:8197), but
>> the fix changes behavior on other cards supported by the driver as well
>> (like non-b 8187's). Due to lack of hardware, I unfortunately cannot say
>> if the issue exists on these cards in the first place, or if the fix has
>> any unwanted consequences there.

BTW, this is good info to have in the actual commit log. No need put it
under "---" line.

>> If people consider it a bad idea to just always put the card into monitor
>> mode (for example, for performance reasons), I could imagine rewriting this
>> patch so that a module parameter controls this behavior instead.
>
> I would hate to make such a change in the behavior of the driver, and
> have it be applied without the user having any say. The fact that
> setting RTL818X_RX_CONF_MULTICAST does not have the desired effect may
> be due to a firmware error; however, there is no chance of making a
> change there as these devices have embedded/fixed fw.

Or it could be also a problem how we configure the firmware.

> I would prefer a module parameter that would allow this change to be
> implemented only if the user takes special action. I suspect that you
> will have no difficulty preparing such a change. If that is not true,
> I would be happy to help.

I understand why you prefer having a module parameter but the thing is
that being able to receive multicast frames is really basic
functionality. We should not hide it under a module parameter.

Isn't there any other option, for example does anyone have hw to test
this with other hw? (what exactly?) Or maybe we just take the risk and
take it as is and revert if problems arise?

-- 
Kalle Valo
