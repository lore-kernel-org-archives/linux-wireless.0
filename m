Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52628 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbZJaRqs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 13:46:48 -0400
Subject: Re: [PATCH 14/15] iwlwifi: add SM PS support for 6x50 series
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1256968411.3555.77.camel@johannes.local>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
	 <1256938578-9638-15-git-send-email-reinette.chatre@intel.com>
	 <1256968411.3555.77.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 31 Oct 2009 10:44:18 -0700
Message-Id: <1257011058.8387.14.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-30 at 22:53 -0700, Johannes Berg wrote:
> Hi,
> 
> > @@ -3012,6 +3012,10 @@ static int iwl_init_drv(struct iwl_priv *priv)
> >  	priv->band = IEEE80211_BAND_2GHZ;
> >  
> >  	priv->iw_mode = NL80211_IFTYPE_STATION;
> > +	if (priv->cfg->support_sm_ps)
> > +		priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DYNAMIC;
> > +	else
> > +		priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DISABLED;
> 
> Why bother with current_ht_config.sm_ps when ...

This is for keep the ht configuration in single place. 

> 
> >  	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
> > -	ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
> > -			     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
> > +	if (priv->cfg->support_sm_ps)
> > +		ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
> > +				     (WLAN_HT_CAP_SM_PS_DYNAMIC << 2));
> > +	else
> > +		ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
> > +				     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
> 
> here we always and unconditionally advertise dynamic SM-PS mode?

I am confuse, it is based on "priv->cfg->support_sm_ps", so it is not
always dynamic SM-PS mode.
  
>  
> > +	if (priv->cfg->support_sm_ps) {
> > +		/* # Rx chains when idling and maybe trying to save power */
> > +		switch (priv->current_ht_config.sm_ps) {
> > +		case WLAN_HT_CAP_SM_PS_STATIC:
> > +		case WLAN_HT_CAP_SM_PS_DYNAMIC:
> > +			idle_cnt = (is_cam) ? IWL_NUM_IDLE_CHAINS_DUAL :
> > +				IWL_NUM_IDLE_CHAINS_SINGLE;
> > +			break;
> > +		case WLAN_HT_CAP_SM_PS_DISABLED:
> > +			idle_cnt = (is_cam) ? active_cnt :
> > +				IWL_NUM_IDLE_CHAINS_SINGLE;
> > +			break;
> > +		case WLAN_HT_CAP_SM_PS_INVALID:
> > +		default:
> > +			IWL_ERR(priv, "invalid sm_ps mode %d\n",
> > +				priv->current_ht_config.sm_ps);
> > +			WARN_ON(1);
> > +			break;
> > +		}
> > +	}
> 
> This _should_ always hit the dynamic case since we've always advertised
> that, were it not for a bug below. And even when powersave is turned off
> the AP will have to do CTS/RTS handshake so we do not gain anything by
> turning on all chains in that case.
> 
We only hit the dynamic sm-ps mode if "priv->cfg->support_sm_ps == ture"
case. correct?

> I think the whole ht_config.sm_ps should be removed, and here we should
> always and unconditionally use _SINGLE as that matches what we've
> advertised to the AP via the HT capabilities.
> 
> >  /* up to 4 chains */
> > @@ -2258,6 +2280,12 @@ static void iwl_ht_conf(struct iwl_priv *priv,
> >  					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
> >  			maxstreams += 1;
> >  
> > +			ht_conf->sm_ps =
> > +				(u8)((ht_cap->cap & IEEE80211_HT_CAP_SM_PS)
> > +				>> 2);
> > +			IWL_DEBUG_MAC80211(priv, "sm_ps: 0x%x\n",
> > +				ht_conf->sm_ps);
> > +
> 
> This is wrong; we cannot use the peer's SM_PS setting for our own SM_PS
> setting, we've advertised dynamic SM PS so we better stick with it. The
> peer's setting has no value for us, it means whether the peer will turn
> off _its_ chains or not.

I agree should not modify the SM_PS setting based on AP

I will submit another patch to remove using AP setting.

> 
> johannes

