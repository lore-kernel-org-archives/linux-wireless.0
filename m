Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32613 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaCXIZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 04:25:06 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: add soft/hard firmware crash option to simulate_fw_crash
References: <20140313082431.10798.10888.stgit@potku.adurom.net>
Date: Mon, 24 Mar 2014 10:25:00 +0200
In-Reply-To: <20140313082431.10798.10888.stgit@potku.adurom.net> (Kalle Valo's
	message of "Thu, 13 Mar 2014 10:24:31 +0200")
Message-ID: <878us080mb.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_092512_359069_CF6FB99E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Marek Puzyniak <marek.puzyniak@tieto.com>
>
> Command WMI_FORCE_FW_HANG_CMDID is not supported in firmware 10.1.
> In order to have firmware crash simulation functionality also
> in firmware 10.1 driver can force firmware crash by performing not allowed
> operation. Driver can deliberately crash firmware when setting vdev param for
> vdev id out of range.  This patch introduces two keywords to simulate_fw_crash:
>
> 'soft' which will cause firmware crash that is recoverable
>        by warm firmware reset but supported only in main firmware.
> 'hard' which will cause firmware crash recoverable by cold
>        firmware reset, this option works for both firmwares.
>
> Commands to trigger firmware soft/hard crash:
>
> echo 'soft' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
> echo 'hard' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
>
> kvalo: use strncmp(), remove '\n' before checking the command and
> document how buf is null terminated
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks, applied. I just removed by strncmp() changes based on the
discussion.

-- 
Kalle Valo
