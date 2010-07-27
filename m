Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39027 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0G0RyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:54:15 -0400
Received: by bwz1 with SMTP id 1so3499724bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 10:54:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100727144818.6012.48437.send-patch@dhcp-lab-109.englab.brq.redhat.com>
References: <20100727144804.6012.94740.send-patch@dhcp-lab-109.englab.brq.redhat.com>
	<20100727144818.6012.48437.send-patch@dhcp-lab-109.englab.brq.redhat.com>
Date: Tue, 27 Jul 2010 19:54:13 +0200
Message-ID: <AANLkTikcKFadn_jn8GV-u_xWpcN11Z+2QP5Dt4XQsDEk@mail.gmail.com>
Subject: Re: [PATCH w-t 3/3] rt2500usb: disallow to set WEP key with non zero
	index
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 4:48 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On our hardware (050d:7050 Belkin Components F5D7050 Wireless G Adapter),
> setting any WEP key with non zero index, cause rx frames corruption.
>
> Note: perhaps (I did not check) this can be fixed differently - by using
> hw_key_idx the same as true MAC key index. But according to the comment in
> rt2x00mac_set_key():
>
> "the hardware requires keys to be assigned in correct order (When key 1
> is provided but key 0 is not, then the key is not found by the hardware
> during RX)"
>
> this will be quite problematic. Since WEP should not be used, disabling
> hardware crypto offload for it will not hurt much. Beside static
> one key WEP will still be offloaded.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 3028abb..bf059cd 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -351,6 +351,14 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
>
>        if (crypto->cmd == SET_KEY) {
>                /*
> +                * Disallow to set WEP key other than with index 0,
> +                * it is known that not work at least on some hardware.
> +                * SW crypto will be used in that case.
> +                */
> +               if (key->alg == ALG_WEP && key->keyidx != 0)
> +                       return -EOPNOTSUPP;
> +
> +               /*
>                 * Pairwise key will always be entry 0, but this
>                 * could collide with a shared key on the same
>                 * position...
> --
> 1.7.1
>
>
