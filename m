Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3367 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1GPKAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 06:00:25 -0400
Message-ID: <4E21612B.2010906@broadcom.com> (sfid-20110716_120027_327495_2547F4FE)
Date: Sat, 16 Jul 2011 12:00:11 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 35/35] staging: brcm80211: replace simple_strtoul
 usage in brcmfmac
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
 <1310678971-28952-36-git-send-email-frankyl@broadcom.com>
 <20110715234924.GH18655@shale.localdomain>
In-Reply-To: <20110715234924.GH18655@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2011 01:49 AM, Dan Carpenter wrote:
> On Thu, Jul 14, 2011 at 02:29:31PM -0700, Franky Lin wrote:
>> --- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
>> +++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
>> @@ -827,10 +827,13 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
>>   		return -EINVAL;
>>   	}
>>   	for (i = 0; *src != '\0'; i++) {
>> +		unsigned long res;
>>   		char num[3];
>>   		strncpy(num, src, 2);
>>   		num[2] = '\0';
>> -		dst[i] = (u8) simple_strtoul(num, NULL, 16);
>> +		if (kstrtoul(num, 16,&res))
>> +			return -1;
> 			^^
> Not a proper error code.

Hi Dan,

You are right. I actually had this patch before patch 21, which fixed 
the other error paths in the function. This slipped through during 
reordering of the patch. Will fix it.

Greg, Please drop this one.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


