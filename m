Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40705 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaCMFUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 01:20:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix struct hif_scatter_req list handling
References: <20140308113820.8885.96734.stgit@potku.adurom.net>
Date: Thu, 13 Mar 2014 07:20:33 +0200
In-Reply-To: <20140308113820.8885.96734.stgit@potku.adurom.net> (Kalle Valo's
	message of "Sat, 08 Mar 2014 13:38:20 +0200")
Message-ID: <87pplqd68u.fsf@kamboji.qca.qualcomm.com> (sfid-20140313_062042_589405_6427B3FC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Jason noticed that with Yocto GCC 4.8.1 ath6kl crashes with this iperf command:
>
> iperf -c $TARGET_IP -i 5 -t 50 -w 1M
>
> The crash was:
>

[...]

> ---[ end trace 0c038f0b8e0b67a3 ]---
> Kernel panic - not syncing: Fatal exception
>
> Jason's analysis:
>
>
>   "The GCC 4.8.1 compiler will not do the for-loop till scat_entries, instead,
>    it only run one round loop. This may be caused by that the GCC 4.8.1 thought
>    that the scat_list only have one item and then no need to do full iteration,
>    but this is simply wrong by looking at the assebly code. This will cause the sg
>    buffer not get set when scat_entries > 1 and thus lead to kernel panic.
>
>    Note: This issue not observed with GCC 4.7.2, only found on the GCC 4.8.1)"
>
> Fix this by using the normal [0] style for defining unknown number of list
> entries following the struct. This also fixes corruption with scat_q_depth, which
> was mistankely added to the end of struct and overwritten if there were more
> than item in the scat list.
>
> Reported-by: Jason Liu <r64343@freescale.com>
> Tested-by: Jason Liu <r64343@freescale.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo
