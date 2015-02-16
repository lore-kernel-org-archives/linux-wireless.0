Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16601 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642AbbBPNWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 08:22:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix AP/IBSS CSA with template based fw
References: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
	<87mw4fgolp.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkZJLaAYy+PnoLiFn5S3sfJujgRRkWcMqgdxJbbf3FHeQ@mail.gmail.com>
Date: Mon, 16 Feb 2015 15:21:53 +0200
In-Reply-To: <CA+BoTQkZJLaAYy+PnoLiFn5S3sfJujgRRkWcMqgdxJbbf3FHeQ@mail.gmail.com>
	(Michal Kazior's message of "Mon, 16 Feb 2015 07:54:17 +0100")
Message-ID: <877fvigff2.fsf@kamboji.qca.qualcomm.com> (sfid-20150216_142204_360338_DE543798)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> I actually had strange conflicts already with this patch (in mac.c). As
>> I'm travelling, please check my resolution from the pending branch very
>> carefully. I might have done something stupid.
>
> There's a mistake. Only `arvif->is_up` should be protected by
> `ar->data_lock` in ath10k_bss_assoc():
>
> @@ -1852,7 +1901,9 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
>                 return;
>         }
>
> +       spin_lock_bh(&arvif->ar->data_lock);
>         arvif->is_up = true;
> +       spin_unlock_bh(&arvif->ar->data_lock);
>
>         /* Workaround: Some firmware revisions (tested with qca6174

Thanks for catching this. I fixed it now, can you please check again?

-- 
Kalle Valo
