Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42871 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaENTH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 15:07:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] ath10k: clean up start() callback
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1399637749-13489-2-git-send-email-michal.kazior@tieto.com>
Date: Wed, 14 May 2014 22:07:46 +0300
In-Reply-To: <1399637749-13489-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 May 2014 14:15:45 +0200")
Message-ID: <87ppjgch6l.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_210802_793560_0BEBC6EA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This fixes failpath when override AC pdev param
> setup fails and makes other pdev params setting
> fail as well.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

>  	ar->num_started_vdevs = 0;
>  	ath10k_regd_update(ar);
>  	ret = 0;
> +	goto out;
>  
> -exit:
> +err_core_stop:
> +	ath10k_core_stop(ar);
> +err_power_down:
> +	ath10k_hif_power_down(ar);
> +err_off:
> +	ar->state = ATH10K_STATE_OFF;
> +out:
>  	mutex_unlock(&ar->conf_mutex);
>  	return ret;
>  }

Having err_ labels on the "main" code path is not good, the error
handling code should be clearly separated to make it easier to read. I
think you should use the same style as pci.c uses, for example something
like this:
       
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 
err_core_stop:
	ath10k_core_stop(ar);

err_power_down:
	ath10k_hif_power_down(ar);

err_off:
	ar->state = ATH10K_STATE_OFF;

 	mutex_unlock(&ar->conf_mutex);

 	return ret;

I know this has mutex_unlock() so it's not good either, but I think it's
still better. Other option might be to do like this:

        ret = 0;

out:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
 
err_core_stop:
	ath10k_core_stop(ar);

err_power_down:
	ath10k_hif_power_down(ar);

err_off:
	ar->state = ATH10K_STATE_OFF;

        goto out;

But not sure if it's any better. More ideas?

Oh yeah, please also add an empty line before each label.

-- 
Kalle Valo
