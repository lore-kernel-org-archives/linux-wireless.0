Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33496 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbbHQNpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 09:45:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: wake up queue upon vif creation
References: <1438931301-27081-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 17 Aug 2015 16:45:08 +0300
In-Reply-To: <1438931301-27081-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 7 Aug 2015 09:08:21 +0200")
Message-ID: <87y4hado63.fsf@kamboji.qca.qualcomm.com> (sfid-20150817_154529_081458_D814B8CB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Vif's vdev_id is used as queue number. However due
> to the tx pausing design in ath10k it was possible
> for a new interface to be created with its tx
> queue stopped (via ieee80211_stop_queues). This
> could in turn leave the interface inoperable until
> ath10k_mac_tx_unlock() was called.
>
> This problem only affected multi-vif scenarios when
> new interfaces were created some time later after
> other interfaces have been running for some time
> and had Tx queue full at some point prior.
>
> Possible manifestation of the bug was
> authentication timeout for a client vif.
>
> Fixes: 96d828d45e16 ("ath10k: rework tx queue locking")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
