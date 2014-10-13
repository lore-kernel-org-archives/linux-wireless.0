Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29438 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaJMIH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 04:07:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k: expose hw restart via debugfs
References: <1412847527-25983-1-git-send-email-michal.kazior@tieto.com>
	<1412847527-25983-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 13 Oct 2014 11:07:14 +0300
In-Reply-To: <1412847527-25983-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 9 Oct 2014 11:38:46 +0200")
Message-ID: <87bnpg9yvh.fsf@kamboji.qca.qualcomm.com> (sfid-20141013_100733_447486_FB1F8889)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Until now it was possible to simulate soft and
> hard fw crashes but it wasn't possible to trigger
> an immediately hw restart itself (without the fw
> crash).
>
> This can be useful when stress testing hw
> restarting stability, e.g. during heavy tx/rx
> traffic.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Nice idea!

> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -694,7 +694,8 @@ static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
>  		"To simulate firmware crash write one of the keywords to this file:\n"
>  		"`soft` - this will send WMI_FORCE_FW_HANG_ASSERT to firmware if FW supports that command.\n"
>  		"`hard` - this will send to firmware command with illegal parameters causing firmware crash.\n"
> -		"`assert` - this will send special illegal parameter to firmware to cause assert failure and crash.\n";
> +		"`assert` - this will send special illegal parameter to firmware to cause assert failure and crash.\n"
> +		"`request` - this will simply queue hw restart without fw/hw actually crashing.\n";

"request" is not really very descriptive command. Maybe call it
"hw-restart" because that's what it really does, right?

-- 
Kalle Valo
