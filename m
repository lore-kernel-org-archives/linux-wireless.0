Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37338 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbcDOM2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 08:28:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Haim\, Maya" <merez@qti.qualcomm.com>
Cc: Joe Perches <joe@perches.com>,
	qca_merez <qca_merez@qca.qualcomm.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 1/7] wil6210: add function name to wil log macros
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1459855447-17413-2-git-send-email-qca_merez@qca.qualcomm.com>
	<1459927177.6715.34.camel@perches.com>
	<bc848beb5cd947f9905b55983a76b6f5@euamsexm01a.eu.qualcomm.com>
	<87shyx77et.fsf@kamboji.qca.qualcomm.com>
	<7f40e26bcec5477db74d3105972c20bc@euamsexm01a.eu.qualcomm.com>
Date: Fri, 15 Apr 2016 15:28:08 +0300
In-Reply-To: <7f40e26bcec5477db74d3105972c20bc@euamsexm01a.eu.qualcomm.com>
	(Maya Haim's message of "Tue, 12 Apr 2016 07:45:07 +0000")
Message-ID: <8760vjqco7.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_142818_715304_4E5B883E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Haim, Maya" <merez@qti.qualcomm.com> writes:

> On 4/7/2016 6:41 PM, Kalle Valo wrote:
>> "Haim, Maya" <merez@qti.qualcomm.com> writes:
>>
>>> On 4/6/2016 10:19 AM, Joe Perches wrote:
>>>> On Tue, 2016-04-05 at 14:24 +0300, Maya Erez wrote:
>>>>> Add __func__ to all wil log macros for easier debugging.
>>>> I think this is unnecessary and merely bloats code size.
>>>> For all the _dbg calls, dynamic debug can add function names if 
>>>> desired.
>>>>
>>>> If really desired, I suggest changing the logging functions to use 
>>>> "%ps and __builtin_return_address(0)
>>> I implemented it with __builtin_return_address(0) at first but found 
>>> its format less readable (e.g. wil_start_xmit+0x58/0x7e8).
>> Will that work with inline functions and with functions which the 
>> compiler has optimised out?
>
> That's a good point. I did a quick check and it doesn't work for
> inline or static functions - for such functions, the name of the
> calling function is printed.

Thanks for checking.

> We can either (1) use my initial implementation (2) add __func__ only
> to the wil_dbg_... macros or (3) revert this patch completely. I find
> the addition of the function names very useful and since most of the
> code doesn't include it, it makes the analysis of issues less
> efficient. Kalle - what is your say on that?

I don't have any preference, it's up to you what you like most.

One more possibility: in ath10k we have a kconfig option
CONFIG_ATH10K_DEBUG to make it possible to disable all overhead from
debug functionality, that would at least solve Joe's concern of extra
memory usage.

-- 
Kalle Valo
