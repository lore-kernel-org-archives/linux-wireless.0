Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1KXJsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 04:48:36 -0500
Received: by wwp14 with SMTP id 14so1447374wwp.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 01:48:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322122406-10242-1-git-send-email-helmut.schaa@googlemail.com>
References: <1322122406-10242-1-git-send-email-helmut.schaa@googlemail.com>
Date: Thu, 24 Nov 2011 10:48:35 +0100
Message-ID: <CAL1gcdOj4Tjycxjyv3SRTTdB0O-6A0=W7oZCYuFR05vduPkU5A@mail.gmail.com> (sfid-20111124_104842_031136_C645FD79)
Subject: Re: [PATCH] rt2x00: Pass BlockAck and BlackAckReq frames to mac80211
 in monitor mode
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ivdoorn@gmail.com
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

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

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



-- 
---
Gertjan
