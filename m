Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14682 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3GEUXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 16:23:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Hector Palacios <hector.palacios@digi.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: Passing a custom MAC to ath6kl
References: <51D6E484.9060000@digi.com>
	<87vc4pf1ln.fsf@kamboji.qca.qualcomm.com> <51D6EC90.40009@digi.com>
	<51D70A22.20607@broadcom.com>
Date: Fri, 5 Jul 2013 23:23:40 +0300
In-Reply-To: <51D70A22.20607@broadcom.com> (Arend van Spriel's message of
	"Fri, 5 Jul 2013 20:02:10 +0200")
Message-ID: <87r4fcg3hv.fsf@kamboji.qca.qualcomm.com> (sfid-20130705_222354_660592_6D26C7D7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 07/05/2013 05:56 PM, Hector Palacios wrote:
>> Dear Kalle,
>>
>> On 07/05/2013 05:49 PM, Kalle Valo wrote:
>>> Hector Palacios <hector.palacios@digi.com> writes:
>>>
>>>> Is there a way to pass a custom MAC address to the ath6kl upstream
>>>> driver?
>>>
>>> Not right now. It has been a common feature request so I'm hoping
>>> someone will implement it soon.
>>>
>>>> In the ISC version of the driver, a softmac.c file is provided that
>>>> reads a MAC from a file if a module parameter softmac_enable=1 is
>>>> passed. Is there any reason why this has not made it upstream?
>>>
>>> Providing mac address through a file is too ugly for upstream. We need
>>> to implement it properly using the proper interface.
>>
>> I totally agree. What would be the proper interface for that?
>
> Add .ndo_set_mac_address() callback in main.c and go from there.
>
> int (*ndo_set_mac_address)(struct net_device *dev, void *addr);

And the challenge with ath6kl is that we need to stop the firmware,
change mac address in the firmware and restart the firmware. So it's not
trivial to add that but it shouldn't be too difficult either. Patches
more than welcome :)

-- 
Kalle Valo
