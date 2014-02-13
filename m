Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40547 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaBMOuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:50:14 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Set proper nss value for the peer
References: <1392027925-8321-1-git-send-email-marek.kwaczynski@tieto.com>
Date: Thu, 13 Feb 2014 16:50:08 +0200
In-Reply-To: <1392027925-8321-1-git-send-email-marek.kwaczynski@tieto.com>
	(Marek Kwaczynski's message of "Mon, 10 Feb 2014 11:25:25 +0100")
Message-ID: <87txc383tr.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_155017_867943_74A07ED7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Kwaczynski <marek.kwaczynski@tieto.com> writes:

> It was found during testing the nss calculation does not
> cover all corner cases. Station could request eq. only MCS8
> and MCS9 (nss=2 specific). Next num_rates=2 so the driver
> sets nss=(max((2+7)/8, 1))=1. Which is wrong. The in-driver
> calculation was introduced prior (commit ddcc347b70
> mac80211: fix rx_nss calculation for drivers with hw rc).
> Since it's fixed, use mac80211 provided value from now.
> End user will experience lower throuhputs than expected
> if the nss is wrongly calculated.
>
> Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
