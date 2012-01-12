Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47508 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2ALLTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 06:19:02 -0500
Message-ID: <4F0EC128.5060700@qca.qualcomm.com> (sfid-20120112_121908_599049_8DDD06EF)
Date: Thu, 12 Jan 2012 13:16:56 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Pachamuthu, Thirumalai" <tpachamu@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/4] ath6kl: Introduce new queue for uAPSD.
References: <1326095120-1603-1-git-send-email-tpachamu@qca.qualcomm.com> <4F0D8036.8030306@qca.qualcomm.com> <0118B7479E19DD469808F3B2CE43263BBCF5AA@aphydexd01a>
In-Reply-To: <0118B7479E19DD469808F3B2CE43263BBCF5AA@aphydexd01a>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2012 07:25 AM, Pachamuthu, Thirumalai wrote:

>> -----Original Message-----
>> From: Valo, Kalle
>> Sent: Wednesday, January 11, 2012 5:58 PM
>> To: Pachamuthu, Thirumalai
>> Cc: linux-wireless@vger.kernel.org; ath6kl-devel
>> Subject: Re: [PATCH 2/4] ath6kl: Introduce new queue for uAPSD.
>>
>> On 01/09/2012 09:45 AM, Thirumalai wrote:
>>> Add apsd_info in necessary places to indicate which AC's uAPSD is
>>> enabled.
>>>
>>> A bit is added in the wmi header (bit 4 of info3) to specify uapsd
>>> trigger in rx direction (target to host) and end of service period in
>>> tx direction (host to target)
>>>
>>> Signed-off-by: Thirumalai <tpachamu@qca.qualcomm.com>
>>
>> [...]
>>
>>> +#define WMI_DATA_HDR_TRIGGER_MASK      0x1
>>> +#define WMI_DATA_HDR_TRIGGER_SHIFT     4
>>> +
>>> +#define WMI_DATA_HDR_EOSP_MASK      WMI_DATA_HDR_TRIGGER_MASK
>>> +#define WMI_DATA_HDR_EOSP_SHIFT     WMI_DATA_HDR_TRIGGER_SHIFT
>>
>> This looks a bit odd, I can't see why you want to use trigger definitions for eosp.
>> Even if the values are same I don't see the benefit for using trigger values for
>> eosp. Is there a particular reason for this?
>>
>> Kalle
> 
> The bit in the wmi header (bit 4 of info3) to specify TRIGGER in RX direction (target to host) and the same bit will be used as ESOP in TX direction (host to target). 
> Simply we reused the existing macro which made this confusion; I will make the following change in the next release.
> 
> #define WMI_DATA_HDR_EOSP_MASK    1
> #define WMI_DATA_HDR_EOSP_SHIFT    4

Thanks, please do that. It is definitely clearer that way.

Kalle
