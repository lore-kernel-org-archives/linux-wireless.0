Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54187 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbD0Iu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 04:50:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: implement more versatile set_bitrate_mask
References: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 27 Apr 2015 11:50:47 +0300
In-Reply-To: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Apr 2015 13:32:52 +0000")
Message-ID: <878udeq7iw.fsf@kamboji.qca.qualcomm.com> (sfid-20150427_105100_931214_918A2568)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Until now only a single fixed tx rate or nss was
> allowed to be set.
>
> The patch attempts to improve this by allowing
> most bitrate masks. The limitation is VHT MCS
> rates cannot be expressed separately using
> existing firmware interfaces and only the
> following VHT MCS ranges are supported: none, 0-7,
> 0-8, and 0-9.
>
> This keeps the old behaviour when requesting
> single tx rate or single nss. The new bitrate mask
> logic is only applied to other cases that would
> return -EINVAL until now.
>
> Depending on firmware revisions some combinations
> may crash firmware so use with care, please.
>
> This depends on "ath10k: don't use reassoc flag".
> Without it key cache would effectively be
> invalidated upon bitrate change leading to
> communication being no longer possible.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
