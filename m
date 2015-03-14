Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:35247 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbbCNUQq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 16:16:46 -0400
Message-ID: <55049722.9090702@runbox.com> (sfid-20150314_211649_947290_55616F81)
Date: Sat, 14 Mar 2015 16:16:34 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/16] staging: rtl8723au: Improve readability of two
 very long lines
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>	 <1426216532-24058-15-git-send-email-m.v.b@runbox.com>	 <550305D5.9080209@lwfinger.net> <1426263881.11459.17.camel@perches.com>
In-Reply-To: <1426263881.11459.17.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13/03/15 12:24 PM, Joe Perches wrote:
> On Fri, 2015-03-13 at 10:44 -0500, Larry Finger wrote:
>> On 03/12/2015 10:15 PM, M. Vefa Bicakci wrote:
>>> Improve the readability of an if statement and its very long trace
>>> output line in rtl8723au's rtw_security.c.
> []
>>> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> []
>>> @@ -759,9 +759,21 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>>>
>>>   	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length-4));
>>>
>>> -	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
>>> -		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
>>> -				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
>>> +	if (crc[3] != payload[length - 1] ||
>>> +			crc[2] != payload[length - 2] ||
>>> +			crc[1] != payload[length - 3] ||
>>> +			crc[0] != payload[length - 4]) {
>>
>> The continuation lines should be lined up with the opening paren. This should be
>>
>> 	if (crc[3] != payload[length - 1] ||
>> 	    crc[2] != payload[length - 2] ||
>> 	    crc[1] != payload[length - 3] ||
>> 	    crc[0] != payload[length - 4]) {
> 
> Maybe:
> 	if (memcmp(&crc, &payload[length - 4], 4)) {
> 		RT_TRACE(etc, "%08x vs %4phN",
> 			 crc, &payload[length - 4])

Hello Larry and Joe,

Thank you for the reviews!

I have addressed your comments in my local repository, and I hope to send out
the second version of the commits for review by tomorrow.

Vefa

