Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36842 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaKVP22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2014 10:28:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 04/10] ath10k: make firmware text debug messages more verbose.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-4-git-send-email-greearb@candelatech.com>
Date: Sat, 22 Nov 2014 17:28:22 +0200
In-Reply-To: <1411507045-18973-4-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 23 Sep 2014 14:17:19
	-0700")
Message-ID: <878uj38dbd.fsf@kamboji.qca.qualcomm.com> (sfid-20141122_162831_753452_35ADF666)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> There are not many of these messages producted by the
> firmware, but they are generally fairly useful, so print
> them at info level.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -35,6 +35,7 @@ enum ath10k_debug_mask {
>  	ATH10K_DBG_BMI		= 0x00000400,
>  	ATH10K_DBG_REGULATORY	= 0x00000800,
>  	ATH10K_DBG_TESTMODE	= 0x00001000,
> +	ATH10K_DBG_FW_MSG	= 0x00002000,

I think FW_MSG is a bit too ambiguous, so I changed this to WMI_PRINT so
that it's closer the real event name.

Full patch: https://github.com/kvalo/ath/commit/ce4269787f4b5e538731f34cb3a7358343efaa00

-- 
Kalle Valo
