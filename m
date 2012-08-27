Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34581 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2H0ITL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 04:19:11 -0400
Received: by vcbfk26 with SMTP id fk26so4105880vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 01:19:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346019997-14487-1-git-send-email-mkl@blackshift.org>
References: <1346019997-14487-1-git-send-email-mkl@blackshift.org>
Date: Mon, 27 Aug 2012 10:19:09 +0200
Message-ID: <CAOZOX0VBUZzGYnAM1O4Do7VyskpjXUE5ewW=qtW7JsbKJtLAMQ@mail.gmail.com> (sfid-20120827_101915_021556_09238259)
Subject: Re: [PATCH] rt2x00: fix votage setting for RT3572/RT3592
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Marc Kleine-Budde <mkl@blackshift.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 27, 2012 at 12:26 AM, Marc Kleine-Budde <mkl@blackshift.org> wrote:
> According to the vendor driver v2.6.0.1, during the rf register init the SRAM
> voltage should be increased to 1.35V and after 1ms decreased back to 1.2V. This
> patch adds the field setting of LDO_CFG0_LDO_CORE_VLEVEL accordingly.
>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> Hello,
>
> I don't have the hardware to test, just stumbled over this while hacking on the
> rt3593.
>
> regards,  Marc
>
>  drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index cb8c2ac..b93516d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4089,6 +4089,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                 rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>                 msleep(1);
>                 rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
> +               rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
>                 rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>                 rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>         }
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
