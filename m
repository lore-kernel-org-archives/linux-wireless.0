Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29114 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbbCJP2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:28:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add hw connection monitor support
References: <87fv9hyz2r.fsf@kamboji.qca.qualcomm.com>
	<1425908197-16118-1-git-send-email-michal.kazior@tieto.com>
	<1425908197-16118-2-git-send-email-michal.kazior@tieto.com>
Date: Tue, 10 Mar 2015 17:28:32 +0200
In-Reply-To: <1425908197-16118-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 9 Mar 2015 14:36:37 +0100")
Message-ID: <87twxsyiqn.fsf@kamboji.qca.qualcomm.com> (sfid-20150310_162846_693562_A844DFD5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some firmware revisions (e.g. qca6174 with fw73)
> don't deliver beacons to host reliably. This
> causes random disconnects even in perfect
> conditions. This is most visible with
> multi-channel operation.
>
> All available firmware revisions seem to support
> beacon miss offloading so there shouldn't be any
> problems.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -2139,6 +2208,8 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
>  	spin_lock_bh(&arvif->ar->data_lock);
>  	arvif->is_up = false;
>  	spin_unlock_bh(&arvif->ar->data_lock);
> +
> +	cancel_delayed_work_sync(&arvif->connection_loss_work);
>  }

There was a simple conflict here, please check the pending branch for my
resolution.

-- 
Kalle Valo
