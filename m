Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10331 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbbHSKPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 06:15:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: ensure pktlog disable cmd reaches fw before pdev suspend
References: <1436431783-10691-1-git-send-email-rmani@qti.qualcomm.com>
Date: Wed, 19 Aug 2015 13:14:56 +0300
In-Reply-To: <1436431783-10691-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Thu, 9 Jul 2015 14:19:42 +0530")
Message-ID: <87twrva8kf.fsf@kamboji.qca.qualcomm.com> (sfid-20150819_121508_359770_FA88197A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> Found incorrect sequence in ath10k_core_stop() where wmi pktlog
> disable cmd is passed from ath10k_debug_stop() to firmware
> immediately after wmi pdev suspend cmd. Firmware will not accept
> any wmi cmd after receiving wmi pdev suspend cmd.
>
> Fix this issue in ath10k_core_stop() by moving ath10k_debug_stop()
> just before sending pdev suspend cmd. So that pktlog disable cmd
> will get passed before pdev suspend cmd.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
