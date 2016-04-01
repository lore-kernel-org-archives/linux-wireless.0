Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35686 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbcDAGMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 02:12:09 -0400
Received: by mail-wm0-f48.google.com with SMTP id 191so8177634wmq.0
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2016 23:12:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
References: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
Date: Fri, 1 Apr 2016 08:12:07 +0200
Message-ID: <CA+BoTQnmMKoK9z2QnTgBeRkXR0GdR1WV0XpOzD7JZnJ6QbHQ1w@mail.gmail.com> (sfid-20160401_081214_609489_5A57DB6E)
Subject: Re: [PATCH 1/3] ath10k: Ensure txrx-compl-task is stopped when
 cleaning htt-tx.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2016 at 22:59,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Otherwise, the txrx-compl-task may access some bad memory?
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_tx.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index 07b960e..58e88d3 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -376,6 +376,8 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
>  {
>         int size;
>
> +       tasklet_kill(&htt->txrx_compl_task);
> +

I think, instead, the ordering of ath10k_htt_tx_free() and
ath10k_htt_rx_free() should be reversed. It's already in the "correct"
order in ath10k_core_stop() on error path.


Michał
