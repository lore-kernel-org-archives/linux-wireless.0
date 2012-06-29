Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29669 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2F2BP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 21:15:57 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20461.389.702734.453934@gargle.gargle.HOWL> (sfid-20120629_031624_077417_26CD8B70)
Date: Fri, 29 Jun 2012 06:44:45 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Rajkumar Manoharan" <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: [RFC] ath9k: Fix clearing of BTCOEX flags
In-Reply-To: <1340885952-5317-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340885952-5317-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> BTCOEX flags are set/cleared by atomic operations.
> We got to do the same in ath9k_btcoex_timer_resume,
> while clearing those BTCOEX flags.
> 
> Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/gpio.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
> index 26032cb..bd342cd 100644
> --- a/drivers/net/wireless/ath/ath9k/gpio.c
> +++ b/drivers/net/wireless/ath/ath9k/gpio.c
> @@ -305,7 +305,8 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
>  
>  	btcoex->bt_priority_cnt = 0;
>  	btcoex->bt_priority_time = jiffies;
> -	btcoex->op_flags &= ~(BT_OP_PRIORITY_DETECTED | BT_OP_SCAN);
> +	clear_bit(BT_OP_PRIORITY_DETECTED, &btcoex->op_flags);
> +	clear_bit(BT_OP_SCAN, &btcoex->op_flags);

Rebase damage.

Acked-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
