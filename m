Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2770 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab2KTTvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 14:51:47 -0500
Message-ID: <50ABDF4B.5020506@broadcom.com> (sfid-20121120_205152_004357_5BEBEE06)
Date: Tue, 20 Nov 2012 20:51:39 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kalle Valo" <kvalo@adurom.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Fengguang Wu" <fengguang.wu@intel.com>,
	"Franky Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH] brcmfmac: check return from kzalloc in
 brcmf_fweh_process_event
References: <1353340412-22757-1-git-send-email-linville@tuxdriver.com>
 <50AA6EBF.9050001@broadcom.com> <87y5hwwvtg.fsf@purkki.adurom.net>
In-Reply-To: <87y5hwwvtg.fsf@purkki.adurom.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2012 08:57 AM, Kalle Valo wrote:
> "Arend van Spriel" <arend@broadcom.com> writes:
>
>> On 11/19/2012 04:53 PM, John W. Linville wrote:
>>> From: "John W. Linville" <linville@tuxdriver.com>
>>>
>>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>
> [...]
>
>>>    	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
>>> +	if (!event)
>>
>> My fix included a debug statement about the discarded event from firmware.
>
> Someone once suggested that memory allocation errors should not be
> printed by the drivers as the memory subsystem does that anyway. No idea
> if that's a good advice or not, but I try to follow it.
>

Hi Kalle,

In general, I follow the same suggestion. However, in this particular 
code path we are handling an event message from the device, which is 
being discarded due to the allocation failure. That could be derived 
from the trace that kzalloc spews, but I preferred to have it explicitly 
stated in the logs.

Gr. AvS

