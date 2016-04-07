Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:50721 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835AbcDGQGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 12:06:15 -0400
Message-ID: <1460045158.6715.93.camel@perches.com> (sfid-20160407_180618_348598_79BD15F7)
Subject: Re: [PATCH 1/7] wil6210: add function name to wil log macros
From: Joe Perches <joe@perches.com>
To: "Haim, Maya" <merez@qti.qualcomm.com>,
	qca_merez <qca_merez@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>
Date: Thu, 07 Apr 2016 09:05:58 -0700
In-Reply-To: <bc848beb5cd947f9905b55983a76b6f5@euamsexm01a.eu.qualcomm.com>
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
	 <1459855447-17413-2-git-send-email-qca_merez@qca.qualcomm.com>
	 <1459927177.6715.34.camel@perches.com>
	 <bc848beb5cd947f9905b55983a76b6f5@euamsexm01a.eu.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-04-07 at 15:04 +0000, Haim, Maya wrote:
> On 4/6/2016 10:19 AM, Joe Perches wrote:
> > On Tue, 2016-04-05 at 14:24 +0300, Maya Erez wrote:
> > > Add __func__ to all wil log macros for easier debugging.
> > I think this is unnecessary and merely bloats code size.
> > For all the _dbg calls, dynamic debug can add function names if 
> > desired.
> > 
> > If really desired, I suggest changing the logging functions to use 
> > "%ps and __builtin_return_address(0)
[]
>  implemented it with __builtin_return_address(0) at first but found its format less readable (e.g. wil_start_xmit+0x58/0x7e8).
> I agree that using __builtin_return_address(0) simplifies the code and I'm OK with your suggestion to use it.

I believe you must have used %pS and not %ps

See: Documentation/printk-formats.txt

Symbols/Function Pointers:

	%pS	versatile_init+0x0/0x110
	%ps	versatile_init
