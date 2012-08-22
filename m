Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab2HVKub (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 06:50:31 -0400
Date: Wed, 22 Aug 2012 12:50:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Li Chaoming <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 4/6] rtlwifi: Add changes for new vendor driver version
Message-ID: <20120822105010.GB6082@redhat.com> (sfid-20120822_125035_918741_2F95F235)
References: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
 <1345561255-10349-5-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345561255-10349-5-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2012 at 10:00:53AM -0500, Larry Finger wrote:
> From: Li Chaoming <chaoming_li@realsil.com.cn>
> 
> Realtek driver rtl_92ce_92se_92de_linux_mac80211_0005.1230.2011 includes
> many changes not previously included. The main changes are as follows:
> 
> 1. Support for the PHY mode switch implemented for some models.
> 2. Implementation of new routines for the dual-MAC devices.
> 3. Implement a mechanism for reaching the private data storage
>    of the other unit in a dual-MAC device.
> 4. Impplementation of RX aggregation.
> 5. Storage of beacon statistics for roaming.
> 6. The RX routine has been rewritten to reduce the number of O(1) buffers.
> 
> Signed-off-by: Li Chaoming <chaoming_li@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/rtlwifi/base.c  |  323 ++++++++++++++++--
>  drivers/net/wireless/rtlwifi/base.h  |   10 +-
>  drivers/net/wireless/rtlwifi/cam.c   |    7 +-
>  drivers/net/wireless/rtlwifi/core.c  |   76 +++--
>  drivers/net/wireless/rtlwifi/debug.h |    8 +
>  drivers/net/wireless/rtlwifi/efuse.c |   40 ++-
>  drivers/net/wireless/rtlwifi/efuse.h |    1 -
>  drivers/net/wireless/rtlwifi/pci.c   |  624 +++++++++++++++++++---------------
>  drivers/net/wireless/rtlwifi/pci.h   |    3 +
>  drivers/net/wireless/rtlwifi/ps.c    |   93 ++++-
>  drivers/net/wireless/rtlwifi/ps.h    |    3 +-
>  drivers/net/wireless/rtlwifi/rc.c    |    3 +-
>  drivers/net/wireless/rtlwifi/regd.c  |   18 +
>  13 files changed, 851 insertions(+), 358 deletions(-)

Could Realsil/Realtek post small patches please?

See "Separate your changes." from Documentation/SubmittingPatches.

You must have separate patches in repositories already. Life is strange,
but I don't believe Realsil/Realtek develops driver without source
control :-)

>  	    /* IEEE80211_HW_SUPPORTS_CQM_RSSI | */
> -	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 0;
> +	    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> +	    WIPHY_FLAG_IBSS_RSN |
This flags belongs to hw->wiphy->flags.

Apparently RSN IBSS functionality wasn't tested, so for now, this probably
should be removed.

> +	init_timer(&rtlpriv->works.dualmac_easyconcurrent_retrytimer);
> +	setup_timer(&rtlpriv->works.dualmac_easyconcurrent_retrytimer,
> +		    rtl_easy_concurrent_retrytimer_callback, (unsigned long)hw);
Nit: init_timer is not needed if setup_timer is used.

>  	mutex_init(&rtlpriv->locks.conf_mutex);
> -	mutex_init(&rtlpriv->locks.ps_mutex);
>  	spin_lock_init(&rtlpriv->locks.ips_lock);
>  	spin_lock_init(&rtlpriv->locks.irq_th_lock);
>  	spin_lock_init(&rtlpriv->locks.h2c_lock);
>  	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
>  	spin_lock_init(&rtlpriv->locks.rf_lock);
> +	spin_lock_init(&rtlpriv->locks.lps_lock);
This reverts various changes we did in kernel driver regarding PS
locking, which was started by commit:

commit 312d5479dcfaca2b8aa451201b5388fdb8c8684a
Author: Mike McCormack <mikem@ring3k.org>
Date:   Tue May 31 08:49:36 2011 +0900

    rtlwifi: Don't block interrupts in spinlocks

I wonder if this change does not reintroduce "disabling interrupts for
long time" problem.

Also below there is overwrite of IRQ_HANDLED fix. I did not check more,
but possibly patch also overwrite some other, more important fixes
we have in kernel version of rtlwifi driver. Larry put dozen of fixes to
driver, would be pity to lost them.

> +/* mac80211 have issues when receive del ba
> + * so here we just make a fake del_ba when we receive a ba_req
> + * but rx_agg was opened to let mac80211 release some ba
> + * related resources, so please this del_ba for tx
> + */

So this issue should be fixed in mac80211 instead of work around 
in driver.

BTW, such approach is typical "platform problem" (see
http://lwn.net/Articles/443531/), which frustrate kernel developers.
Please participate in mac80211 and other kernel core components too.

>  static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
> @@ -775,7 +865,6 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
>  	unsigned long flags;
>  	u32 inta = 0;
>  	u32 intb = 0;
> -	irqreturn_t ret = IRQ_HANDLED;
>  
>  	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
>  
> @@ -783,10 +872,8 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
>  	rtlpriv->cfg->ops->interrupt_recognized(hw, &inta, &intb);
>  
>  	/*Shared IRQ or HW disappared */
> -	if (!inta || inta == 0xffff) {
> -		ret = IRQ_NONE;
> +	if (!inta || inta == 0xffff)
>  		goto done;
> -	}
>  
>  	/*<1> beacon related */
>  	if (inta & rtlpriv->cfg->maps[RTL_IMR_TBDOK]) {
> @@ -889,7 +976,7 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
>  
>  done:
>  	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
> -	return ret;
> +	return IRQ_HANDLED;
Overwrite of:

commit de2e56cea25c80f91a6c6699de40fb3fe8b2479d
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Wed Nov 23 21:30:19 2011 -0600

    rtlwifi: Fix incorrect return of IRQ_HANDLED

> +/* this is used for other modules get
> + * hw pointer in rtl_pci_get_hw_pointer
> + */
> +static struct ieee80211_hw *hw_export;
> +
>  int __devinit rtl_pci_probe(struct pci_dev *pdev,
>  			    const struct pci_device_id *id)
>  {
> @@ -1785,6 +1832,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
>  		err = -ENOMEM;
>  		goto fail1;
>  	}
> +	hw_export = hw;
How this is suppose to work, this variable will be overwritten by
any ->pci_probe ? In general this buddy/glabal_var stuff is very 
fishy, but I did not looked in detail at that. Does all of
that actually work ? 

>  	if (rtlpci->irq_alloc) {
> +		synchronize_irq(rtlpci->pdev->irq);
>  		free_irq(rtlpci->pdev->irq, hw);
Nit: not needed - free_irq do sync internally.

> +static void _rtl_dump_channel_map(struct wiphy *wiphy)
> +{
> +	enum ieee80211_band band;
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *ch;
> +	unsigned int i;
> +
> +	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> +		if (!wiphy->bands[band])
> +			continue;
> +		sband = wiphy->bands[band];
> +		for (i = 0; i < sband->n_channels; i++)
> +			ch = &sband->channels[i];
> +	}
> +}
This functions doesn't do anything useful.

Thanks
Stanislaw
