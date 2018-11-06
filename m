Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F14C46464
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 13:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2B2620869
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 13:19:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eYszu0t5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2B2620869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388250AbeKFWon (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 17:44:43 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:53676 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388116AbeKFWom (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 17:44:42 -0500
Received: by mail-it1-f194.google.com with SMTP id r12-v6so14937252ita.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 05:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=96tjM18lvteODpESOw9kKwxHyixzDSM3/+0GHa7e1LA=;
        b=eYszu0t5CHKkVMhz7LAk+LapA0cqNUFDFTW1C1THVBz/BF5EQ0iwlSjGURG5C1fJXP
         lW+JY2gzDYOF6TxvyFvwhN6EVx4UdqOD8h4La1dLPWmCT2cGYI1p9SRoGWoKe3pp9zmR
         FJmLLtirRv5pAYxADlkDXRofTjnaNYJuK+DB5AoxBx2X86YhX9wkveKty9fiAsyafqXi
         BfVbwcETdECd6FCqInbIdesFFbtFZicp0LRek55kuB2vaP+pO+ZA+HeaHA8AkAroOeQU
         cEua5q+9UJiI4COUdoiyJSm5eKBWzKKxMAS7Z2+A4SiMZ0S4YlezMeGg3yfdGwjvwnI/
         iv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=96tjM18lvteODpESOw9kKwxHyixzDSM3/+0GHa7e1LA=;
        b=eV8B6T1LVjJWPN5/esGTP66dcB5iUldB1lTTLpgRql6RPO6CsHamxFR7COPMm0V152
         Pgp0WF6yLDdI7USrbB5vbl0PM7IUz4+uG0nM33VM4ZOxrDkhl5A4WCEGPZVKW5a+cOR/
         wcvTMnlrepYE7szIfCZ0enWgV7+XM+D8gAVBnTixqFTCagcCjhHJr3vNjePvRauURJwD
         A1kndcgnRO8kDhc0/I8ToFtb9e+NynSLm3XG9/SgnMkoVBpXOeFrZCxmo/vBRM19Ruw/
         zx+179zzK4tjDipwjTdwvQ4it2hQRpywirZTLWEXtRE3z/4AOZoIof4fNJfsCcwVR/lT
         rJEA==
X-Gm-Message-State: AGRZ1gK5K6WbbAkrkTEoZrkE0xyL4CW2fMeJg/WaMghGL/Zyu58O4flK
        vkW0OukkgCm+nLoBJdpRXtmNVn1UxaOc+2Po25+99eO4
X-Google-Smtp-Source: AJdET5e0pAPZHV/BnaC/wRRTNYF9vyx1jIR7VszcRogK5OIvq0IJPybIYdnwO86poe/XDJ23qsvHkb65LwIWpAf8z6Q=
X-Received: by 2002:a02:d2:: with SMTP id 201-v6mr23750589jaa.19.1541510370219;
 Tue, 06 Nov 2018 05:19:30 -0800 (PST)
MIME-Version: 1.0
References: <1541507440-21008-1-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1541507440-21008-1-git-send-email-emmanuel.grumbach@intel.com>
From:   Emmanuel Grumbach <egrumbach@gmail.com>
Date:   Tue, 6 Nov 2018 15:19:18 +0200
Message-ID: <CANUX_P3YHNnr3=E9QjWeB6j-NL+LkbohMj1A3TS6V+g0cXUzaQ@mail.gmail.com>
Subject: Re: [RFC] mac80211: fix deauth TX when we disconnect
To:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        mpubbise@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Nov 6, 2018 at 2:32 PM Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
>
> The iTXQs stop/wake queue mechanism involves a whole bunch
> of locks and this is probably why the call to
> ieee80211_wake_txqs is deferred to a tasklet when called from
> __ieee80211_wake_queue.
>
> Another advantage of that is that ieee80211_wake_txqs might
> call the wake_tx_queue() callback and then the driver may
> call mac80211 which will call it back in the same context.
>
> The bug I saw is that when we send a deauth frame as a
> station we do:
>
> flush(drop=1)
> tx deauth
> flush(drop=0)
>
> While we flush we stop the queues and wake them up
> immediately after we finished flushing. The problem here is
> that the tasklet that de-facto enables the queue may not have
> run until we send the deauth. Then the deauth frame is sent
> to the driver (which is surprising by itself), but the driver
> won't get anything useful from ieee80211_tx_dequeue because
> the queue is stopped (or more precisely because
> vif->txqs_stopped[0] is true).
> Then the deauth is not sent. Later on, the tasklet will run,
> but that'll be too late. We'll already have removed all the
> vif etc...
>
> There are 2 options I see here:
> 1) do what I did in this patch (which is pretty awful because
>    of the if (lock) thing. If we wake up the queue because of
>    a reason which is internal to mac80211, call
>    ieee80211_wake_txqs synchronously since we know we are not
>    coming from the driver.
> 2) we could set vif->txqs_stopped to false synchrously and do
>    the rest of the job in a tasklet. This would allow the code
>    that sends the Tx to put the frame in the queue and the
>    driver would actually get it.
>
> Maybe others have better ideas?
>
> Change-Id: I5d3bd20ec765becb91944741c35e35f6e3888981
> Cc: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/util.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index c9cb00a..c731ddb 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -299,16 +299,16 @@ out:
>         spin_unlock_bh(&fq->lock);
>  }
>
> -void ieee80211_wake_txqs(unsigned long data)
> +static void _ieee80211_wake_txqs(struct ieee80211_local *local, bool lock)
>  {
> -       struct ieee80211_local *local = (struct ieee80211_local *)data;
>         struct ieee80211_sub_if_data *sdata;
>         int n_acs = IEEE80211_NUM_ACS;
>         unsigned long flags;
>         int i;
>
>         rcu_read_lock();
> -       spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> +       if (lock)
> +               spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
>

This is buggy of course... If lock is false, then we'll call
spin_unlock_irqrestore
further down in the function, but flags won't be initialized.
I don't really know why we have this strange pattern of a
lock
  loop
    unlock
      wake_tx_queue()
    lock
unlock

If we want not to call wake_tx_queue with the lock taken, we can
prepare a bitmap of ACs
and then call wake_tx_queue() for all the ACs, bu then of course, we
may have races.
OTOH, we may have races here as well. Someone could change queue_stop_reasons
after we release the lock and before we call wake_tx_queue and because
of that, we'd end up
waking a queue that is supposed to be stopped.

>         if (local->hw.queues < IEEE80211_NUM_ACS)
>                 n_acs = 1;
> @@ -332,10 +332,18 @@ void ieee80211_wake_txqs(unsigned long data)
>                 spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
>         }
>
> -       spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
> +       if (lock)
> +               spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
>         rcu_read_unlock();
>  }
>
> +void ieee80211_wake_txqs(unsigned long data)
> +{
> +       struct ieee80211_local *local = (struct ieee80211_local *)data;
> +
> +       _ieee80211_wake_txqs(local, true);
> +}
> +
>  void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
>  {
>         struct ieee80211_sub_if_data *sdata;
> @@ -405,8 +413,12 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
>         } else
>                 tasklet_schedule(&local->tx_pending_tasklet);
>
> -       if (local->ops->wake_tx_queue)
> -               tasklet_schedule(&local->wake_txqs_tasklet);
> +       if (local->ops->wake_tx_queue) {
> +               if (reason == IEEE80211_QUEUE_STOP_REASON_DRIVER)
> +                       tasklet_schedule(&local->wake_txqs_tasklet);
> +               else
> +                       _ieee80211_wake_txqs(local, false);
> +       }
>  }
>
>  void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
> --
> 2.7.4
>
