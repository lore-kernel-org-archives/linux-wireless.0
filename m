Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46025 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2ALPnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 10:43:40 -0500
Received: by ggdk6 with SMTP id k6so1032647ggd.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 07:43:40 -0800 (PST)
Message-ID: <4F0EFFA8.1060405@lwfinger.net> (sfid-20120112_164357_446017_FED18DAF)
Date: Thu, 12 Jan 2012 09:43:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Francois Romieu <romieu@fr.zoreil.com>,
	Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rtlwifi: Move RX/TX macros into common file
References: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net> <1326323232-21752-2-git-send-email-Larry.Finger@lwfinger.net> <1326328047.7886.21.camel@joe2Laptop> <4F0E332D.1060409@lwfinger.net> <20120112081935.GA10347@electric-eye.fr.zoreil.com>
In-Reply-To: <20120112081935.GA10347@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2012 02:19 AM, Francois Romieu wrote:
> Larry Finger<Larry.Finger@lwfinger.net>  :
>> On 01/11/2012 06:27 PM, Joe Perches wrote:
> [...]
>>> static inline u32 le32p_to_cpu_shift_and_mask(__le32 *desc, int shift, u32 mask)
>>> {
>>> 	return (le32_to_cpu(*desc)>>   shift)&   BIT_LEN_MASK_32(mask);
>>> }
>>
>> I need to think about this one some more.
>
> Joe only told a part of the story here : this change should eventually go
> along a definition of the descriptors as a __leXY struct and a specific
> registers / bits definition. It will be a bit tedious.
>
> [...]
>>> I don't see how centralizing these non-shared
>>> macro names helps.
>>>
>>> Maybe if the code is actually common, have a
>>> separate #include for each card with common
>>> named #defines as appropriate.
>>
>> The idea of centralizing the non-shared names was to have all these
>> macros in one place. If any need to be changes, that one file will
>> have all of them.
>
> It is paid at the price of the giant #include file and some irrelevant
> code pollution in chipset-dedicated parts of the driver. As the main
> driver maintainer, you may not win much -if anything- in return.
>
> Joe's suggestion can help with factoring out the code while exhibiting
> the differences in the data layout (i.e hardware registers). It is not
> automatic though.

John,

Please drop this set of patches. I'll decide how much of the refactoring I want 
to do later.

Larry


