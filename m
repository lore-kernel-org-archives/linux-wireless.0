Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12607 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbcCDImm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:42:42 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: reduce rx_lock contention for htt rx
 indication
Date: Fri, 4 Mar 2016 08:42:33 +0000
Message-ID: <871t7qzlah.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_094244_866747_B14F6C75)
References: <1455257459-13343-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1455257459-13343-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 12 Feb 2016 11:40:58 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Received frame indications are queued into a skb list and latest
> processed by txrx tasklet. This skb queue is protected by htt rx lock.
> Since the entire rx processing till delivering frame to mac80211 and
> replenish tasks are processed under rx_lock protection, there might be
> some delay in queuing newly received rx frame into that list on
> multicore systems. Optimize this by using skb list lock while accessing
> rx completion queue instead of htt rx lock.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Both applied, thanks.

-- 
Kalle Valo