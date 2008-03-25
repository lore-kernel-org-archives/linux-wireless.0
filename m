Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:35173 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYCYUba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 16:31:30 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2945122wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 13:31:27 -0700 (PDT)
Message-ID: <1ba2fa240803251331y60f3cf58x8f08bd4411b1369d@mail.gmail.com> (sfid-20080325_203135_394885_AAB32ED9)
Date: Tue, 25 Mar 2008 22:31:27 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwlwifi: do not register bands with no supported channels
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
In-Reply-To: <1206475120-10188-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1206475120-10188-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 25, 2008 at 9:58 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>  ---
>  Otherwise, b/g-only devices fail in wiphy_register.  Tested in Fedora
>  kernels for the last week or so...
>
>   drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 ++++++--
>   drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++++--
>   2 files changed, 12 insertions(+), 4 deletions(-)
>
>  diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>  index 093b863..4ba9591 100644
>  --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>  +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>  @@ -5136,8 +5136,12 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
>                priv->bands[IEEE80211_BAND_2GHZ].n_channels,
>                priv->bands[IEEE80211_BAND_5GHZ].n_channels);
>
>  -       priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->bands[IEEE80211_BAND_2GHZ];
>  -       priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->bands[IEEE80211_BAND_5GHZ];
>  +       if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
>  +               priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
>  +                       &priv->bands[IEEE80211_BAND_2GHZ];
>  +       if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
>  +               priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
>  +                       &priv->bands[IEEE80211_BAND_5GHZ];
>
>         set_bit(STATUS_GEO_CONFIGURED, &priv->status);
>
>  diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  index 44cfd02..9ae3d29 100644
>  --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  @@ -5001,8 +5001,12 @@ int iwl4965_init_geos(struct iwl_priv *priv)
>                priv->bands[IEEE80211_BAND_2GHZ].n_channels,
>                priv->bands[IEEE80211_BAND_5GHZ].n_channels);
>
>  -       priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->bands[IEEE80211_BAND_2GHZ];
>  -       priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->bands[IEEE80211_BAND_5GHZ];
>  +       if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
>  +               priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
>  +                       &priv->bands[IEEE80211_BAND_2GHZ];
>  +       if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
>  +               priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
>  +                       &priv->bands[IEEE80211_BAND_5GHZ];
>
>         set_bit(STATUS_GEO_CONFIGURED, &priv->status);
>

As there already exists condition testing this I would prefer
something like this

printk(KERN_INFO DRV_NAME
	       ": Tunable channels: %d 802.11bg, %d 802.11a channels\n",
	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);

priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->bands[IEEE80211_BAND_2GHZ];



if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
	     priv->cfg->sku & IWL_SKU_A) {
		printk(KERN_INFO DRV_NAME
		       ": Incorrectly detected BG card as ABG.  Please send "
		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
		       priv->pci_dev->device, priv->pci_dev->subsystem_device);
		priv->cfg->sku &= ~IWL_SKU_A;
                priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
}
else
   priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
&priv->bands[IEEE80211_BAND_5GHZ];
>  1.5.3.3
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
