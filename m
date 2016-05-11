Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38103 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbcEKKY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 06:24:28 -0400
Received: by mail-wm0-f41.google.com with SMTP id g17so73977331wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2016 03:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462835475-11079-14-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
	<1462835475-11079-14-git-send-email-greearb@candelatech.com>
Date: Wed, 11 May 2016 12:24:27 +0200
Message-ID: <CA+BoTQmg8p6AtcZ9Q79kBVUoXw7Ge3NHpYuE9XptU+eNhP-XOA@mail.gmail.com> (sfid-20160511_122432_836775_977B2E58)
Subject: Re: [PATCH 13/21] ath10k: Document cycle count related counters.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2016 at 01:11,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> They are not necessarily named in an intuitive manner,
> so at least add some comments to help the next person.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index e7c228a..c4f649f 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -189,10 +189,10 @@ struct ath10k_fw_stats_pdev {
>
>         /* PDEV stats */
>         s32 ch_noise_floor;
> -       u32 tx_frame_count;
> -       u32 rx_frame_count;
> -       u32 rx_clear_count;
> -       u32 cycle_count;
> +       u32 tx_frame_count; /* cycles spent transmitting frames */
> +       u32 rx_frame_count; /* cycles spent receiving frames */
> +       u32 rx_clear_count; /* Total channel busy time, evidently */
> +       u32 cycle_count; /* Total on-channel time */

Hmm, there are also other instances of these vars in wmi.h. Although
redundant maybe it's worth to comment them as well (or first and
foremost they should be the ones that need a comment as they are the
"source"). Just an idea.

(oh, and my silly OCD is irritated at the big/small first letters in
the comments not being consistent)


Michał
