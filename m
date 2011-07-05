Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3874 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab1GEOP3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 10:15:29 -0400
Message-ID: <4E131C72.4010802@broadcom.com> (sfid-20110705_161532_499033_487042B8)
Date: Tue, 5 Jul 2011 16:15:14 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 061/119] staging: brcm80211: further renaming in
 fullmac sources
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <1309391303-22741-62-git-send-email-frankyl@broadcom.com>
 <20110705073615.GO2544@shale.localdomain>
In-Reply-To: <20110705073615.GO2544@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Dan,

I will create a patch (in the short term, couple of days) to address the 
issues you detected below. Since this patch [061/119] does not regress 
behavior, is it ok with you to *not* drop it ?

>> @@ -1046,7 +1038,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
>>
>>   	memcpy(arg_save, arg, strlen(arg) + 1);
>>
>> -	if (strlen(arg)>  BUF_SIZE) {
>> +	if (strlen(arg)>  PKTFILTER_BUF_SIZE) {
>
> strlen() doesn't include the NULL terminator so probably this test
> is off by one.  I didn't actually follow the code through to see
> where the buffer overflow happens.  The arg_save buffer is
> dynamically allocated to the correct size...  buf was the only
> buffer that is PKTFILTER_BUF_SIZE and it stores a different string.
>
> (maybe the test can just be removed?).

I agree, the test is useless. So I will remove it.

> This whole function could be cleaned up with regards to string
> handling.
>
> For example:
> 	str = "pkt_filter_add";
> 	str_len = strlen(str);
> 	strncpy(buf, str, str_len);
> 	buf[str_len] = '\0';
>
> could be replaced with:
> 	strcpy(buf, "pkt_filter_add");
>
>>   		DHD_ERROR(("Not enough buffer %d<  %d\n", (int)strlen(arg),
>>   			   (int)sizeof(buf)));
>>   		goto fail;

Not completely, since variable 'str_len' is used in subsequent code. But 
this code snippet can be simplified. Will work on it.

Thanks for the feedback,

Roland.

