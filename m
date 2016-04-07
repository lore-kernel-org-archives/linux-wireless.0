Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3214 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbcDGPET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 11:04:19 -0400
From: "Haim, Maya" <merez@qti.qualcomm.com>
To: Joe Perches <joe@perches.com>,
	qca_merez <qca_merez@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>
Subject: RE: [PATCH 1/7] wil6210: add function name to wil log macros
Date: Thu, 7 Apr 2016 15:04:13 +0000
Message-ID: <bc848beb5cd947f9905b55983a76b6f5@euamsexm01a.eu.qualcomm.com> (sfid-20160407_170423_184256_FBBFE2A7)
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
	 <1459855447-17413-2-git-send-email-qca_merez@qca.qualcomm.com>
 <1459927177.6715.34.camel@perches.com>
In-Reply-To: <1459927177.6715.34.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/6/2016 10:19 AM, Joe Perches wrote:
> On Tue, 2016-04-05 at 14:24 +0300, Maya Erez wrote:
>> Add __func__ to all wil log macros for easier debugging.
> I think this is unnecessary and merely bloats code size.
> For all the _dbg calls, dynamic debug can add function names if 
> desired.
>
> If really desired, I suggest changing the logging functions to use 
> "%ps and __builtin_return_address(0)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org More majordomo info 
> at  http://vger.kernel.org/majordomo-info.html

I implemented it with __builtin_return_address(0) at first but found its format less readable (e.g. wil_start_xmit+0x58/0x7e8).
I agree that using __builtin_return_address(0) simplifies the code and I'm OK with your suggestion to use it.
