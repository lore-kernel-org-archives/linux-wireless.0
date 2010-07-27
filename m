Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33152 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0G0RsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:48:21 -0400
Received: by bwz1 with SMTP id 1so3496689bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 10:48:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100727144804.6012.94740.send-patch@dhcp-lab-109.englab.brq.redhat.com>
References: <20100727144804.6012.94740.send-patch@dhcp-lab-109.englab.brq.redhat.com>
Date: Tue, 27 Jul 2010 19:48:19 +0200
Message-ID: <AANLkTimLmQjyypfRWrRs80P7o7Rozzhb4_fcu-KccdSH@mail.gmail.com>
Subject: Re: [PATCH w-t 1/3] rt2500usb: write keys to proper registers
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 4:48 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Fix rt2500usb hardware encryption broken by commit
> 96b61bafe22b2f2abcc833d651739edb977f1b1e
> "rt2x00: Clean up USB vendor request buffer functions"
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 4b2fef3..7892647 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -376,7 +376,7 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
>                if (key->hw_key_idx > 0 && crypto->cipher != curr_cipher)
>                        return -EOPNOTSUPP;
>
> -               rt2500usb_register_multiwrite(rt2x00dev, reg,
> +               rt2500usb_register_multiwrite(rt2x00dev, KEY_ENTRY(key->hw_key_idx),
>                                              crypto->key, sizeof(crypto->key));
>
>                /*
> --
> 1.7.1
>
>
