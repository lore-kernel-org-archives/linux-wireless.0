Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3638 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaIWMyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 08:54:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k:  use 64-bit vdev map.
References: <1411149890-12618-1-git-send-email-greearb@candelatech.com>
Date: Tue, 23 Sep 2014 15:54:31 +0300
In-Reply-To: <1411149890-12618-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Fri, 19 Sep 2014 11:04:48
	-0700")
Message-ID: <878ulaebug.fsf@kamboji.qca.qualcomm.com> (sfid-20140923_145459_277474_4A046049)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This can allow more than 32 stations to be supported
> without over-running the bitmap.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> -	ar->monitor_vdev_id = bit - 1;
> +	ar->monitor_vdev_id = bit;

[...]

> -	arvif->vdev_id = bit - 1;
> +	ath10k_warn(ar, "Creating vdev id: %i  map: %llu\n",
> +		    bit, ar->free_vdev_map);
> +
> +	arvif->vdev_id = bit;

Why remove the "- 1"? Are you sure that's not going to break any
assumptions somewhere?

-- 
Kalle Valo
