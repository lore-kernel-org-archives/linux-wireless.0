Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:42041 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbZBLEsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:48:52 -0500
Received: by rn-out-0910.google.com with SMTP id k40so609986rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:48:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <18835.42847.358511.204936@gargle.gargle.HOWL>
References: <18835.42847.358511.204936@gargle.gargle.HOWL>
Date: Wed, 11 Feb 2009 20:48:50 -0800
Message-ID: <43e72e890902112048r2569a008pe1b8a0ea1457cd4d@mail.gmail.com> (sfid-20090212_054921_131659_FC0BADF6)
Subject: Re: [PATCH 4/8] ath9k: Enable TSF Out of Range Interrupt
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 8:36 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> This patch lays the groundwork for handling TSF Out of Range
> interrupt, which will be used for power save later on.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -574,6 +574,10 @@ irqreturn_t ath_isr(int irq, void *dev)
>                                        sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
>                                }
>                        }
> +                       if (status & ATH9K_INT_TSFOOR) {
> +                               /* FIXME: Handle this interrupt for power save */
> +                               sched = true;
> +                       }

Since this is not handled yet is there a need to sched then?
