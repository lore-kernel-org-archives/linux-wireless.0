Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:56949 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaGVIHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 04:07:06 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so8814654wes.16
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 01:07:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405945943-8303-3-git-send-email-sw@simonwunderlich.de>
References: <1405945943-8303-1-git-send-email-sw@simonwunderlich.de>
	<1405945943-8303-3-git-send-email-sw@simonwunderlich.de>
Date: Tue, 22 Jul 2014 10:07:05 +0200
Message-ID: <CA+BoTQ=ef+NsTK4q_A6oEw19TLXMANBmBeu7-1peERZ7Fmw0ww@mail.gmail.com> (sfid-20140722_100712_642289_8CD33529)
Subject: Re: [PATCHv2 2/2] ath10k: add spectral scan feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	Sven Eckelmann <sven@narfation.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 July 2014 14:32, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
> configuring a mode through a debugfs control file. Samples can be gathered via
> another relay debugfs file.
[...]
>  #endif /* CONFIG_ATH10K_DEBUGFS */
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 348a639..14d6234 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2201,6 +2201,7 @@ void ath10k_halt(struct ath10k *ar)
>         ath10k_peer_cleanup_all(ar);
>         ath10k_core_stop(ar);
>         ath10k_hif_power_down(ar);
> +       ath10k_disable_spectral(ar);

It makes little sense to call it after powering off the chip, no?
ath10k_disable_spectral() calls ath10k_wmi_vdev_spectral_enable()
which requires WMI (and thus firmware as a whole) to be running,
otherwise you'll fail to submit the command. Anyway, if you try to
send a WMI command when hw is restarting firmware won't respond
properly anyway and it'll print a warning.


>
>         spin_lock_bh(&ar->data_lock);
>         if (ar->scan.in_progress) {
> @@ -2671,8 +2672,16 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
>                 dev_kfree_skb_any(arvif->beacon);
>                 arvif->beacon = NULL;
>         }
> +
>         spin_unlock_bh(&ar->data_lock);
>
> +       if (arvif->spectral_enabled) {
> +               ret = ath10k_disable_spectral(ar);
> +               if (ret)
> +                       ath10k_warn("Failed to disable spectral for vdev %i: %d\n",
> +                                   arvif->vdev_id, ret);

I'm aware ath10k still has some capitalized warnings but it'd be nice
to have this lower case (this is something that has been agreed upon
some time ago but still not all prints have been updated since then).


Michał
