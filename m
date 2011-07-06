Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1714 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab1GFO1h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 10:27:37 -0400
Message-ID: <4E1470CA.9000209@broadcom.com> (sfid-20110706_162740_336814_2EF640A9)
Date: Wed, 6 Jul 2011 16:27:22 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/31] staging: brcm80211: removed asserts from
 dhd_cdc.c and dhd_common.c
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
 <1309903378-29021-8-git-send-email-arend@broadcom.com>
 <20110706092401.GH18655@shale.localdomain>
In-Reply-To: <20110706092401.GH18655@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

>> @@ -317,14 +312,16 @@ brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
>>
>>   	BRCMF_TRACE(("%s: Enter\n", __func__));
>>
>> -	ASSERT(name);
>> -	ASSERT(len>= 0);
>> +	if (name == NULL || len<= 0)
>> +		return -EINVAL;
>>
>
> In the original code len == 0 was OK but now we return -EINVAL.

Agreed, this is non desirable behavior. We did not see a regression in 
our fullmac driver testing (which, I admit, is fairly limited at this 
stage). I will create an additional patch to fix this.

Thanks, Roland.

