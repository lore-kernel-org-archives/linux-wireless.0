Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6469 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbbC3QUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 12:20:01 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: implement more versatile set_bitrate_mask
References: <1427201836-7741-1-git-send-email-michal.kazior@tieto.com>
	<1427201836-7741-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 30 Mar 2015 19:19:38 +0300
In-Reply-To: <1427201836-7741-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 24 Mar 2015 12:57:16 +0000")
Message-ID: <87mw2u31b8.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_182007_465714_C1C56803)
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
> rates cannot be expressed separately and only the
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
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

kbuild reported:

drivers/net/wireless/ath/ath10k/mac.c:2163 ath10k_peer_assoc_h_ht() warn: buffer overflow 'vht_mcs_mask' 8 <= 9

-- 
Kalle Valo
