Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47409 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdEaLx1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 07:53:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add configurable debugging.
Date: Wed, 31 May 2017 11:53:13 +0000
Message-ID: <8737blnsz6.fsf@kamboji.qca.qualcomm.com> (sfid-20170531_135330_824796_8A92ADC8)
References: <20170510211925.17468-1-adrian@freebsd.org>
In-Reply-To: <20170510211925.17468-1-adrian@freebsd.org> (Adrian Chadd's
        message of "Wed, 10 May 2017 14:19:25 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> This adds a few configurable debugging options:
>
> * driver debugging and tracing is now configurable per device

So this means that there's a debugfs file
/sys/kernel/debug/ieee80211/phy0/ath10k/debug for every ath10k device.
Sounds like a good idea. I just don't like the name of file, would
debug_mask be more descriptive?

> * driver debugging and tracing is now configurable at runtime

Correction, debug_mask has been always to possible change via
/sys/module/ath10k_core/parameters/debug_mask file. Now it doesn't work
anymore, which is ok, but I think we should make it clear for users as
well.

I wonder would that work if we change the mask to 0444:

module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);

> * the debugging / tracing is not run at all (besides a mask check)
>   unless the specific debugging bitmap field is configured.

So I guess with this you mean that the function ath10k_dbg() is not
called if debug messages are disabled? This is something which is good
to do in another patch. And the original assumption was that if you care
about performance you won't even enable CONFIG_ATH10K_DEBUG, so that
path was not optimised in any way. How much benefit does this bring?

> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -2418,6 +2418,79 @@ int ath10k_debug_create(struct ath10k *ar)
>  	return 0;
>  }
> =20
> +#ifdef	CONFIG_ATH10K_DEBUGFS
> +static ssize_t ath10k_write_debug_mask(struct file *file,
> +				       const char __user *ubuf,
> +				       size_t count, loff_t *ppos)
> +{

The ifdef looks wrong, it's already inside CONFIG_ATH10K_DEBUGFS. Was it
supposed to be CONFIG_ATH10K_DEBUG?

--=20
Kalle Valo=
