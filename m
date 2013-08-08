Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:52173 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934133Ab3HHKMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 06:12:05 -0400
Received: by mail-bk0-f41.google.com with SMTP id na10so610071bkb.14
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2013 03:12:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375949813-10969-3-git-send-email-michal.kazior@tieto.com>
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
	<1375949813-10969-3-git-send-email-michal.kazior@tieto.com>
Date: Thu, 8 Aug 2013 12:12:03 +0200
Message-ID: <CA+BoTQk4n=kiWhwvzieuvXp5Wou_QpkY=8iU474XPwG7P4KSiQ@mail.gmail.com> (sfid-20130808_121209_885571_C331DDF5)
Subject: Re: [PATCH 2/4] ath10k: fix HTC endpoint worker starvation
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 August 2013 10:16, Michal Kazior <michal.kazior@tieto.com> wrote:
> HTC used a worker for each endpoint. This worked
> until a slow host machine was flooded with massive
> number of TX requests. HTT related worker would
> remain active while WMI worker was starved. This
> ended up with "could not send beacon" in AP mode.
> It was even possible to see userspace being
> starved.
>
> The patch switches from using workers to using
> tasklets for processing and submitting HTC frames
> to HIF.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> (...)
>
> @@ -602,7 +602,8 @@ static void ath10k_htc_reset_endpoint_states(struct ath10k_htc *htc)
>                 skb_queue_head_init(&ep->tx_queue);
>                 ep->htc = htc;
>                 ep->tx_credit_flow_enabled = true;
> -               INIT_WORK(&ep->send_work, ath10k_htc_send_work);
> +               tasklet_init(&ep->send_task, ath10k_htc_send_task,
> +                             (unsigned long)ep);
>         }
>  }
>

Indentation is off by one here. Is it okay if I just resend this
single patch or is it easier for applying if I resend the whole
patchset?


Pozdrawiam / Best regards,
Micha³ Kazior.
