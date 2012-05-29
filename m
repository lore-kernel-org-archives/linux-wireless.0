Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2E2Mfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 08:35:31 -0400
Date: Tue, 29 May 2012 14:35:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Zero Lin <zero.lin.0203@gmail.com>,
	Woody Hung <Woody.Hung@mediatek.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
Subject: Re: [PATCH] rt2x00:Add RT5392 chipset support
Message-ID: <20120529123502.GD2441@redhat.com> (sfid-20120529_143535_400043_A0A15648)
References: <1338279069-5630-1-git-send-email-zero.lin.0203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338279069-5630-1-git-send-email-zero.lin.0203@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2012 at 04:11:09PM +0800, Zero Lin wrote:
> From: "Zero.Lin" <Zero.Lin@mediatek.com>
Patch looks good for me.

> Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

> +	if (rt2x00_rt(rt2x00dev, RT5392)) {
> +		rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
> +		if (info->default_power1 > RT5390_POWER_BOUND)
> +			rt2x00_set_field8(&rfcsr, RFCSR50_TX,
> +					  RT5390_POWER_BOUND);
Woody, your current RT3290 patch will conflict with that one, since you
changed RT5390_POWER_BOUND to POWER_BOUND. Please rebase your patch on
top of it, as this one will most likely be applied earlier.

Thanks
Stanislaw
