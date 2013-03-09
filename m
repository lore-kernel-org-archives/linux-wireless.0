Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63211 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3CIF7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 00:59:06 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl-devel@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath6kl: cold reset target after host warm boot
References: <20130308102539.23245.55176.stgit@localhost6.localdomain6>
	<20130308102711.23245.98569.stgit@localhost6.localdomain6>
Date: Sat, 9 Mar 2013 07:58:47 +0200
In-Reply-To: <20130308102711.23245.98569.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Fri, 8 Mar 2013 12:27:11 +0200")
Message-ID: <87ehfpm7vs.fsf@kamboji.qca.qualcomm.com> (sfid-20130309_065920_657247_02832F6E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Julien reported that ar6004 usb device fails to initialise after host has been rebooted and
> power is still on for the ar6004 device. He found out that doing a cold reset fixes the issue.
>
> I wasn't sure what would be the best way to detect if target needs a reset so I settled on
> checking a timeout from htc_wait_recv_ctrl_message().
>
> Reported-by: Julien Massot <jmassot@aldebaran-robotics.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

I need to fix my line wrapping, the lines are too long now.

> @@ -1842,12 +1853,6 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
>  		ath6kl_htc_stop(ar->htc_target);
>  	}
>  
> -	/*
> -	 * Try to reset the device if we can. The driver may have been
> -	 * configure NOT to reset the target during a debug session.
> -	 */
> -	ath6kl_init_hw_reset(ar);
> -

This shouldn't be there and most likely causes an regression. I'll send
v2 later.

-- 
Kalle Valo
