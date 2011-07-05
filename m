Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2958 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab1GEMbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 08:31:39 -0400
Message-ID: <4E13041E.7050104@broadcom.com> (sfid-20110705_143142_579077_CAC95D12)
Date: Tue, 5 Jul 2011 14:31:26 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 094/119] staging: brcm80211: removed last
 occurrences of bcmsdh/BCMSDH
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <1309391303-22741-95-git-send-email-frankyl@broadcom.com>
 <20110705095905.GP2544@shale.localdomain>
In-Reply-To: <20110705095905.GP2544@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2011 11:59 AM, Dan Carpenter wrote:
> On Wed, Jun 29, 2011 at 04:47:58PM -0700, Franky Lin wrote:
>> @@ -549,7 +549,9 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
>>   						    sdio_enable_func
>>   						    (gInstance->func[2]);
>>   						if (err_ret)
>> -							sd_err(("bcmsdh_sdmmc: enable F2 failed:%d",
>> +							sd_err(("request_byte: "
>> +								"enable F2 "
>> +								"failed:%d",
>                                                                           ^^^
> 	Newline needed here.
>>   								err_ret));
>>   					} else {
>>   						/* Disable Function 2 */
>> @@ -557,7 +559,9 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
>>   						    sdio_disable_func
>>   						    (gInstance->func[2]);
>>   						if (err_ret)
>> -							sd_err(("bcmsdh_sdmmc: Disab F2 failed:%d",
>> +							sd_err(("request_byte: "
>> +								"Disab F2 "
>> +								"failed:%d",
>                                                                           ^^^
> 	Same.
>
>
>>   								err_ret));
>>   					}
>>   					sdio_release_host(gInstance->func[2]);
> regards,
> dan carpenter

Hi Dan,

First of all, thanks for milling through this list of patches.  As you 
can see the code before the patch was also missing the \n character. I 
looked in the brcmfmac code and there are several other sd_*() macros 
missing it. So I will fix all with a separate patch.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


