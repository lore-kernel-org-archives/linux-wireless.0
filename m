Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1889 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3JAQ16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 12:27:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: Fix bug in max. VHT A-MPDU size
References: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
	<1380292567-2363-2-git-send-email-michal.kazior@tieto.com>
Date: Tue, 1 Oct 2013 19:27:52 +0300
In-Reply-To: <1380292567-2363-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 27 Sep 2013 16:36:06 +0200")
Message-ID: <87a9it6jnb.fsf@kamboji.qca.qualcomm.com> (sfid-20131001_182811_477154_BAE0E2F7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> For VHT peers, the maximum A-MPDU size has to be calculated
> from the VHT capabilities element and not the HT-cap. The formula
> is the same, but a higher value is used in VHT, allowing larger
> aggregates to be transmitted.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This kills the TCP TX throughput with D-Link DIR-865L (ath10k x86 as the
client) from ~350 Mbps to ~120 Mbps. Sujith mentioned private there's a
workaround for this, this patch should have that.

-- 
Kalle Valo
