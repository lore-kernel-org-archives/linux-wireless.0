Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40394 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaJJG4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 02:56:33 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so3056353wgh.28
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 23:56:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412847527-25983-4-git-send-email-michal.kazior@tieto.com>
References: <1412847527-25983-1-git-send-email-michal.kazior@tieto.com>
	<1412847527-25983-4-git-send-email-michal.kazior@tieto.com>
Date: Fri, 10 Oct 2014 08:56:31 +0200
Message-ID: <CA+BoTQkrhuBLae6+sKt36haEFUOQcch_sKz6qrK35N51-qAdPw@mail.gmail.com> (sfid-20141010_085637_613991_36875CC0)
Subject: Re: [PATCH 3/3] ath10k: speed up hw recovery
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 October 2014 11:38, Michal Kazior <michal.kazior@tieto.com> wrote:
> In some cases hw recovery was taking an absurdly
> long time due to ath10k waiting for things that
> would never really complete.
>
> Instead of waiting for inevitable timeouts poke
> all completions and wakequeues and check if it's
> still worth waiting.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]
> @@ -685,6 +685,20 @@ static void ath10k_core_restart(struct work_struct *work)
>  {
>         struct ath10k *ar = container_of(work, struct ath10k, restart_work);
>
> +       set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
> +       barrier();
> +       ieee80211_stop_queues(ar->hw);
> +       ath10k_drain_tx(ar);
> +       complete_all(&ar->scan.started);
> +       complete_all(&ar->scan.completed);
> +       complete_all(&ar->scan.on_channel);
> +       complete_all(&ar->offchan_tx_completed);
> +       complete_all(&ar->install_key_done);
> +       complete_all(&ar->vdev_setup_done);

> +       wake_up(&ar->htt.empty_tx_wq);
> +       wake_up(&ar->wmi.tx_credits_wq);
> +       wake_up(&ar->peer_mapping_wq);

Janusz found a problem with waitqueues. I'll need to move waitqueue
initialization to core_create or else if, e.g. fw probing fails
there's a chance a spurious interrupt will cause the kernel to deref
an invalid pointer.

I'll post a v2 later.


Michał
