Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6937 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaKZGZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 01:25:50 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 05/10] ath10k: apply chainmask settings to vdev on creation.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-5-git-send-email-greearb@candelatech.com>
Date: Wed, 26 Nov 2014 08:25:37 +0200
In-Reply-To: <1411507045-18973-5-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 23 Sep 2014 14:17:20
	-0700")
Message-ID: <87bnnuzdem.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_072554_125223_295CCAF9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> It appears it takes more than just setting the
> hardware's chainmask to make things work well.  Without
> this patch, a vdev would only use 1x1 rates when chainmask
> was set to 0x3.
>
> Setting the 'nss' (number of spatial streams) on the vdev
> helps the firmware's rate-control algorithm work properly.
>
> Tested on CT firmware, but probably this works (and
> is required) on normal firmware.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> v2:  Add warning if chainmask is set to probably-invalid configuration.
>   Also, from a quick test, it appears you cannot even set the chainmask
>   using 'iw' when vdevs are active.

Thanks, applied.

-- 
Kalle Valo
