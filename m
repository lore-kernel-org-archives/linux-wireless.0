Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4754 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYCYVgf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 17:36:35 -0400
Date: Tue, 25 Mar 2008 17:24:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Subject: Re: [PATCH] iwlwifi: do not register bands with no supported
	channels
Message-ID: <20080325212407.GB20488@tuxdriver.com> (sfid-20080325_213638_320067_E91CA364)
References: <1206475120-10188-1-git-send-email-linville@tuxdriver.com> <1ba2fa240803251331y60f3cf58x8f08bd4411b1369d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240803251331y60f3cf58x8f08bd4411b1369d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 25, 2008 at 10:31:27PM +0200, Tomas Winkler wrote:
> On Tue, Mar 25, 2008 at 9:58 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >  ---
> >  Otherwise, b/g-only devices fail in wiphy_register.  Tested in Fedora
> >  kernels for the last week or so...
> >
> >   drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 ++++++--
> >   drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++++--
> >   2 files changed, 12 insertions(+), 4 deletions(-)

> >  diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> >  index 44cfd02..9ae3d29 100644
> >  --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> >  +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> >  @@ -5001,8 +5001,12 @@ int iwl4965_init_geos(struct iwl_priv *priv)
> >                priv->bands[IEEE80211_BAND_2GHZ].n_channels,
> >                priv->bands[IEEE80211_BAND_5GHZ].n_channels);
> >
> >  -       priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->bands[IEEE80211_BAND_2GHZ];
> >  -       priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->bands[IEEE80211_BAND_5GHZ];
> >  +       if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
> >  +               priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
> >  +                       &priv->bands[IEEE80211_BAND_2GHZ];
> >  +       if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
> >  +               priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
> >  +                       &priv->bands[IEEE80211_BAND_5GHZ];
> >
> >         set_bit(STATUS_GEO_CONFIGURED, &priv->status);
> >
> 
> As there already exists condition testing this I would prefer
> something like this

I don't think it is the same -- yours is checking IWL_SKU_A.

> if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
> 	     priv->cfg->sku & IWL_SKU_A) {
> 		printk(KERN_INFO DRV_NAME
> 		       ": Incorrectly detected BG card as ABG.  Please send "
> 		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
> 		       priv->pci_dev->device, priv->pci_dev->subsystem_device);
> 		priv->cfg->sku &= ~IWL_SKU_A;
>                 priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
> }

A clause just like this exists a few lines above, yet it does not
fire for the device that prompted this patch:

	https://bugzilla.redhat.com/attachment.cgi?id=298613

> else
>    priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
> &priv->bands[IEEE80211_BAND_5GHZ];

I don't think your version will resolve the issue.  Am I missing
something?

John
-- 
John W. Linville
linville@tuxdriver.com
