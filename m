Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26163 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2DGMyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2012 08:54:37 -0400
Date: Sat, 7 Apr 2012 18:25:13 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Configure htcap in fw based on the channel
 type in AP mode
Message-ID: <20120407125511.GA19815@vasanth-laptop> (sfid-20120407_145441_636194_DB7477CF)
References: <1333721235-16025-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1333721235-16025-2-git-send-email-vthiagar@qca.qualcomm.com>
 <20120406174157.GA10355@pista>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120406174157.GA10355@pista>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >  
> > +static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
> > +			      struct ieee80211_channel *chan,
> > +			      enum nl80211_channel_type channel_type)
> > +{
> > +	struct ath6kl_vif *vif;
> > +
> > +	/*
> > +	 * 'dev' could be NULL if a channel change is required for the hardware
> > +	 * device itself, instead of a particular VIF.
> > +	 *
> > +	 * FIXME: To be handled properly when monitor mode is supported.
> > +	 */
> > +	if (!dev)
> > +		return -EBUSY;
> > +
> > +	vif = netdev_priv(dev);
> > +
> > +	if (!ath6kl_cfg80211_ready(vif))
> > +		return -EIO;
> > +
> > +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: center_freq=%u hw_value=%u\n",
> > +		   __func__, chan->center_freq, chan->hw_value);
> > +	vif->next_chan = chan->center_freq;
> > +	vif->next_ch_type = channel_type;
> > +	vif->next_ch_band = chan->band;
> 
> Why this indirection? Can't we just call ath6kl_set_htcap() here and
> thereby handle the STA case as well?

Station mode does not use set_channel for normal operation in ath6kl. Only when
a channel is set from user space (like iw) this will be called and as such it has
no use for station mode as of now. connect() is the right place to override fw ht
configuration in station mode.

Vasanth
