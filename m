Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58286 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbEKPCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 11:02:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: increase relay buffer size of spectral scan
References: <1430763684-1630-1-git-send-email-poh@qca.qualcomm.com>
Date: Mon, 11 May 2015 18:02:09 +0300
In-Reply-To: <1430763684-1630-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Mon, 4 May 2015 11:21:24 -0700")
Message-ID: <878ucvi2dq.fsf@kamboji.qca.qualcomm.com> (sfid-20150511_170233_843031_95C24F8C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Spectral scan supported by ath10k has capability to monitor and report
> through whole bands and channels, but current buffer size is too small
> to save reported spectral scan data.
> This results in dropping 5G channel reports at all when dual band card
> is used, so that users are not able to analyze spectral environments.
> Hence increase the buffer size to fix the problem.
>
> A spectral data size is vary based on the number of bins, so the unit
> buffer size, 1140, is chose to minimize relay buffer fragmentation.
>
> The total buffer size is also chose in tradeoff with spectral scan
> support vs. kernel memory consumption.
> Since theoretical maximum buffer size, 9.5MB, can be consumed with
> 512 bins in dual bands, we target to cover up to 128 bins for all
> channels in dual bands and due to the buffer size limitation,
> spectral scan with bin number bigger than 128 needs to be run on
> single band each.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
