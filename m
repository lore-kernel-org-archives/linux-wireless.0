Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:52949 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932140AbcIRHo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 03:44:56 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH v2 1/9] cfg80211: add start / stop NAN commands
Date: Sun, 18 Sep 2016 07:44:50 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED57286E44@hasmsx108.ger.corp.intel.com> (sfid-20160918_094500_793994_8F824947)
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-2-luca@coelho.fi>
 <6bfd6007-8650-3c75-2e90-c2c94202e2b9@broadcom.com>
In-Reply-To: <6bfd6007-8650-3c75-2e90-c2c94202e2b9@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Friday, September 16, 2016 13:59
> To: Luca Coelho <luca@coelho.fi>; johannes@sipsolutions.net
> Cc: linux-wireless@vger.kernel.org; Beker, Ayala <ayala.beker@intel.com>;
> Otcheretianski, Andrei <andrei.otcheretianski@intel.com>; Grumbach,
> Emmanuel <emmanuel.grumbach@intel.com>; Coelho, Luciano
> <luciano.coelho@intel.com>
> Subject: Re: [PATCH v2 1/9] cfg80211: add start / stop NAN commands
> 
> On 16-9-2016 10:33, Luca Coelho wrote:
> > From: Ayala Beker <ayala.beker@intel.com>
> >
> > This allows user space to start/stop NAN interface.
> > A NAN interface is like P2P device in a few aspects: it doesn't have a
> > netdev associated to it.
> > Add the new interface type and prevent operations that can't be
> > executed on NAN interface like scan.
> >
> > Define several attributes that may be configured by user space when
> > starting NAN functionality (master preference and dual band operation)
> >
> > Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> >  include/net/cfg80211.h       | 21 +++++++++-
> >  include/uapi/linux/nl80211.h | 52 +++++++++++++++++++++++++
> >  net/mac80211/cfg.c           |  2 +
> >  net/mac80211/chan.c          |  3 ++
> >  net/mac80211/iface.c         |  4 ++
> >  net/mac80211/offchannel.c    |  1 +
> >  net/mac80211/rx.c            |  3 ++
> >  net/mac80211/util.c          |  1 +
> >  net/wireless/chan.c          |  2 +
> >  net/wireless/core.c          | 34 ++++++++++++++++
> >  net/wireless/core.h          |  3 ++
> >  net/wireless/mlme.c          |  1 +
> >  net/wireless/nl80211.c       | 93
> ++++++++++++++++++++++++++++++++++++++++++--
> >  net/wireless/rdev-ops.h      | 20 ++++++++++
> >  net/wireless/trace.h         | 27 +++++++++++++
> >  net/wireless/util.c          |  6 ++-
> >  16 files changed, 267 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h index
> > d5e7f69..ca64d69 100644
> > --- a/include/net/cfg80211.h
> > +++ b/include/net/cfg80211.h
> > @@ -2293,6 +2293,19 @@ struct cfg80211_qos_map {  };
> 
> [...]
> 
> > +/**
> > + * enum nl80211_nan_dual_band_conf - NAN dual band configuration
> > + *
> > + * Defines the NAN dual band mode of operation
> 
> Does it make sense to have such a notion of bands in use. And what does
> 5.2GHz mean. Is this a subband within 5G channels? Probably I should read
> the NAN spec to understand what is meant here. I would consider 5.2G as
> lower 5G, ie. discovery on channel 44 but not sure if that is meant here.
>

The NAN spec defines single and dual band modes of operation. The channels are fixed for each band.
On 2.4Ghz is channel 6 and 5GHz is either 44 or 149. Regarding 5.2 - it's just a typo. It should be 5G - no deeper meaning.
 
> > + * @NL80211_NAN_BAND_DEFAULT: device default mode
> > + * @NL80211_NAN_BAND_SINGLE: 2.4GHz only mode
> > + * @NL80211_NAN_BAND_DUAL: 2.4GHz and 5.2GHz mode
> > +  */
> > +enum nl80211_nan_dual_band_conf {
> > +	NL80211_NAN_BAND_DEFAULT,
> > +	NL80211_NAN_BAND_SINGLE,
> > +	NL80211_NAN_BAND_DUAL,
> > +
> > +	/* keep last */
> > +	__NL80211_NAN_BAND_AFTER_LAST,
> > +	NL80211_NAN_BAND_MAX =
> > +	__NL80211_NAN_BAND_AFTER_LAST - 1,
> > +};
> > +
> >  #endif /* __LINUX_NL80211_H */
> > diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c index
> > e29ff57..a74027f 100644
> > --- a/net/mac80211/cfg.c
> > +++ b/net/mac80211/cfg.c
> > @@ -257,6 +257,7 @@ static int ieee80211_add_key(struct wiphy *wiphy,
> struct net_device *dev,
> >  	case NL80211_IFTYPE_WDS:
> >  	case NL80211_IFTYPE_MONITOR:
> >  	case NL80211_IFTYPE_P2P_DEVICE:
> > +	case NL80211_IFTYPE_NAN:
> >  	case NL80211_IFTYPE_UNSPECIFIED:
> >  	case NUM_NL80211_IFTYPES:
> 
> Huh? What is this doing here? Not yours but weird still.
> 
> >  	case NL80211_IFTYPE_P2P_CLIENT:
> > @@ -2036,6 +2037,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
> >  		     !(req->flags & NL80211_SCAN_FLAG_AP)))
> >  			return -EOPNOTSUPP;
> >  		break;
> > +	case NL80211_IFTYPE_NAN:
> >  	default:
> >  		return -EOPNOTSUPP;
> >  	}
> > diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c index
> > 74142d0..acb50f8 100644
> > --- a/net/mac80211/chan.c
> > +++ b/net/mac80211/chan.c
> > @@ -274,6 +274,7 @@ ieee80211_get_chanctx_max_required_bw(struct
> ieee80211_local *local,
> >  				    ieee80211_get_max_required_bw(sdata));
> >  			break;
> >  		case NL80211_IFTYPE_P2P_DEVICE:
> > +		case NL80211_IFTYPE_NAN:
> >  			continue;
> >  		case NL80211_IFTYPE_ADHOC:
> >  		case NL80211_IFTYPE_WDS:
> > @@ -718,6 +719,7 @@ void ieee80211_recalc_smps_chanctx(struct
> > ieee80211_local *local,
> >
> >  		switch (sdata->vif.type) {
> >  		case NL80211_IFTYPE_P2P_DEVICE:
> > +		case NL80211_IFTYPE_NAN:
> >  			continue;
> >  		case NL80211_IFTYPE_STATION:
> >  			if (!sdata->u.mgd.associated)
> > @@ -981,6 +983,7 @@
> ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data
> *sdata)
> >  	case NL80211_IFTYPE_P2P_GO:
> >  	case NL80211_IFTYPE_P2P_DEVICE:
> >  	case NUM_NL80211_IFTYPES:
> 
> I think NUM_NL80211_IFTYPES should not be in the switch. If it must I would
> leave it as last one here.

Agree that it should go last

> 
> > +	case NL80211_IFTYPE_NAN:
> >  		WARN_ON(1);
> >  		break;
> >  	}
> 
> Regards,
> Arend
