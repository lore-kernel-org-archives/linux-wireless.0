Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41888 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaCYIL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 04:11:58 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so123478obc.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 01:11:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
Date: Tue, 25 Mar 2014 09:11:57 +0100
Message-ID: <CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com> (sfid-20140325_091205_344910_BAD3B4FE)
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
From: Michal Kazior <michal.kazior@tieto.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2014 08:55, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> This patch is intended to fix the problem if we use the
> firmware 999.999.0.636 to get peer stats when the number
> of peer is more than 3. The WMI_UPDATE_STATS_EVENTID may
> trigger more than 1 time if the number of peers is more
> than 3. So this patch allows us to do the checking on this
> and make sure that we print the peer stats correctly.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/debug.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 7be284c..4a4072e 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -245,10 +245,17 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
>         if (num_peer_stats) {
>                 struct wmi_peer_stats_10x *peer_stats;
>                 struct ath10k_peer_stat *s;
> +               int j = 0;
> +
> +               if (!test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features) &&
> +                   !num_pdev_stats) {
> +                       j = 3;
> +                       num_peer_stats += 3;
> +               }
>
>                 stats->peers = num_peer_stats;
>
> -               for (i = 0; i < num_peer_stats; i++) {
> +               for (i = j; i < num_peer_stats; i++) {
>                         peer_stats = (struct wmi_peer_stats_10x *)tmp;
>                         s = &stats->peer_stat[i];

I suppose there's a limit how much peer entries firmware is able to
pack up into a single event. The second event you handle here is still
going to have some sort of a limit and you'll end up dropping results
again. The same probably goes with vdev stats (which aren't handled
yet, but hey).

I think a better approach would be to make read_target_stats *append*
data to the stats structure and make ath10k wait for more possible
events instead of being satisfied with just one.

The way you do it now seems like you end up with the extra results
being shown upon *next* stat request-response.. i.e. you see old
results.


Michał
