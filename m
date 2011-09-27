Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4964 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab1I0Jyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 05:54:35 -0400
Message-ID: <4E819D4A.3020408@broadcom.com> (sfid-20110927_115438_635812_2CCC8DFE)
Date: Tue, 27 Sep 2011 11:54:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/20] staging: brcm80211: use endian annotated
 structures in brcmsmac
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
 <1316830148-28661-10-git-send-email-frankyl@broadcom.com>
 <CACna6rzWVxDvRTFGPwG+c4a+YrpsCPoXBZc80G2Wvbt8ebpb9Q@mail.gmail.com>
In-Reply-To: <CACna6rzWVxDvRTFGPwG+c4a+YrpsCPoXBZc80G2Wvbt8ebpb9Q@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2011 11:06 PM, Rafał Miłecki wrote:
> 2011/9/24 Franky Lin<frankyl@broadcom.com>:
>> @@ -1392,20 +1407,21 @@ struct d11rxhdr {
>>         u16 RxStatus2;
>>         u16 RxTSFTime;
>>         u16 RxChan;
>> -} __packed;
>> +};
> Is this on purpose? Is this safe?

Hi Rafał,

This is indeed on purpose as this structure is aligned (no gaps) 
properly because the members are all u16 and not going over the host 
bus. However, it is used in a union with the little-endian version which 
is packed. Based on feedback regarding that union this patch needs some 
rework so it will be resend.

Gr. AvS

