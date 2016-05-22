Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44679 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbcEVFx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2016 01:53:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	James Feeney <james@nurealm.net>
Subject: Re: [PATCH] rtlwifi: Fix scheduling while atomic error from commit 49f86ec21c01
References: <1463849435-2293-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Sun, 22 May 2016 08:53:23 +0300
In-Reply-To: <1463849435-2293-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Sat, 21 May 2016 11:50:35 -0500")
Message-ID: <878tz2bpv0.fsf@kamboji.qca.qualcomm.com> (sfid-20160522_075547_521226_826EFF50)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Commit 49f86ec21c01 ("rtlwifi: Change long delays to sleeps") was correct
> for most cases; however, driver rtl8192ce calls the affected routines while
> in atomic context. The kernel bug output is as follows:
>
> BUG: scheduling while atomic: wpa_supplicant/627/0x00000002
> [...]
>   [<ffffffff815c2b39>] __schedule+0x899/0xad0
>   [<ffffffff815c2dac>] schedule+0x3c/0x90
>   [<ffffffff815c5bb2>] schedule_hrtimeout_range_clock+0xa2/0x120
>   [<ffffffff810e8b80>] ? hrtimer_init+0x120/0x120
>   [<ffffffff815c5ba6>] ? schedule_hrtimeout_range_clock+0x96/0x120
>   [<ffffffff815c5c43>] schedule_hrtimeout_range+0x13/0x20
>   [<ffffffff815c568f>] usleep_range+0x4f/0x70
>   [<ffffffffa0667218>] rtl_rfreg_delay+0x38/0x50 [rtlwifi]
>   [<ffffffffa06dd0e7>] rtl92c_phy_config_rf_with_headerfile+0xc7/0xe0 [rtl8192ce]
>
> To fix this bug, three of the changes from delay to sleep are reverted.
> Unfortunately, one of the changes involves a delay of 50 msec. The calling
> code will be modified so that this long delay can be avoided; however,
> this change is being pushed now to fix the problem in kernel 4.6.0.
>
> Fixes: 49f86ec21c01 ("rtlwifi: Change long delays to sleeps")
> Reported-by: James Feeney <james@nurealm.net>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: James Feeney <james@nurealm.net>
> Cc: Stable <stable@vger.kernel.org> [4.6+]

I'm planning to queue this to 4.7.

-- 
Kalle Valo
