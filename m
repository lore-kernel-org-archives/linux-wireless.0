Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1FFI7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 04:59:50 -0400
Date: Mon, 6 Jun 2011 10:58:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH v2] iwlagn: use cts-to-self protection on 5000 adapters
 series
Message-ID: <20110606085851.GA2391@redhat.com> (sfid-20110606_105954_137248_1789B534)
References: <20110526151422.GA2382@redhat.com>
 <1306421442.14995.325.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306421442.14995.325.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 07:50:42AM -0700, Guy, Wey-Yi wrote:
> On Thu, 2011-05-26 at 08:14 -0700, Stanislaw Gruszka wrote:
> > This patch fixes 802.11n stability and performance regression we have
> > since 2.6.35. It boost performance on my 5GHz N-only network from about
> > 5MB/s to 8MB/s. Similar percentage boost can be observed on 2.4 GHz.
> > 
> > These are test results of 5x downloading of approximately 700MB iso
> > image:
> > 
> > vanilla: 5.27 5.22 4.94 4.47 5.31 ; avr 5.0420 std 0.35110
> > patched: 8.07 7.95 8.06 7.99 7.96 ; avr 8.0060 std 0.055946
> > 
> > This was achieved with NetworkManager configured to do not perform
> > periodical scans, by configuring constant BSSID. With periodical scans,
> > after some time, performance downgrade to unpatched driver level, like
> > in example below:
> > 
> > patched: 7.40 7.61 4.28 4.37 4.80 avr 5.6920 std 1.6683
> > 
> > However patch still make better here, since similar test on unpatched
> > driver make link disconnects with below messages after some time:
> > 
> > wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
> > wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
> > wlan1: authenticate with 00:23:69:35:d1:3f (try 3)
> > wlan1: authentication with 00:23:69:35:d1:3f timed out
> > 
> > On 2.6.35 kernel patch helps against connection hangs with messages:
> > 
> > iwlagn 0000:20:00.0: queue 10 stuck 3 time. Fw reload.
> > iwlagn 0000:20:00.0: On demand firmware reload
> > iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting
> > 
> > Cc: stable@kernel.org # 2.6.35+
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

John, can you apply that patch and push upstream? Or should I
repost? I want backport it to Fedora 2.6.35 as it fixes random
11n connection hangs there (common F-14 bug).

> > ---
> > v1 -> v2: s/unpached/unpatched/
> > 
> >  drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 -
> >  drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   12 ++----------
> >  drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    8 ++++++++
> >  3 files changed, 10 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
> > index a70b8cf..f96eb5b 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-5000.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
> > @@ -425,7 +425,6 @@ static struct iwl_base_params iwl5000_base_params = {
> >  };
> >  static struct iwl_ht_params iwl5000_ht_params = {
> >  	.ht_greenfield_support = true,
> > -	.use_rts_for_aggregation = true, /* use rts/cts protection */
> >  };
> >  
> >  #define IWL_DEVICE_5000						\
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
> > index b12c72d..23fa93d 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
> > @@ -163,17 +163,9 @@ static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
> >  				     __le16 fc, __le32 *tx_flags)
> >  {
> >  	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS ||
> > -	    info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
> > +	    info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT ||
> > +	    info->flags & IEEE80211_TX_CTL_AMPDU)
> >  		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
> > -		return;
> > -	}
> > -
> > -	if (priv->cfg->ht_params &&
> > -	    priv->cfg->ht_params->use_rts_for_aggregation &&
> > -	    info->flags & IEEE80211_TX_CTL_AMPDU) {
> > -		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
> > -		return;
> > -	}
> >  }
> >  
> >  /* Calc max signal level (dBm) among 3 possible receivers */
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
> > index a95ad84..0a1941d 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
> > @@ -325,6 +325,14 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
> >  			return 0;
> >  	}
> >  
> > +	/*
> > +	 * force CTS-to-self frames protection if RTS-CTS is not preferred
> > +	 * one aggregation protection method
> > +	 */
> > +	if (!(priv->cfg->ht_params &&
> > +	      priv->cfg->ht_params->use_rts_for_aggregation))
> > +		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
> > +
> >  	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
> >  	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
> >  		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
