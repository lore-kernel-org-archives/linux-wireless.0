Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7400 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbbBOPLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 10:11:34 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: defer AP self-peer removal wait
References: <1422606682-12121-1-git-send-email-michal.kazior@tieto.com>
Date: Sun, 15 Feb 2015 17:11:28 +0200
In-Reply-To: <1422606682-12121-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 30 Jan 2015 09:31:22 +0100")
Message-ID: <87zj8fgqfz.fsf@kamboji.qca.qualcomm.com> (sfid-20150215_161150_084937_E5BA4DE9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some firmware revisions don't notify host about
> self-bss-peer removal until after associated vdev
> is deleted. This has been observed with qca6174
> WLAN.RM.2.0-00073 firmware.
>
> This patch fixes AP teardown slowdowns and
> prevents delays and warnings:
>
>  ath10k_pci 0000:00:05.0: failed to remove peer for AP vdev 0: -110
>  ath10k_pci 0000:00:05.0: removing stale peer xx:xx:xx:xx:xx:xx from vdev_id 0
>  ath10k_pci 0000:00:05.0: peer-unmap-event: unknown peer id 24
>  ath10k_pci 0000:00:05.0: peer-unmap-event: unknown peer id 8
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
