Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47788 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbcIINgl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 09:36:41 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k:  Grab rcu_read_lock before the txqs spinlock.
Date: Fri, 9 Sep 2016 13:36:33 +0000
Message-ID: <87k2elp53z.fsf@kamboji.qca.qualcomm.com> (sfid-20160909_153644_886385_CAB6F06E)
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
        <1471569995-10028-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1471569995-10028-2-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Thu, 18 Aug 2016 18:26:34        -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> I was seeing some spin-lock hangs in this area of the code,
> and it seems more proper to do the rcu-read-lock outside of
> the spin lock.  I am not sure how much this matters, however.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index 916119c..d96c06e 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4307,8 +4307,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
>  	int max;
>  	int loop_max =3D 2000;
> =20
> -	spin_lock_bh(&ar->txqs_lock);
>  	rcu_read_lock();
> +	spin_lock_bh(&ar->txqs_lock);
> =20
>  	last =3D list_last_entry(&ar->txqs, struct ath10k_txq, list);
>  	while (!list_empty(&ar->txqs)) {
> @@ -4342,8 +4342,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
>  			break;
>  	}
> =20
> -	rcu_read_unlock();
>  	spin_unlock_bh(&ar->txqs_lock);
> +	rcu_read_unlock();

I'm no RCU expert but this isn't making any sense. Maybe it changes
timings on your kernel so that it hides the real problem?

--=20
Kalle Valo=
