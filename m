Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35173 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1HPVsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 17:48:01 -0400
Received: by bke11 with SMTP id 11so264255bke.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 14:48:00 -0700 (PDT)
Message-ID: <4E4AE58C.3030008@lwfinger.net> (sfid-20110816_234807_036345_28549EEC)
Date: Tue, 16 Aug 2011 16:47:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org,
	Gregory Bellier <gregory.bellier@gmail.com>
Subject: Re: [PATCH V2] b43: warn when forcing PIO mode
References: <1313523861-2526-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1313523861-2526-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2011 02:44 PM, Rafał Miłecki wrote:
> We have resolved all the known issues with DMA mode, however some users
> (or distros) are still forcing PIO mode by config files. Without
> debugging enabled it's not noticable at all. Add the warning for them.
>
> Cc: Gregory Bellier<gregory.bellier@gmail.com>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>


> ---
> V2: typo in "parameter". I have to install spell checker for vim ;)
> Thx Gregory.
> ---
>   drivers/net/wireless/b43/main.c |    9 +++++++--
>   1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 1adadc8..e0b1156 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4636,8 +4636,13 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
>   	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
>
>   	if (b43_bus_host_is_pcmcia(dev->dev) ||
> -	    b43_bus_host_is_sdio(dev->dev) ||
> -	    dev->use_pio) {
> +	    b43_bus_host_is_sdio(dev->dev)) {
> +		dev->__using_pio_transfers = 1;
> +		err = b43_pio_init(dev);
> +	} else if (dev->use_pio) {
> +		b43warn(dev->wl, "Forced PIO by use_pio module parameter. "
> +			"This should not be needed and will result in lower "
> +			"performance.\n");
>   		dev->__using_pio_transfers = 1;
>   		err = b43_pio_init(dev);
>   	} else {

