Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3782 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1GRVSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 17:18:22 -0400
Message-ID: <4E24A313.3080800@broadcom.com> (sfid-20110718_231829_467754_BE547C05)
Date: Mon, 18 Jul 2011 14:18:11 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/19] staging: brcm80211: remove code for
 unsupported chip
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
 <1310999405-10062-13-git-send-email-arend@broadcom.com>
 <20110718194215.GD4010@shale.localdomain>
In-Reply-To: <20110718194215.GD4010@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/18/2011 12:42:15 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Mon, Jul 18, 2011 at 04:29:58PM +0200, Arend van Spriel wrote:
>> @@ -1058,12 +1028,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
>>   		sdio_func_0.num = 0;
>>   		sdio_func_0.card = func->card;
>>   		gInstance->func[0] =&sdio_func_0;
>> -		if (func->device == 0x4) {	/* 4318 */
>> -			gInstance->func[2] = NULL;
>> -			sd_trace(("NIC found, calling brcmf_sdio_probe...\n"));
>> -			ret = brcmf_sdio_probe(&sdmmc_dev);
>> -		}
>> -		atomic_set(&brcmf_mmc_suspend, false);
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Did you intend to delete that?
>
>>   	}
>>
Hi Dan

No, i didn't. Thank you for pointing out this. I missed it when I 
rebased my local branch. It didn't break any thing because 
brcmf_mmc_suspend is a global variable. Is it ok to keep the patch like 
this? I will prepare another patch to put it back and put the variable 
in a structure instead of using a global.

Thanks,
Franky

