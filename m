Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55205 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdEaMQu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 08:16:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add configurable debugging.
Date: Wed, 31 May 2017 12:16:44 +0000
Message-ID: <87y3tdmdbo.fsf@kamboji.qca.qualcomm.com> (sfid-20170531_141656_803952_C06F356D)
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
> * driver debugging and tracing is now configurable at runtime
> * the debugging / tracing is not run at all (besides a mask check)
>   unless the specific debugging bitmap field is configured.
>
> Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2444,6 +2444,8 @@ struct ath10k *ath10k_core_create(size_t priv_size,=
 struct device *dev,
>  	ar->hw_rev =3D hw_rev;
>  	ar->hif.ops =3D hif_ops;
>  	ar->hif.bus =3D bus;
> +	ar->debug_mask =3D ath10k_debug_mask;
> +	ar->trace_debug_mask =3D ath10k_debug_mask;

Until now tracing has been always enabled, irrespective what debug_mask
has contained. Now you are changing that and by default log messages are
not delivered through tracing until user enables them. So I think to
keep the old behaviour trace_debug_mask should be ATH10K_DBG_ANY
(0xffffffff) by default and the user can modify the mask per device via
the debugfs file.

But is it really needed to be able to filter trace messages? debug_mask
I understand, but not sure about trace_debug_mask.

--=20
Kalle Valo=
