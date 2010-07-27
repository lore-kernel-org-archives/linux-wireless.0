Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51466 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab0G0Rsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:48:53 -0400
Received: by bwz1 with SMTP id 1so3496923bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 10:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100727144811.6012.56633.send-patch@dhcp-lab-109.englab.brq.redhat.com>
References: <20100727144804.6012.94740.send-patch@dhcp-lab-109.englab.brq.redhat.com>
	<20100727144811.6012.56633.send-patch@dhcp-lab-109.englab.brq.redhat.com>
Date: Tue, 27 Jul 2010 19:48:52 +0200
Message-ID: <AANLkTi=_wYb0h_+jK596+EopqNbSArVqmd6e4ahBWE2A@mail.gmail.com>
Subject: Re: [PATCH w-t 2/3] rt2500usb: truly disable encryption when
	initialize
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 4:48 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Without cipher part nullify of TXRX_CSR0 register we can receive
> corrupted frames (removed IV or IVC), after reloading rt2500usb module
> with nohwcrypt=1 option, if previous some keys were configured into
> the hardware.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 7892647..3028abb 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -813,6 +813,7 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
>        rt2500usb_register_write(rt2x00dev, MAC_CSR8, reg);
>
>        rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
> +       rt2x00_set_field16(&reg, TXRX_CSR0_ALGORITHM, CIPHER_NONE);
>        rt2x00_set_field16(&reg, TXRX_CSR0_IV_OFFSET, IEEE80211_HEADER);
>        rt2x00_set_field16(&reg, TXRX_CSR0_KEY_ID, 0);
>        rt2500usb_register_write(rt2x00dev, TXRX_CSR0, reg);
> --
> 1.7.1
>
>
