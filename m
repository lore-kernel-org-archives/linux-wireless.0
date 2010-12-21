Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab0LUMFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 07:05:05 -0500
Date: Tue, 21 Dec 2010 13:05:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: fix scan tx antenna setting on 5Ghz band
Message-ID: <20101221120511.GA2287@redhat.com>
References: <1292864713-2756-1-git-send-email-sgruszka@redhat.com>
 <1292868816.22230.45.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1292868816.22230.45.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Mon, Dec 20, 2010 at 10:13:36AM -0800, Guy, Wey-Yi wrote:
> On Mon, 2010-12-20 at 09:05 -0800, Stanislaw Gruszka wrote:
> > Looks that we do not set correctly antennas when scanning
> > on 5Ghz band and when bluetooth is enabled, because
> > priv->cfg->scan_tx_antennas[band] is only defined for
> > IEEE80211_BAND_2GHZ. This fix choose first valid antenna.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> > index 4bc82fc..099039c 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> > @@ -1499,8 +1499,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
> >  	    priv->cfg->bt_params->advanced_bt_coexist &&
> >  	    priv->bt_full_concurrent) {
> >  		/* operated as 1x1 in full concurrency mode */
> > -		scan_tx_antennas = first_antenna(
> > -			priv->cfg->scan_tx_antennas[band]);
> > +		scan_tx_antennas = first_antenna(scan_tx_antennas);
> 
> If its is 2.4, we need to use the correct tx antenna, I think we can
> remove this block of code all together since check already done above.
> 
>   if (priv->cfg->scan_tx_antennas[band])
>   	scan_tx_antennas = priv->cfg->scan_tx_antennas[band];

Is correct to use all antennas on 5GHz when blutooth is enabled?
For me, more logical would be limiting to one antenna no matter of band,
since antennas are used anyway, only frequencies differ.

For rx_ant, we do not check the band, only limit to first one
when bluetooth is used.

Stanislaw
