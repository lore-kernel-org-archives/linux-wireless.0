Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61687 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab1EJXmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 19:42:10 -0400
Received: by yxs7 with SMTP id 7so2333278yxs.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 16:42:09 -0700 (PDT)
Message-ID: <4DC9CD4D.6060002@lwfinger.net> (sfid-20110511_014214_991866_8D821F90)
Date: Tue, 10 May 2011 18:42:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] b43: implement timeouts workaround
References: <1305072659-4011-1-git-send-email-zajec5@gmail.com> <1305072659-4011-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1305072659-4011-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 07:10 PM, Rafał Miłecki wrote:
> Documented in:<4BB81CAD.10602@lwfinger.net>

This reference is not correct.

Larry

>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/b43/main.c |   13 ++++++++++++-
>   1 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index fd8bd98..88bfd29 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4213,7 +4213,18 @@ static void b43_bluetooth_coext_disable(struct b43_wldev *dev)
>
>   static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
>   {
> -	/* TODO: implement 80211 core workaround here */
> +	struct ssb_bus *bus = dev->dev->bus;
> +	u32 tmp;
> +
> +	if ((bus->chip_id == 0x4311&&  bus->chip_rev == 2) ||
> +	    (bus->chip_id == 0x4312)) {
> +		tmp = ssb_read32(dev->dev, SSB_IMCFGLO);
> +		tmp&= ~SSB_IMCFGLO_REQTO;
> +		tmp&= ~SSB_IMCFGLO_SERTO;
> +		tmp |= 0x3;
> +		ssb_write32(dev->dev, SSB_IMCFGLO, tmp);
> +		ssb_commit_settings(bus);
> +	}
>   }
>
>   static void b43_set_synth_pu_delay(struct b43_wldev *dev, bool idle)

