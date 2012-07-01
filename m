Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38715 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2GAOVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 10:21:22 -0400
Date: Sun, 1 Jul 2012 19:52:43 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] ath9k: fix power consumption on network sleep
 when BTCOEX is enabled
Message-ID: <20120701142242.GA4643@vmraj-lnx.users.atheros.com> (sfid-20120701_162158_333287_6D1A665E)
References: <1341036529-10823-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1341036529-10823-4-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1341036529-10823-4-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 30, 2012 at 11:38:48AM +0530, Rajkumar Manoharan wrote:
> The chip is waken up for every 45ms in btcoex timer cycle to
> for sharing the radio between BT and WLAN. Whenever the wlan
> interface is in network sleep mode, do not schedule hw timers.
> This could reduce power consumption on idle associated state.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/gpio.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
> index 9ae6a4d..c17168e 100644
> --- a/drivers/net/wireless/ath/ath9k/gpio.c
> +++ b/drivers/net/wireless/ath/ath9k/gpio.c
> @@ -194,6 +194,16 @@ static void ath_btcoex_period_timer(unsigned long data)
>  	struct ath_mci_profile *mci = &btcoex->mci;
>  	u32 timer_period;
>  	bool is_btscan;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sc->sc_pm_lock, flags);
> +	if (sc->sc_ah->power_mode == ATH9K_PM_NETWORK_SLEEP) {
> +		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
> +		if (btcoex->hw_timer_enabled)
> +			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);

Register access on sleep state should be avoided. Please drop this patchset.
Will send v3 series.

-Rajkumar
