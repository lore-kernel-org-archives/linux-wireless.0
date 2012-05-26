Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43866 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2EZRSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 13:18:04 -0400
Date: Sat, 26 May 2012 12:18:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] brcm80211: smac: inform mac80211 of the X2
 regulatory domain
Message-ID: <20120526171800.GC11759@ubuntu-mba> (sfid-20120526_191807_746638_E467E31F)
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-5-git-send-email-seth.forshee@canonical.com>
 <4FC008AB.4080107@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC008AB.4080107@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 26, 2012 at 12:33:15AM +0200, Arend van Spriel wrote:
> > +#define BRCM_2GHZ_2412_2462	REG_RULE(2412-10, 2462+10, 40, 0, 19, 0)
> > +#define BRCM_2GHZ_2467_2472	REG_RULE(2467-10, 2472+10, 20, 0, 19, \
> > +					 NL80211_RRF_PASSIVE_SCAN | \
> > +					 NL80211_RRF_NO_IBSS)
> > +#define BRCM_2GHZ_2484		REG_RULE(2484-10, 2484+10, 40, 0, 19, \
> > +					 NL80211_RRF_PASSIVE_SCAN | \
> > +					 NL80211_RRF_NO_OFDM)
> > +
> 
> If channels 12 and 13 are 20MHz only, shouldn't channel 14 above
> (2484MHz) be 20MHz as well?

Heh, good point. I'm trying to remember why I made 12 and 13 20MHz only
though; maybe that's a mistake. Is there any reason why they couldn't
all be 40MHz?

> > +static const struct ieee80211_regdomain brcms_regdom_x2 = {
> > +	.n_reg_rules = 7,
> > +	.alpha2 = "X2",
> > +	.reg_rules = {
> > +		BRCM_2GHZ_2412_2462,
> > +		BRCM_2GHZ_2467_2472,
> > +		BRCM_2GHZ_2484,
> 
> The X2 domain did not support channel 14 so this is cheating ;-)

Yep, my mistake. I'll remove it.

> > +	/* Worldwide Row 2, must always be at index 0 */
> 
> Row is abbreviation for Rest of World, hence RoW. Come to think of it,
> this actually makes the term Worldwide a bit redundant.

I'll fix it.

> > +bool brcms_is_radar_freq(u16 center_freq)
> > +{
> > +	return center_freq >= 5260 && center_freq <= 5700;
> 
> You can avoid this code if you/we do not add the channels to
> wiphy->bands[IEEE80211_BAND_5GHZ]. The driver does not support DFS so we
> better stay away from these channels, which was your original issue to
> start this work if I recall correct :-( Sorry.

This is what originally got me looking at the brcmsmac regulatory
support, so it would be disappointing if at the end these channels still
aren't usable.

My understanding of DFS is pretty rudamentary. Could you explain what
support is needed? I do see that mac80211 doesn't really support power
measurement requests, but if we can at least stop transmission when
radar is present couldn't we still operate on the channels?

Luis, any insight you can offer on the subject would be appreciated.

> > +			} else {
> > +				if (ch->beacon_found)
> 
> can save one indent when using else if () immediately here.

I'll change this.

> > diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> > index aa15558..f26e93c 100644
> > --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> > +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> > @@ -1059,6 +1059,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
> >  		goto fail;
> >  	}
> >  
> > +	brcms_c_regd_init(wl->wlc);
> > +
> 
> can this be moved in brcms_c_channel_mgr_attach()?

Not without rearranging the initialization, as brcms_c_regd_init() must
be called after wiphy->bands has been set up. I don't see any reason why
setting up the bands couldn't be moved to before channel_mgr_attach()
though, and in that case regd_init() could be moved into
channel_mgr_attach().

