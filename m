Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48066 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdHCJyD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:54:03 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v2 09/12] qtnfmac: implement scan timeout
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
        <20170727230654.30850-10-sergey.matyukevich.os@quantenna.com>
Date: Thu, 03 Aug 2017 12:53:59 +0300
In-Reply-To: <20170727230654.30850-10-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Fri, 28 Jul 2017 02:06:51 +0300")
Message-ID: <87r2wtugco.fsf@purkki.adurom.net> (sfid-20170803_115406_941127_633B688F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Userspace tools may hang on scan in the case when scan completion event
> is not returned by firmware. This patch implements the scan timeout
> to avoid such situation.
>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> Signed-off-by: Avinash Patil <avinashp@quantenna.com>

[...]

> --- a/drivers/net/wireless/quantenna/qtnfmac/event.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
> @@ -345,6 +345,8 @@ qtnf_event_handle_scan_complete(struct qtnf_wmac *mac,
>  		return -EINVAL;
>  	}
>  
> +	if (timer_pending(&mac->scan_timeout))
> +		del_timer_sync(&mac->scan_timeout);

What if the device is removed while the timer is pending, is that
handled?

No need to resend because of this, a followup patch is fine. Just
started to wonder this while reviewing the patches.

-- 
Kalle Valo
