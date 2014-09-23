Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35694 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIWJMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 05:12:24 -0400
Received: by mail-wg0-f46.google.com with SMTP id a1so3942844wgh.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 02:12:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411150659-10998-2-git-send-email-greearb@candelatech.com>
References: <1411150659-10998-1-git-send-email-greearb@candelatech.com>
	<1411150659-10998-2-git-send-email-greearb@candelatech.com>
Date: Tue, 23 Sep 2014 11:12:23 +0200
Message-ID: <CA+BoTQkxQK82rtQZXi1tyn5g=AsGQGDyKf1bF7jpuDPFq1Okbw@mail.gmail.com> (sfid-20140923_111229_001077_DDFCFEA9)
Subject: Re: [PATCH 2/2] ath10k: support ethtool stats.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 September 2014 20:17,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Add support for reading firmware stats through the ethtool
> API.  This may be easier for applications to manipulate
> compared to parsing a text based debugfs file.

You also seem to be adding fw crash and reset countes. It's probably
worth including this in the commit log.


> +#ifdef CONFIG_ATH10K_DEBUGFS
> +/* TODO:  Would be nice to always support ethtool stats, would need to
> + * move the stats storage out of ath10k_debug, or always have ath10k_debug
> + * struct available..
> + */

I was actually wondering about moving ath10k_target_stats out of debug
while doing some cleanups. Your patch can actually justify this kind
of move.


[...]
> +       data[i++] = fw_stats->hw_reaped; /* ppdu reaped */
> +       data[i++] = 0; /* tx bytes */
> +       data[i++] = fw_stats->htt_mpdus;
> +       data[i++] = 0; /* rx bytes */
> +       data[i++] = fw_stats->ch_noise_floor;
> +       data[i++] = fw_stats->cycle_count;
> +       data[i++] = fw_stats->phy_err_count;
> +       data[i++] = fw_stats->rts_bad;
> +       data[i++] = fw_stats->rts_good;
> +       data[i++] = fw_stats->chan_tx_power;
> +       data[i++] = fw_stats->fcs_bad;
> +       data[i++] = fw_stats->no_beacons;
> +       data[i++] = fw_stats->mpdu_enqued;
> +       data[i++] = fw_stats->msdu_enqued;
> +       data[i++] = fw_stats->wmm_drop;
> +       data[i++] = fw_stats->local_enqued;
> +       data[i++] = fw_stats->local_freed;
> +       data[i++] = fw_stats->hw_queued;
> +       data[i++] = fw_stats->hw_reaped;
> +       data[i++] = fw_stats->underrun;
> +       data[i++] = fw_stats->tx_abort;
> +       data[i++] = fw_stats->mpdus_requed;
> +       data[i++] = fw_stats->tx_ko;
> +       data[i++] = fw_stats->data_rc;
> +       data[i++] = fw_stats->sw_retry_failure;
> +       data[i++] = fw_stats->illgl_rate_phy_err;
> +       data[i++] = fw_stats->pdev_cont_xretry;
> +       data[i++] = fw_stats->pdev_tx_timeout;
> +       data[i++] = fw_stats->txop_ovf;
> +       data[i++] = fw_stats->pdev_resets;
> +       data[i++] = fw_stats->mid_ppdu_route_change;
> +       data[i++] = fw_stats->status_rcvd;
> +       data[i++] = fw_stats->r0_frags;
> +       data[i++] = fw_stats->r1_frags;
> +       data[i++] = fw_stats->r2_frags;
> +       data[i++] = fw_stats->r3_frags;
> +       data[i++] = fw_stats->htt_msdus;
> +       data[i++] = fw_stats->htt_mpdus;
> +       data[i++] = fw_stats->loc_msdus;
> +       data[i++] = fw_stats->loc_mpdus;
> +       data[i++] = fw_stats->phy_errs;
> +       data[i++] = fw_stats->phy_err_drop;
> +       data[i++] = fw_stats->mpdu_errs;
> +       data[i++] = ar->fw_crash_counter;
> +       data[i++] = ar->fw_warm_reset_counter;
> +       data[i++] = ar->fw_cold_reset_counter;

fw_stats should be protected by ar->data_lock. See
ath10k_read_fw_stats(). You could in theory report inconsistent stats.


> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -986,6 +986,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
>
>         spin_lock_bh(&ar->data_lock);
>
> +       ar->fw_crash_counter++;
> +
>         crash_data = ath10k_debug_get_new_fw_crash_data(ar);
>
>         if (crash_data)
> @@ -1671,6 +1673,7 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
>         u32 val;
>
>         ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset\n");
> +       ar->fw_warm_reset_counter++;
>
>         /* debug */
>         val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
> @@ -2286,6 +2289,7 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
>         u32 val;
>
>         ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cold reset\n");
> +       ar->fw_cold_reset_counter++;
>
>         /* Put Target, including PCIe, into RESET. */
>         val = ath10k_pci_reg_read32(ar, SOC_GLOBAL_RESET_ADDRESS);

Unprotected? I guess it's not terribly wrong since this is the only
place it updates the values.


Michał
