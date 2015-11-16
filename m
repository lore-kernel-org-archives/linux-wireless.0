Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38438 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbbKPU3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 15:29:32 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: poll HTT send completion when CE 5 is unused
References: <1447243286-22116-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 16 Nov 2015 22:29:21 +0200
In-Reply-To: <1447243286-22116-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 11 Nov 2015 17:31:26 +0530")
Message-ID: <871tbp1ye6.fsf@kamboji.qca.qualcomm.com> (sfid-20151116_212935_583217_E34602E6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> commit a70587b3389a ("ath10k: configure copy engine 5 for HTT messages")
> moved send completion polling under HTT Rx (CE 5) service routine. For
> QCA6174 based devices copy engine 1 (CE 1) is used for HTT Rx instead
> of CE 5. So send completion never be called. This is causing "failed to
> transmit packet, dropping: -105" errors. Fix this by processing send
> completion from CE 1 service routine instead of CE 5.
>
> Tested-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Applied to ath-current, thanks. I had a trivial conflict, please review
carefully my changes:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=ath-current&id=6419fdbb6f90e147690f8833cba59d289d613da5

-- 
Kalle Valo
