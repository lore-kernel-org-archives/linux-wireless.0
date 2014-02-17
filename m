Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36241 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaBQQLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 11:11:38 -0500
Message-ID: <5302348A.9090700@candelatech.com> (sfid-20140217_171141_570510_B6538C8C)
Date: Mon, 17 Feb 2014 08:10:50 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC] wmi: Handle failure to start scan.
References: <1392318594-32540-1-git-send-email-greearb@candelatech.com>	<CA+BoTQmDCrmkB3FErCN-XDX6M_Vzk3BuAK3AXcNK00qePje7XA@mail.gmail.com>	<52FE3F35.4080308@candelatech.com> <CA+BoTQ=cojyffQrTGmq7zgpfUNSBB9nrZEPpy5hsngnBW2j3pA@mail.gmail.com>
In-Reply-To: <CA+BoTQ=cojyffQrTGmq7zgpfUNSBB9nrZEPpy5hsngnBW2j3pA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/16/2014 11:42 PM, Michal Kazior wrote:
> On 14 February 2014 17:07, Ben Greear <greearb@candelatech.com> wrote:

>>> We already wait for EVENT_STARTED in mac.c (see ath10k_start_scan) and
>>> clean up stuff (ath10k_abort_scan). Why not add the missing bits in
>>> there? Or is it possible to get EVENT_START_FAILED *after*
>>> EVENT_STARTED? Or am I missing something else here?
>>
>>
>> I think a lot of this would be firmware dependent, and might change between
>> various versions of the firmware.
>
> It doesn't make any sense. That would suggest a really ugly firmware
> bug. Did you see this (i.e. START_FAILED after STARTED) on 636 or
> 10.1.467?

I am working on a 10.1.389 release currently...will move forward when
I can get access to newer source code.


>> It seems to me we should handle this case and do cleanup just to be safe,
>> but maybe cleanup is needed in failure case of ath10k_start_scan as well?
>
> If you really get START_FAILED then you shouldn't have received
> STARTED before that. ath10k_start_scan() already waits for the STARTED
> event with a timeout and if it fails it triggers a cleanup. If it
> doesn't work for you then what perhaps needs to be fixed is the
> current cleanup code?

I am not certain the patch is needed.  I was looking at my firmware and it
appeared that I could hit the START_FAILED case, but perhaps it was not
really possible, and maybe newer firmware keeps it from happening entirely.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

