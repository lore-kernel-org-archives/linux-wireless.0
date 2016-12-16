Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46718 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754042AbcLPBGP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 20:06:15 -0500
Date: Thu, 15 Dec 2016 18:06:13 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin@kuvee.com
Subject: Re: [PATCH 1/3] NFC: trf7970a: add device tree option for 27MHz clock
Message-ID: <20161216010613.GA25227@animalcreek.com> (sfid-20161216_020643_790325_5D47DE31)
References: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Geoff.

On Thu, Dec 15, 2016 at 05:30:42PM -0500, Geoff Lansberry wrote:
> From: Geoff Lansberry <geoff@kuvee.com>

Please add an informative commit description to all of your commits.
No matter how trivial this patch may seem to you now, it may not be
to others (or to you in a few years).

> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 26c9dbb..2d2a077 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c

> @@ -1181,27 +1180,37 @@ static int trf7970a_in_config_rf_tech(struct trf7970a *trf, int tech)
>  	switch (tech) {
>  	case NFC_DIGITAL_RF_TECH_106A:
>  		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_14443A_106;
> -		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_OOK;
> +		trf->modulator_sys_clk_ctrl =
> +			(trf->modulator_sys_clk_ctrl & 0xF8) |

nit: s/0xF8/0xf8/ please (for consistency with the rest of the file.).

Otherwise, it looks good.

Thanks,

Mark
