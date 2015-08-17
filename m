Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64591 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbbHQNq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 09:46:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: Fix invalid survey reporting for QCA99X0
References: <1439376845-17245-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Mon, 17 Aug 2015 16:46:53 +0300
In-Reply-To: <1439376845-17245-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Wed, 12 Aug 2015 16:24:04
	+0530")
Message-ID: <87twrydo36.fsf@kamboji.qca.qualcomm.com> (sfid-20150817_154702_408467_5B511DE5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> There are three WMI_CHAN_INFO events reported per channel
> in QCA99X0 firmware. First one is a notification at the begining
> of the channel dwell time with cmd_flag as CHAN_INFO_START(cmd_flag = 0),
> second one is a notification at the end of the dwell time with cmd_flag
> CHAN_INFO_PRE_COMPLETE (cmd_flag = 2) and the third is the indication
> with CHAN_INFO_COMPLETE (cmd_flag = 1) which is the last indication for
> the channel. Since there is a new state before the completion, the handler
> is to fixed so that the counts are deducted from the ones reported with
> CHAN_INFO_START rather than the ones reported with CHAN_INFO_PRE_COMPLETE.
> Without this fix there will be lots of 0 msecs reported as active
> and busy time.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, both applied.

-- 
Kalle Valo
