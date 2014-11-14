Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:57643 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbaKNOb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 09:31:57 -0500
Message-ID: <5466125A.7090001@broadcom.com> (sfid-20141114_153201_123717_CD55690D)
Date: Fri, 14 Nov 2014 15:31:54 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] wil6210: atomic I/O for the card memory
References: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com>	<1412165125-30435-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <87fvdlsyen.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fvdlsyen.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/14/14 14:29, Kalle Valo wrote:
> Vladimir Kondratiev<qca_vkondrat@qca.qualcomm.com>  writes:
>
>> Introduce netdev IOCTLs, to be used by the debug tools.
>>
>> Allows to read/write single dword value or
>> memory block, aligned to dword
>> Different address modes supported:
>> - BAR offset
>> - Firmware "linker" address
>> - target's AHB bus
>>
>> Signed-off-by: Vladimir Kondratiev<qca_vkondrat@qca.qualcomm.com>
>
> An ioctl interface for a wireless driver? IMHO that would have been ok
> in 2004, but not in 2014. Isn't there really better way to implement
> this?

If this is really driver/device specific debug tool stuff, you should 
probably consider the vendor commands through nl80211 API.

Regards,
Arend

>> +/* Numbers SIOCDEVPRIVATE and SIOCDEVPRIVATE + 1
>> + * are used by Android devices to implement PNO (preferred network offload).
>> + * Albeit it is temporary solution, use different numbers to avoid conflicts
>> + */
>
> Comments like this make me even more worried that that this is just yet
> another way to implement wext iwpriv interface.
>

