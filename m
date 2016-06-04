Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44027 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcFDQwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 12:52:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: Change long delays to sleeps
References: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
	<57530495.50302@web.de>
Date: Sat, 04 Jun 2016 19:52:00 +0300
In-Reply-To: <57530495.50302@web.de> (Jan Kiszka's message of "Sat, 4 Jun 2016
	18:40:53 +0200")
Message-ID: <87fusssxqn.fsf@kamboji.qca.qualcomm.com> (sfid-20160604_185518_607647_916254C7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jan Kiszka <jan.kiszka@web.de> writes:

> On 2016-02-15 23:12, Larry Finger wrote:
>> Routine rtl_addr_delay() uses delay statements in code that can
>> sleep. To improve system responsiveness, the various delay statements
>> are changed.
>> 
>> In addition, routines rtl_rfreg_delay() and rtl_bb_delay() are
>> rewritten to use the code in rtl_addr_delay() for most of their
>> input values.
>> 
>> Suggested-by: Byeoungwook Kim <quddnr145@gmail.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

[...]

> This breaks spectacularly when turning on a little bit of correctness
> checking:
>
> BUG: scheduling while atomic: wpa_supplicant/1116/0x00000002

This should fix it:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=de26859dcf363d520cc44e59f6dcaf20ebe0aadf

-- 
Kalle Valo
