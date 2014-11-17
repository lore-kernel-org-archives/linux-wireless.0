Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50319 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaKQLce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 06:32:34 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so5305535wgg.28
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2014 03:32:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416209393-24736-1-git-send-email-sujith@msujith.org>
References: <1416209393-24736-1-git-send-email-sujith@msujith.org>
Date: Mon, 17 Nov 2014 12:32:33 +0100
Message-ID: <CA+BoTQkpqVKVHFoXuTJtkTmFZA0XfU56nLRaVegWUr29z83_tQ@mail.gmail.com> (sfid-20141117_123238_163424_1B4B2EF4)
Subject: Re: [PATCH] ath10k: Block radar events when requested
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 November 2014 08:29, Sujith Manoharan <sujith@msujith.org> wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> This patch ensures that reporting of a radar in simulation
> is not done when detection is disabled explicitly by
> using the debugfs knob 'dfs_block_radar_events'.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/debug.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 9147dd3..fa1accd 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -1437,7 +1437,8 @@ static ssize_t ath10k_write_simulate_radar(struct file *file,
>  {
>         struct ath10k *ar = file->private_data;
>
> -       ieee80211_radar_detected(ar->hw);
> +       if (!ar->dfs_block_radar_events)
> +               ieee80211_radar_detected(ar->hw);

The simulate_radar knob is meant to be used with
dfs_block_radar_events being true in the first place so you can easily
block real DFS events and inject fake ones for testing of DFS upper
layers with ath10k.

Your patch breaks this. Why would you want to do that?


Michał
