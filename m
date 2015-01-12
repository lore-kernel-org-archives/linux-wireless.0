Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:59166 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbALLhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:37:36 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] ath10k: Implement sta_add_debugfs
References: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1419407949-32367-6-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 12 Jan 2015 13:37:25 +0200
In-Reply-To: <1419407949-32367-6-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 24 Dec 2014 13:29:06 +0530")
Message-ID: <877fwsfcwa.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_123739_290164_8E4FD885)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Add per station debugfs files when a station is added to mac80211's
> station list. This helps to group peer specific debugfs entries
> altogether. Right now this callback adds support to test aggregation
> procedures (addba/addba_resp/delba) manually.
>
> To enable automatic aggregation in target,
> echo 0 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
> 	stations/XX:XX:XX:XX:XX:XX/aggr_mode
>
> For manual mode,
> echo 1 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
> 	stations/XX:XX:XX:XX:XX:XX/aggr_mode
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
> new file mode 100644
> index 0000000..d5fca70
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright (c) 2014 Qualcomm Atheros, Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +#include <linux/utsname.h>

Why include utsname.h? I don't see it used anywhere.

-- 
Kalle Valo
