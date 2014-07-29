Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22974 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaG2JUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 05:20:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>, <sw@simonwunderlich.de>
Subject: Re: [PATCH 1/2] ath10k: introduce a stricter scan state machine
References: <1405941081-17359-1-git-send-email-michal.kazior@tieto.com>
	<1405941081-17359-2-git-send-email-michal.kazior@tieto.com>
Date: Tue, 29 Jul 2014 12:20:02 +0300
In-Reply-To: <1405941081-17359-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 21 Jul 2014 13:11:20 +0200")
Message-ID: <87egx4iksd.fsf@kamboji.qca.qualcomm.com> (sfid-20140729_112039_132200_7C13902E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This aims at fixing some rare scan bugs related to
> firmware reporting unexpected scan event
> sequences.
>
> One such bug was if spectral scan phyerr reporting
> prevented firmware from properly propagating scan
> events to host. This leadsl to scan timeout. After
> that next scan would trigger scan completed event
> first (before scan started event) leading to
> ar->scan.in_progress and timeout timer states to
> be overwritten incorrectly and making the very
> next scan to hang forever.
>
> Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

> +enum ath10k_scan_state {
> +	ATH10K_SCAN_IDLE,
> +	ATH10K_SCAN_STARTING,
> +	ATH10K_SCAN_RUNNING,
> +	ATH10K_SCAN_RUNNING_AND_ABORTING,
> +};

Can't we just call the last state just as ATH10K_SCAN_ABORTING? I think
I understand why you added the word "running" there but IMHO that's not
needed.

> @@ -2323,8 +2348,6 @@ void ath10k_halt(struct ath10k *ar)
>  		ath10k_monitor_stop(ar);
>  	}
>  
> -	del_timer_sync(&ar->scan.timeout);
> -	ath10k_reset_scan((unsigned long)ar);
>  	ath10k_peer_cleanup_all(ar);
>  	ath10k_core_stop(ar);
>  	ath10k_hif_power_down(ar);

Why you don't call ath10k_scan_reset() here? I would have assumed that
you do that.

-- 
Kalle Valo
