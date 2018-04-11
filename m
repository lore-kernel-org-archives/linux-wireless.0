Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:33983 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753027AbeDKNaw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 09:30:52 -0400
Received: by mail-ot0-f173.google.com with SMTP id m7-v6so1972269otd.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2018 06:30:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180410174245.1116-2-daniel@zonque.org>
References: <20180410174245.1116-1-daniel@zonque.org> <20180410174245.1116-2-daniel@zonque.org>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Wed, 11 Apr 2018 15:30:11 +0200
Message-ID: <CAMZdPi8C84SC6RPS6yHfAgP7Xukdvw0m=Vqm4cV6HaOh7DX=Gg@mail.gmail.com> (sfid-20180411_153056_271372_94A62CCD)
Subject: Re: [PATCH 1/1 RFC] wcn36xx: fix buffer commit logic on TX path
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

>         /* Move the head of the ring to the next empty descriptor */
> -        ch->head_blk_ctl = ctl->next;
> +        ch->head_blk_ctl = ctl_skb->next;
> +
> +       /* Commit all previous writes and set descriptors to VALID */
> +       wmb();

Is this first memory barrier really needed? from what I understand, we
only need to ensure that the control descriptor is marked valid at the
end of the procedure and we don't really care about the paylod one.

> +       desc_skb->ctrl = ch->ctrl_skb;
> +       wmb();
> +       desc_bd->ctrl = ch->ctrl_bd;
>
>         /*
>          * When connected and trying to send data frame chip can be in sleep

Otherwise, patch makes sense.

Regards,
Loic
