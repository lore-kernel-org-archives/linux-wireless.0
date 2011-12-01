Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51078 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab1LALXr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 06:23:47 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: Restore testmode ABI
References: <1322738024-16626-1-git-send-email-pontus.fuchs@gmail.com>
Date: Thu, 01 Dec 2011 13:23:45 +0200
In-Reply-To: <1322738024-16626-1-git-send-email-pontus.fuchs@gmail.com>
	(Pontus Fuchs's message of "Thu, 1 Dec 2011 12:13:44 +0100")
Message-ID: <87y5uwfsce.fsf@purkki.adurom.net> (sfid-20111201_122350_762689_68A89629)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pontus Fuchs <pontus.fuchs@gmail.com> writes:

> Commit 80900d0140a7648587982c8f299830e900e49165 accidently broke
> the ABI for testmode commands. Restore the ABI again.
>

[...]

> --- a/drivers/net/wireless/wl12xx/testmode.c
> +++ b/drivers/net/wireless/wl12xx/testmode.c
> @@ -37,6 +37,7 @@ enum wl1271_tm_commands {
>  	WL1271_TM_CMD_TEST,
>  	WL1271_TM_CMD_INTERROGATE,
>  	WL1271_TM_CMD_CONFIGURE,
> +	WL1271_TM_CMD_NVS_PUSH,		/* Not in use. Keep to not break ABI */

Better to call it WL1271_TM_CMD_UNUSED1, or something like that, so that
it really stays unused.

-- 
Kalle Valo
