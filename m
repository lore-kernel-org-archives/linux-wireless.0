Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:43368 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3HSLTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 07:19:40 -0400
Message-ID: <5211FF4D.8080601@openwrt.org> (sfid-20130819_131943_939617_6F95F50F)
Date: Mon, 19 Aug 2013 13:19:41 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/6] rt2x00: rt2800lib: introduce RT2800_HAS_HIGH_SHARED_MEM
 flag
References: <1376762167-24583-1-git-send-email-juhosg@openwrt.org> <1376762167-24583-3-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1376762167-24583-3-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.08.17. 19:56 keltezéssel, Gabor Juhos írta:
> Some chipsets have more than 16KB of shared memory.
> Introduce a new rt2800 specific flag to indicate that
> and add a helper function which helps to check the
> presence of the new flag.
> 
> Also enable the new flag for the RT3593 chipset which
> has 24KB of shared memory. The flag can also be used
> for other chipsets, but none of those has been tested
> yet.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    9 +++++++++
>  drivers/net/wireless/rt2x00/rt2800lib.h |   13 +++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index aa6b6b0..2d409e0 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -7697,6 +7697,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
>  
>  int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
> +	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>  	int retval;
>  	u32 reg;
>  
> @@ -7704,6 +7705,14 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
>  	if (retval)
>  		return retval;
>  
> +	switch (rt2x00dev->chip.rt) {
> +	case RT3071:
> +	case RT3593:
> +	case RT5592:
> +		__set_bit(RT2800_HAS_HIGH_SHARED_MEM, &drv_data->rt2800_flags);
> +		break;

Erm, this contradicts with the changelog. I will remove 3071 and 5592 and will
send an updated set.

-Gabor
