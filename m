Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60595 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1LLPyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 10:54:23 -0500
Received: by ggdk6 with SMTP id k6so1257978ggd.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 07:54:23 -0800 (PST)
Message-ID: <4EE623AB.8000101@lwfinger.net> (sfid-20111212_165427_487410_12CC767C)
Date: Mon, 12 Dec 2011 09:54:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Mike McCormack <mikem@ring3k.org>
Subject: Re: [PATCH 1/2] rtlwifi: use work for lps
References: <1323690204-5124-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1323690204-5124-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2011 05:43 AM, Stanislaw Gruszka wrote:
> Leaving leisure power save mode can take some time, so it's better to
> perform that action in process context with interrupts enabled. This
> patch changes lps_leave tasklet to work.
>
> Reported-by: Philipp Dreimann<philipp@dreimann.net>
> Tested-by: Larry Finger<Larry.Finger@lwfinger.net>
> Cc: Mike McCormack<mikem@ring3k.org>
> Cc: Chaoming Li<chaoming_li@realsil.com.cn>
> Signed-off-by: Stanislaw Gruszka<sgruszka@redhat.com>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


> ---
>   drivers/net/wireless/rtlwifi/pci.c  |   26 ++++++++++++++------------
>   drivers/net/wireless/rtlwifi/wifi.h |    3 ++-
>   2 files changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 91f0525..0d4d242 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -610,7 +610,7 @@ tx_status_ok:
>   	if (((rtlpriv->link_info.num_rx_inperiod +
>   		rtlpriv->link_info.num_tx_inperiod)>  8) ||
>   		(rtlpriv->link_info.num_rx_inperiod>  2)) {
> -		tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
> +		schedule_work(&rtlpriv->works.lps_leave_work);
>   	}
>   }
>
> @@ -736,7 +736,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>   		if (((rtlpriv->link_info.num_rx_inperiod +
>   			rtlpriv->link_info.num_tx_inperiod)>  8) ||
>   			(rtlpriv->link_info.num_rx_inperiod>  2)) {
> -			tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
> +			schedule_work(&rtlpriv->works.lps_leave_work);
>   		}
>
>   		dev_kfree_skb_any(skb);
> @@ -903,11 +903,6 @@ static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
>   	_rtl_pci_tx_chk_waitq(hw);
>   }
>
> -static void _rtl_pci_ips_leave_tasklet(struct ieee80211_hw *hw)
> -{
> -	rtl_lps_leave(hw);
> -}
> -
>   static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> @@ -945,6 +940,15 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
>   	return;
>   }
>
> +static void rtl_lps_leave_work_callback(struct work_struct *work)
> +{
> +	struct rtl_works *rtlworks =
> +	    container_of(work, struct rtl_works, lps_leave_work);
> +	struct ieee80211_hw *hw = rtlworks->hw;
> +
> +	rtl_lps_leave(hw);
> +}
> +
>   static void _rtl_pci_init_trx_var(struct ieee80211_hw *hw)
>   {
>   	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> @@ -1006,9 +1010,7 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
>   	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
>   		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
>   		     (unsigned long)hw);
> -	tasklet_init(&rtlpriv->works.ips_leave_tasklet,
> -		     (void (*)(unsigned long))_rtl_pci_ips_leave_tasklet,
> -		     (unsigned long)hw);
> +	INIT_WORK(&rtlpriv->works.lps_leave_work, rtl_lps_leave_work_callback);
>   }
>
>   static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
> @@ -1478,7 +1480,7 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
>
>   	synchronize_irq(rtlpci->pdev->irq);
>   	tasklet_kill(&rtlpriv->works.irq_tasklet);
> -	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
> +	cancel_work_sync(&rtlpriv->works.lps_leave_work);
>
>   	flush_workqueue(rtlpriv->works.rtl_wq);
>   	destroy_workqueue(rtlpriv->works.rtl_wq);
> @@ -1553,7 +1555,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
>   	set_hal_stop(rtlhal);
>
>   	rtlpriv->cfg->ops->disable_interrupt(hw);
> -	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
> +	cancel_work_sync(&rtlpriv->works.lps_leave_work);
>
>   	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flags);
>   	while (ppsc->rfchange_inprogress) {
> diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
> index f3c132b..6e6353b 100644
> --- a/drivers/net/wireless/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/rtlwifi/wifi.h
> @@ -1576,7 +1576,8 @@ struct rtl_works {
>   	/* For SW LPS */
>   	struct delayed_work ps_work;
>   	struct delayed_work ps_rfon_wq;
> -	struct tasklet_struct ips_leave_tasklet;
> +
> +	struct work_struct lps_leave_work;
>   };
>
>   struct rtl_debug {

