Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41551 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1KXPin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 10:38:43 -0500
Received: by vbbfc26 with SMTP id fc26so1568875vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 07:38:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322122406-10242-1-git-send-email-helmut.schaa@googlemail.com>
References: <1322122406-10242-1-git-send-email-helmut.schaa@googlemail.com>
Date: Thu, 24 Nov 2011 16:38:42 +0100
Message-ID: <CAOZOX0VSbTc9=aFw1pJiDi7soaf=uWryB7LkzTMFLhBhL1cS+Q@mail.gmail.com> (sfid-20111124_163846_540630_0696293D)
Subject: Re: [PATCH] rt2x00: Pass BlockAck and BlackAckReq frames to mac80211
 in monitor mode
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	gwingerde@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 24, 2011 at 9:13 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Previously BlockAcks were always dropped by the rt2800 hardware while
> BlockAckReqs were always accepted. However, both are only useful on
> monitor interfaces at the moment and both are control frames. So
> pass them up when mac80211 sets FIF_CONTROL.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 1ba079d..e5df380 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1203,8 +1203,10 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
>                           !(filter_flags & FIF_CONTROL));
>        rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PSPOLL,
>                           !(filter_flags & FIF_PSPOLL));
> -       rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA, 1);
> -       rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
> +       rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA,
> +                          !(filter_flags & FIF_CONTROL));
> +       rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR,
> +                          !(filter_flags & FIF_CONTROL));
>        rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
>                           !(filter_flags & FIF_CONTROL));
>        rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);
> --
> 1.7.3.4
>
>
