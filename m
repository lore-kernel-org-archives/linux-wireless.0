Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34969 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbGXOlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 10:41:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 08/13] wil6210: hold wil->mutex while managing vrings
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436081080-27305-9-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Fri, 24 Jul 2015 17:41:36 +0300
In-Reply-To: <1436081080-27305-9-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Sun, 5 Jul 2015 10:24:35 +0300")
Message-ID: <87vbd9d3dr.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_164145_106886_4C185204)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> To prevent race when connect flow may run in parallel with
> the disconnect event.
>
> Scenario leading to the bug is: while running connect flow on the AP,
> STA sends disconnect. log follows.

[...]

> --- a/drivers/net/wireless/ath/wil6210/txrx.c
> +++ b/drivers/net/wireless/ath/wil6210/txrx.c
> @@ -160,6 +160,7 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
>  	struct device *dev = wil_to_dev(wil);
>  	size_t sz = vring->size * sizeof(vring->va[0]);
>  
> +	WARN_ON(!mutex_is_locked(&wil->mutex));

lockdep_assert_held() is supposed to be used for verifying locking, see
ath10k for examples.

-- 
Kalle Valo
