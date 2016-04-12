Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58653 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbcDLHpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 03:45:14 -0400
From: "Haim, Maya" <merez@qti.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Joe Perches <joe@perches.com>,
	qca_merez <qca_merez@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>
Subject: RE: [PATCH 1/7] wil6210: add function name to wil log macros
Date: Tue, 12 Apr 2016 07:45:07 +0000
Message-ID: <7f40e26bcec5477db74d3105972c20bc@euamsexm01a.eu.qualcomm.com> (sfid-20160412_094519_666688_30E89C64)
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1459855447-17413-2-git-send-email-qca_merez@qca.qualcomm.com>
	<1459927177.6715.34.camel@perches.com>
	<bc848beb5cd947f9905b55983a76b6f5@euamsexm01a.eu.qualcomm.com>
 <87shyx77et.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87shyx77et.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 4/7/2016 6:41 PM, Kalle Valo wrote:
> "Haim, Maya" <merez@qti.qualcomm.com> writes:
>
>> On 4/6/2016 10:19 AM, Joe Perches wrote:
>>> On Tue, 2016-04-05 at 14:24 +0300, Maya Erez wrote:
>>>> Add __func__ to all wil log macros for easier debugging.
>>> I think this is unnecessary and merely bloats code size.
>>> For all the _dbg calls, dynamic debug can add function names if 
>>> desired.
>>>
>>> If really desired, I suggest changing the logging functions to use 
>>> "%ps and __builtin_return_address(0)
>> I implemented it with __builtin_return_address(0) at first but found 
>> its format less readable (e.g. wil_start_xmit+0x58/0x7e8).
> Will that work with inline functions and with functions which the 
> compiler has optimised out?
>
That's a good point. I did a quick check and it doesn't work for inline or static functions - for such functions, the name of the calling function is printed.
We can either (1) use my initial implementation (2) add __func__ only to the wil_dbg_... macros or (3) revert this patch completely.
I find the addition of the function names very useful and since most of the code doesn't include it, it makes the analysis of issues  less efficient.
Kalle - what is your say on that?


