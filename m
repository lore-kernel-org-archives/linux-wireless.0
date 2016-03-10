Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48548 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbcCJOYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 09:24:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 037/113] rtl8xxxu: First stab at adding IQK calibration for 8723bu parts
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-38-git-send-email-Jes.Sorensen@redhat.com>
Date: Thu, 10 Mar 2016 16:24:11 +0200
In-Reply-To: <1456783551-28315-38-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Mon, 29 Feb 2016 17:04:35 -0500")
Message-ID: <8737ryl8c4.fsf@purkki.adurom.net> (sfid-20160310_152433_478982_E4A8D77C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> The 8723bu also has it's own IQK calibration process. This is similar
> in flow, but still different enough to warrent it's own
> implementation, at least for now.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 811 ++++++++++++++++++++-
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   1 +
>  .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  17 +
>  3 files changed, 827 insertions(+), 2 deletions(-)
>

[...]

> +#ifdef RTL8723BU_BT
> +	/* GNT_BT = 1 */
> +	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, 0x00001800);
> +#endif

What's this about?

> +#ifdef RTL8723BU_BT
> +	/* GNT_BT = 1 */
> +	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, 0x00001800);
> +#endif

Same here.

> +#ifdef RTL8723BU_PATH_B
> +static int rtl8723bu_iqk_path_b(struct rtl8xxxu_priv *priv)

And this?

> +#if 0
> +	/* Page B init */
> +	rtl8xxxu_write32(priv, REG_CONFIG_ANT_A, 0x0f600000);
> +
> +	if (priv->tx_paths > 1)
> +		rtl8xxxu_write32(priv, REG_CONFIG_ANT_B, 0x0f600000);
> +#endif

Like discussed before, "#if 0" is not really welcomed in upstream. Can't
you just keep the unimplemented parts in a private branch and submit
them once they are ready? That way upstream code is not cluttered with
these.

-- 
Kalle Valo
