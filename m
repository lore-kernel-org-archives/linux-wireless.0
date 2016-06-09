Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34273 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbcFIQaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 12:30:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: brcmfmac: rework function picking free BSS index
In-Reply-To: <20160609161732.90E20613F6@smtp.codeaurora.org> (Kalle Valo's
	message of "Thu, 9 Jun 2016 16:17:32 +0000 (UTC)")
References: <20160609161732.90E20613F6@smtp.codeaurora.org>
Date: Thu, 09 Jun 2016 19:30:03 +0300
Message-ID: <87eg86l3zo.fsf@purkki.adurom.net> (sfid-20160609_183034_521322_F42C9AB2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Rafał Miłecki wrote:
>> The old implementation was overcomplicated and slightly bugged in some
>> corner cases.
>> 
>> Consider following state of BSS-es (limited to 6 for simplification):
>> drvr->iflist[0]: { bsscfgidx:0, ndev->name:wlan1, }
>> drvr->iflist[1]:  (null)
>> drvr->iflist[2]: { bsscfgidx:2, ndev->name:wlan1-1, }
>> drvr->iflist[3]: { bsscfgidx:3, ndev->name:wlan1-2, }
>> drvr->iflist[4]:  (null)
>> drvr->iflist[5]:  (null)
>> In such case the next AP interface should bsscfgidx 4 (we don't use 1 as
>> it's reserved for P2P).
>> 
>> With old code the loop iterations were following:
>> [ifidx = 0] [bsscfgidx = 2] [highest = 2]
>> [ifidx = 1] [bsscfgidx = 2] [highest = 2] available = true
>> [ifidx = 2] [bsscfgidx = 2] [highest = 2] bsscfgidx = highest + 1
>> [ifidx = 3] [bsscfgidx = 3] [highest = 2] bsscfgidx = highest + 1
>> [ifidx = 4] [bsscfgidx = 3] [highest = 2] available = true
>> [ifidx = 5] [bsscfgidx = 3] [highest = 2] available = true
>> There were 2 obvious problems:
>> 1) Having empty BSS at index 1 was resulting in available being always
>>    set to true, even if we would run out of BSS-es.
>> 2) Calculated bsscfgidx was invalid (3 instead of 4) resulting in driver
>>    not being able to create the 4th AP interface.
>> 
>> New code is simpler, placed in file where it's really used, handles
>> running out of free BSS-es and allows using 4 interfaces at the same
>> time. It also looks for the first free BSS instead of one after the last
>> in use. It works well with current driver (which doesn't allow deleting
>> interfaces) and should be future proof (if we ever allow deleting).
>> 
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>
> Thanks, 1 patch applied to wireless-drivers-next.git:
>
> d02fb8f14b2d brcmfmac: rework function picking free BSS index

Now that patchwork.kernel.org is finally updated and I fixed my python
script, this is the first time I applied a patch using UTF-8 charset
directly from patchwork. As it's not exactly easy to get UTF-8 support
right in python, I would very much like to hear if there any issues
either with the commit below or the email above.

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=d02fb8f14b2d

-- 
Kalle Valo
