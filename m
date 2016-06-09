Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34723 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbcFIQsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 12:48:32 -0400
MIME-Version: 1.0
In-Reply-To: <87eg86l3zo.fsf@purkki.adurom.net>
References: <20160609161732.90E20613F6@smtp.codeaurora.org> <87eg86l3zo.fsf@purkki.adurom.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 9 Jun 2016 18:48:31 +0200
Message-ID: <CACna6rxZEnPydDfzpyE2NXz1FSj=PVmT+vWuJ_PdScvGnBmNfQ@mail.gmail.com> (sfid-20160609_184858_064830_6C987C4E)
Subject: Re: brcmfmac: rework function picking free BSS index
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 June 2016 at 18:30, Kalle Valo <kvalo@codeaurora.org> wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Rafał Miłecki wrote:
>>> The old implementation was overcomplicated and slightly bugged in some
>>> corner cases.
>>>
>>> Consider following state of BSS-es (limited to 6 for simplification):
>>> drvr->iflist[0]: { bsscfgidx:0, ndev->name:wlan1, }
>>> drvr->iflist[1]:  (null)
>>> drvr->iflist[2]: { bsscfgidx:2, ndev->name:wlan1-1, }
>>> drvr->iflist[3]: { bsscfgidx:3, ndev->name:wlan1-2, }
>>> drvr->iflist[4]:  (null)
>>> drvr->iflist[5]:  (null)
>>> In such case the next AP interface should bsscfgidx 4 (we don't use 1 as
>>> it's reserved for P2P).
>>>
>>> With old code the loop iterations were following:
>>> [ifidx = 0] [bsscfgidx = 2] [highest = 2]
>>> [ifidx = 1] [bsscfgidx = 2] [highest = 2] available = true
>>> [ifidx = 2] [bsscfgidx = 2] [highest = 2] bsscfgidx = highest + 1
>>> [ifidx = 3] [bsscfgidx = 3] [highest = 2] bsscfgidx = highest + 1
>>> [ifidx = 4] [bsscfgidx = 3] [highest = 2] available = true
>>> [ifidx = 5] [bsscfgidx = 3] [highest = 2] available = true
>>> There were 2 obvious problems:
>>> 1) Having empty BSS at index 1 was resulting in available being always
>>>    set to true, even if we would run out of BSS-es.
>>> 2) Calculated bsscfgidx was invalid (3 instead of 4) resulting in driver
>>>    not being able to create the 4th AP interface.
>>>
>>> New code is simpler, placed in file where it's really used, handles
>>> running out of free BSS-es and allows using 4 interfaces at the same
>>> time. It also looks for the first free BSS instead of one after the last
>>> in use. It works well with current driver (which doesn't allow deleting
>>> interfaces) and should be future proof (if we ever allow deleting).
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>
>> Thanks, 1 patch applied to wireless-drivers-next.git:
>>
>> d02fb8f14b2d brcmfmac: rework function picking free BSS index
>
> Now that patchwork.kernel.org is finally updated and I fixed my python
> script, this is the first time I applied a patch using UTF-8 charset
> directly from patchwork. As it's not exactly easy to get UTF-8 support
> right in python, I would very much like to hear if there any issues
> either with the commit below or the email above.
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=d02fb8f14b2d

Look fine, thanks!

-- 
Rafał
