Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53614 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2L3OT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2012 09:19:29 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so10916709obb.5
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2012 06:19:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local>
Date: Sun, 30 Dec 2012 19:49:29 +0530
Message-ID: <CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com> (sfid-20121230_151942_256986_D4FF2460)
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 11, 2012 at 3:31 PM, Cedric VONCKEN
<cedric.voncken@acksys.fr> wrote:
>         Any suggestion to fix correctly this issue ?

having a count to break out from the loop is bit hacky. I would
suggest to enable as many prints and see
why the infinite loop counts(ofcourse you can have a loop count to
figure out and break the loop).

>
>         Best regards.
>
> -----Message d'origine-----
> De : Cedric VONCKEN
> Envoyé : vendredi 7 décembre 2012 16:28
> À : 'linux-wireless@vger.kernel.org'
> Objet : [RFC] ATH9K: infinite loop in Tasklet
>
>                 Dear mailling list,
>
>                 I think there is a possible infinite loop in ATH9K tasklet, and this loop block the linux kernel.
>
>          In my test based on freescale MPC8315 cpu, the Wireless card is bridged to Ethernet driver (Gianfar). When I receive data from Wifi (iperf -c xx -b50M) to Ethernet, the Gianfar NAPI poll function is never called because the ath_rx_tasklet always loops.
>
>                 In the ath_rx_tasklet(...), the "while" loops until ath_get_next_rx_buf() or ath_edma_get_next_rx_buf returns a buffer.
>
>                 If these functions always  return a buffer, this tasklet always runs. While this tasklet runs, all other tasklets are blocked.
>       To fix it I applied this patch:
>
>       --- recv.c             2012-12-07 14:30:26.000000000 +0100
>       +++ recv.c.new                2012-12-07 14:30:05.364591961 +0100
>       @@ -1067,6 +1067,7 @@
>                      u64 tsf = 0;
>                      u32 tsf_lower = 0;
>                      unsigned long flags;
>       +             int count = 150;
>
>                       if (edma)
>                                     dma_type = DMA_BIDIRECTIONAL;
>       @@ -1085,6 +1086,10 @@
>                                     if (test_bit(SC_OP_RXFLUSH, &sc->sc_flags) && (flush == 0))
>                                                     break;
>
>       +                             if(count <= 0)
>       +                                            break;
>       +
>       +                             count --;
>                                     memset(&rs, 0, sizeof(rs));
>                                     if (edma)
>                                                     bf = ath_edma_get_next_rx_buf(sc, &rs, qtype);
>
>       I think this solution is not correct, because the tasklet is not rescheduled and we always have data in Rx buffer.
>
>                 Have you any suggestion to fix this issue correctly?
>
>                 Thanks for your help.
>
>                 Best regards.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
