Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2EZRSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 13:18:20 -0400
Date: Sat, 26 May 2012 12:18:17 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 5/8] brcm80211: smac: enable/disable radio on
 regulatory updates
Message-ID: <20120526171817.GD11759@ubuntu-mba> (sfid-20120526_191822_928876_AACDEF2C)
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-6-git-send-email-seth.forshee@canonical.com>
 <4FC008BB.1020606@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC008BB.1020606@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 26, 2012 at 12:33:31AM +0200, Arend van Spriel wrote:
> > @@ -1240,12 +1199,37 @@ static int brcms_reg_notifier(struct wiphy *wiphy,
> >  	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
> >  	struct brcms_info *wl = hw->priv;
> >  	struct brcms_c_info *wlc = wl->wlc;
> > +	struct ieee80211_supported_band *sband;
> > +	struct ieee80211_channel *ch;
> > +	int band, i, n_channels = 0;
> >  
> >  	brcms_reg_apply_radar_flags(wiphy);
> >  
> >  	if (request && request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
> >  		brcms_reg_apply_beaconing_flags(wiphy, request->initiator);
> >  
> > +	/* Disable radio if all channels disallowed by regulatory */
> 
> I think we need to validate the channels against our phy as well. See
> brcms_c_channels_init().

I disable channels not supported by the phy in brcms_c_regd_init(), so
it's not necessary to check it again here.

> > +	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> > +		sband = wiphy->bands[band];
> > +		if (!sband)
> > +			continue;
> > +
> > +		for (i = 0; i < sband->n_channels; i++) {
> > +			ch = &sband->channels[i];
> > +
> > +			if (!(ch->flags & IEEE80211_CHAN_DISABLED))
> > +				n_channels++;
> 
> could break here when a valid channel is found.

Ack, I'll do that.

