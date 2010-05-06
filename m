Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51503 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0EFRBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 13:01:32 -0400
Received: by bwz19 with SMTP id 19so107452bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 10:01:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005061229.04897.helmut.schaa@googlemail.com>
References: <201005061229.04897.helmut.schaa@googlemail.com>
Date: Thu, 6 May 2010 19:01:29 +0200
Message-ID: <s2ma32f33a41005061001w5e7258f0p3715ec238a00a4f4@mail.gmail.com>
Subject: Re: [PATCH 1/3] rt2x00: rt2800: update initial SIFS values
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 6, 2010 at 12:29 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Currently the CCK and OFDM SIFS value is set to 32us. This value is neither
> used by the Ralink driver nor specified in 802.11.
>
> Instead of using 10us for CCK SIFS (as defined in 802.11) use 16us like in the
> Ralink drivers. And indeed using a SIFS value of 10us breaks connectivity with
> 11g + CTS protected connections. Add a comment to the code why we don't use 10us
> for CCK SIFS value.
>
> The OFDM SIFS value is set to 16us (as defined in 802.11 and also used by the
> Ralink drivers).

Just wondering, but we hardcode the SIFS value in the rt2x00.h file.
Perhaps we should remove it in there, and no longer pass it from
rt2x00lib. That way there can't be any confusion about which drivers
uses the sifs field and whcih do not.

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

But that is really a different issue then this fix. So:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index e37bbea..f786068 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1415,9 +1415,16 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>
>        rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
>
> +       /*
> +        * Usually the CCK SIFS time should be set to 10 and the OFDM SIFS
> +        * time should be set to 16. However, the original Ralink driver uses
> +        * 16 for both and indeed using a value of 10 for CCK SIFS results in
> +        * connection problems with 11g + CTS protection. Hence, use the same
> +        * defaults as the Ralink driver: 16 for both, CCK and OFDM SIFS.
> +        */
>        rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
> -       rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, 32);
> -       rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, 32);
> +       rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, 16);
> +       rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, 16);
>        rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_XIFS_TIME, 4);
>        rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, 314);
>        rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
> --
> 1.6.4.2
>
>
