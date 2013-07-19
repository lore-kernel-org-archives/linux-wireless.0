Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59956 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3GSLEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 07:04:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: prevent HTC from being used after stopping
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
	<1374129193-3533-2-git-send-email-michal.kazior@tieto.com>
Date: Fri, 19 Jul 2013 14:04:03 +0300
In-Reply-To: <1374129193-3533-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 18 Jul 2013 08:33:11 +0200")
Message-ID: <8761w64xr0.fsf@kamboji.qca.qualcomm.com> (sfid-20130719_130414_800653_46860D12)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It was possible to submit new HTC commands
> after/while HTC stopped. This led to memory
> corruption in some rare cases.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -957,7 +955,6 @@ void ath10k_htc_stop(struct ath10k_htc *htc)
>  	}
>  
>  	ath10k_hif_stop(htc->ar);
> -	ath10k_htc_reset_endpoint_states(htc);
>  }

Is this on purpose? I can't fit it to the description.

-- 
Kalle Valo
