Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34511 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0EFRCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 13:02:22 -0400
Received: by bwz19 with SMTP id 19so108023bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 10:02:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005061229.44923.helmut.schaa@googlemail.com>
References: <201005061229.44923.helmut.schaa@googlemail.com>
Date: Thu, 6 May 2010 19:02:20 +0200
Message-ID: <k2ta32f33a41005061002j6f32d4a9zbd13c9e002e8a04@mail.gmail.com>
Subject: Re: [PATCH 2/3] rt2x00: rt2800: don't overwrite SIFS values on erp
	changes
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
> The SIFS value is a constant and doesn't need to be updated on erp changes.
> Furthermore the code used 10us for both, the OFDM SIFS and CCK SIFS time
> which broke CTS protected 11g connections (see patch "rt2x00: rt2800: update
> initial SIFS values" for details).
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index f786068..858455f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -640,8 +640,6 @@ void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp)
>        rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
>
>        rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
> -       rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, erp->sifs);
> -       rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, erp->sifs);
>        rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
>        rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
>
> --
> 1.6.4.2
>
>
