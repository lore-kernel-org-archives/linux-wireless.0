Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44476 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbcDGPlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 11:41:52 -0400
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
Date: Thu, 07 Apr 2016 18:41:46 +0300
In-Reply-To: <bc848beb5cd947f9905b55983a76b6f5@euamsexm01a.eu.qualcomm.com>
	(Maya Haim's message of "Thu, 7 Apr 2016 15:04:13 +0000")
Message-ID: <87shyx77et.fsf@kamboji.qca.qualcomm.com> (sfid-20160407_174156_451695_0BF1A225)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Haim, Maya" <merez@qti.qualcomm.com> writes:

> On 4/6/2016 10:19 AM, Joe Perches wrote:
>> On Tue, 2016-04-05 at 14:24 +0300, Maya Erez wrote:
>>> Add __func__ to all wil log macros for easier debugging.
>> I think this is unnecessary and merely bloats code size.
>> For all the _dbg calls, dynamic debug can add function names if 
>> desired.
>>
>> If really desired, I suggest changing the logging functions to use 
>> "%ps and __builtin_return_address(0)
>
> I implemented it with __builtin_return_address(0) at first but found
> its format less readable (e.g. wil_start_xmit+0x58/0x7e8).

Will that work with inline functions and with functions which the
compiler has optimised out?

-- 
Kalle Valo
