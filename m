Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50156 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839AbaLKJ4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2014 04:56:46 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so5829266wgg.24
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2014 01:56:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418214714-29689-3-git-send-email-michal.kazior@tieto.com>
References: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
	<1418214714-29689-3-git-send-email-michal.kazior@tieto.com>
Date: Thu, 11 Dec 2014 10:56:43 +0100
Message-ID: <CA+BoTQ=yrruA_D_M8P=szxy75x=r7oxG9ukCedEZwZBp-5JX1g@mail.gmail.com> (sfid-20141211_105651_013568_9A3C5A5F)
Subject: Re: [PATCH 2/5] ath10k: fix STA u-APSD
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 December 2014 at 13:31, Michal Kazior <michal.kazior@tieto.com> wrote:
[...]
> @@ -3036,14 +3061,11 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
>                         goto err_peer_delete;
>                 }
>
> -               param = WMI_STA_PS_PARAM_TX_WAKE_THRESHOLD;
> -               value = WMI_STA_PS_TX_WAKE_THRESHOLD_ALWAYS;
> -               ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
> -                                                 param, value);
> +               ret = ath10k_mac_vif_recalc_ps_wake_threshold(arvif);
>                 if (ret) {
> -                       ath10k_warn(ar, "failed to set vdev %i TX wake thresh: %d\n",
> +                       ath10k_warn(ar, "failed to recalc ps wake threshold on vdev %i: %d\n",
>                                     arvif->vdev_id, ret);
> -                       goto err_peer_delete;
> +                       return ret;

Oops. This is wrong. I should keep the goto.

There are also some Rx performance issues related to excessive PS-Poll usage.

I'll re-spin later.


Michał
