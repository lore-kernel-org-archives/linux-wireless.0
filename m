Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:46228 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYJ1GdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 02:33:00 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Date: Tue, 28 Oct 2008 07:32:12 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Soeren Sonnenburg" <kernel@nn7.de>, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810272151.01244.rjw@sisk.pl> <1ba2fa240810271407o15f1f150t2d2793f4e5ad6e5b@mail.gmail.com>
In-Reply-To: <1ba2fa240810271407o15f1f150t2d2793f4e5ad6e5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810280732.12930.borntraeger@de.ibm.com> (sfid-20081028_073307_506504_647073D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 27. Oktober 2008 schrieb Tomas Winkler:
> Can someone try this one (it might be space broken I've just pasted
> that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
> (latest linux-2.6.git)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
> b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 24a1aeb..321dbc8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2090,7 +2090,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
>                 iwl4965_error_recovery(priv);
> 
>         iwl_power_update_mode(priv, 1);
> -       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
> 
>         if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
>                 iwl4965_set_mode(priv, priv->iw_mode);
> @@ -2342,6 +2341,7 @@ static void iwl_bg_alive_start(struct work_struct 
*data)
>         mutex_lock(&priv->mutex);
>         iwl_alive_start(priv);
>         mutex_unlock(&priv->mutex);
> +       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
>  }
> 
>  static void iwl4965_bg_rf_kill(struct work_struct *work)

This one works on my T61p.
