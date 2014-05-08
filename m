Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64808 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaEHFnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 01:43:03 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so2018590wgg.9
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 22:43:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399499440-32365-2-git-send-email-greearb@candelatech.com>
References: <1399499440-32365-1-git-send-email-greearb@candelatech.com>
	<1399499440-32365-2-git-send-email-greearb@candelatech.com>
Date: Thu, 8 May 2014 07:43:01 +0200
Message-ID: <CA+BoTQ==ayUd3PuD5FBvrKyJ2AtdZTAbFD9AVfm61T_Zn7uYfA@mail.gmail.com> (sfid-20140508_074308_355505_6388DF80)
Subject: Re: [PATCH 2/2] ath10k: support get/set antenna configurations.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 23:50,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Tested with CT firmware, but should work on standard
> firmware as well.
>
> Verified that target's tx/rx chain register is set appropriately,
> and that the tx rate goes down as number of chains
> decrease, but I did not actually try to verify antenna
> ceased to transmit when disabled.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.h |  5 +++
>  drivers/net/wireless/ath/ath10k/mac.c  | 64 ++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.c  |  5 +++
>  3 files changed, 74 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 7050c47..f7eb8050 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -472,6 +472,11 @@ struct ath10k {
>         u32 dfs_block_radar_events;
>         int install_key_rv; /* Store error code from key-install */
>
> +       unsigned char supp_tx_chainmask;
> +       unsigned char supp_rx_chainmask;
> +       unsigned char cfg_tx_chainmask;
> +       unsigned char cfg_rx_chainmask;

It's probably a good idea to note these are protected by conf_mutex.


> +
>         struct wmi_pdev_set_wmm_params_arg wmm_params;
>         struct completion install_key_done;
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index dcb147d..cc85bd9 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2483,6 +2483,61 @@ void ath10k_halt(struct ath10k *ar)
>         spin_unlock_bh(&ar->data_lock);
>  }
>
> +static int ath10k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
> +{
> +       struct ath10k *ar = hw->priv;
> +
> +       if (ar->cfg_tx_chainmask) {
> +               *tx_ant = ar->cfg_tx_chainmask;
> +               *rx_ant = ar->cfg_rx_chainmask;
> +       } else {
> +               *tx_ant = ar->supp_tx_chainmask;
> +               *rx_ant = ar->supp_rx_chainmask;
> +       }

Shouldn't this be protected by conf_mutex?


> +       return 0;
> +}
> +
> +static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
> +{
> +       int ret;
> +

+lockdep_assert_held(&ar->conf_mutex);


> +       ar->cfg_tx_chainmask = tx_ant;
> +       ar->cfg_rx_chainmask = rx_ant;
> +
> +       if (ar->state != ATH10K_STATE_ON)

This won't update set antenna during hw restart. You should accept
ATH10K_STATE_RESTARTED here too.


> +               return 0;
> +
> +       ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->tx_chain_mask,
> +                                       tx_ant);
> +       if (ret) {
> +               ath10k_warn("failed to set tx-chainmask: %d, req 0x%x\n",
> +                           ret, tx_ant);
> +               return ret;
> +       }
> +
> +       ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->rx_chain_mask,
> +                                       rx_ant);
> +       if (ret) {
> +               ath10k_warn("failed to set rx-chainmask: %d, req 0x%x\n",
> +                           ret, rx_ant);
> +               return ret;
> +       }
> +
> +       return ret;

return 0 is probably fine here too.


Michał
