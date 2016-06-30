Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21250 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbcF3Koy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 06:44:54 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Fix 10.4 extended peer stats update
Date: Thu, 30 Jun 2016 10:44:47 +0000
Message-ID: <87vb0r5529.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_124621_520599_EA6F2234)
References: <1464851602-12969-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1464851602-12969-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Thu, 2 Jun 2016 12:43:22	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> 10.4 'extended peer stats' will be not be appended with normal peer stats
> data and they shall be coming in separate chunks. Fix this by maintaining
> a separate linked list 'extender peer stats' for 10.4 and update
> rx_duration for per station statistics. Also parse through beacon filter
> (if enabled), to make sure we parse the extended peer stats properly.
> This issue was exposed when more than one client is connected and
> extended peer stats for 10.4 is enabled
>
> The order for the stats is as below
> S - standard peer stats, E- extended peer stats, B - beacon filter stats
>
> {S1, S2, S3..} -> {B1, B2, B3..}(if available) -> {E1, E2, E3..}
>
> Fixes: f9575793d44c ("ath10k: enable parsing per station rx duration for 10.4")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> ---
> [v1: addressed line wrap around comment from Kalle]
> [v2: fixed ; in dummy inline function definition - thanks Sven Eckelmann]
> [v3: removed wmi-op-version suggested by Kalle, introduced fw specifi hw param for extd_stats]

I was sure I replied to this, but I can't find my reply anywhere. So I
guess I didn't, sorry about that.

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -181,6 +181,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>  			.board = QCA99X0_HW_2_0_BOARD_DATA_FILE,
>  			.board_size = QCA99X0_BOARD_DATA_SZ,
>  			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
> +			.extd_peer_stats = true,
>  		},
>  	},
>  	{
> @@ -203,6 +204,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>  			.board = QCA9984_HW_1_0_BOARD_DATA_FILE,
>  			.board_size = QCA99X0_BOARD_DATA_SZ,
>  			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
> +			.extd_peer_stats = true,
>  		},
>  	},
>  	{
> @@ -261,6 +263,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>  			.board = QCA4019_HW_1_0_BOARD_DATA_FILE,
>  			.board_size = QCA4019_BOARD_DATA_SZ,
>  			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
> +			.extd_peer_stats = true,
>  		},
>  	},
>  };

This is not a hardware feature so hw_params is not really the right
place to handle this. In the pending branch I tried to solve this a bit
differently:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ecf4daadc7677518ec7185dbddab959ac6e2db96

I added a bool "extended" to struct ath10k_fw_stats which is used to
detect if extended stats are used. Would that work? Please note that I
have only compile tested the patch.

-- 
Kalle Valo