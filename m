Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12989 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887AbaKNOyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 09:54:39 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] wil6210: atomic I/O for the card memory
References: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1412165125-30435-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<87fvdlsyen.fsf@kamboji.qca.qualcomm.com>
	<5466125A.7090001@broadcom.com>
Date: Fri, 14 Nov 2014 16:54:33 +0200
In-Reply-To: <5466125A.7090001@broadcom.com> (Arend van Spriel's message of
	"Fri, 14 Nov 2014 15:31:54 +0100")
Message-ID: <87bno9suhi.fsf@kamboji.qca.qualcomm.com> (sfid-20141114_155444_514868_9F618FEB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 11/14/14 14:29, Kalle Valo wrote:
>> Vladimir Kondratiev<qca_vkondrat@qca.qualcomm.com>  writes:
>>
>>> Introduce netdev IOCTLs, to be used by the debug tools.
>>>
>>> Allows to read/write single dword value or
>>> memory block, aligned to dword
>>> Different address modes supported:
>>> - BAR offset
>>> - Firmware "linker" address
>>> - target's AHB bus
>>>
>>> Signed-off-by: Vladimir Kondratiev<qca_vkondrat@qca.qualcomm.com>
>>
>> An ioctl interface for a wireless driver? IMHO that would have been ok
>> in 2004, but not in 2014. Isn't there really better way to implement
>> this?
>
> If this is really driver/device specific debug tool stuff, you should
> probably consider the vendor commands through nl80211 API.

Yeah, that's one way to do it. In ath6kl we used debugfs for this, but
no idea which one is better.

-- 
Kalle Valo
