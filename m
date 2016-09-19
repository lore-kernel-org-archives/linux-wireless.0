Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:24483 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757632AbcISH1D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:27:03 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH v2 1/9] cfg80211: add start / stop NAN commands
Date: Mon, 19 Sep 2016 07:25:52 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED572894B1@hasmsx108.ger.corp.intel.com> (sfid-20160919_092708_229374_22EF4ED7)
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-2-luca@coelho.fi>
 <6bfd6007-8650-3c75-2e90-c2c94202e2b9@broadcom.com>
 <B2CD83211F5FDD478D7EFFF030D107ED57286E44@hasmsx108.ger.corp.intel.com>
 <0480de5c-4137-2991-e829-68e6af6e1935@broadcom.com>
In-Reply-To: <0480de5c-4137-2991-e829-68e6af6e1935@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Sunday, September 18, 2016 21:54
> To: Otcheretianski, Andrei <andrei.otcheretianski@intel.com>; Luca Coelho
> <luca@coelho.fi>; johannes@sipsolutions.net
> Cc: linux-wireless@vger.kernel.org; Beker, Ayala <ayala.beker@intel.com>;
> Grumbach, Emmanuel <emmanuel.grumbach@intel.com>; Coelho, Luciano
> <luciano.coelho@intel.com>
> Subject: Re: [PATCH v2 1/9] cfg80211: add start / stop NAN commands
> 
> On 18-9-2016 9:44, Otcheretianski, Andrei wrote:
> >> -----Original Message-----
> >> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> >> Sent: Friday, September 16, 2016 13:59
> >> To: Luca Coelho <luca@coelho.fi>; johannes@sipsolutions.net
> >> Cc: linux-wireless@vger.kernel.org; Beker, Ayala
> >> <ayala.beker@intel.com>; Otcheretianski, Andrei
> >> <andrei.otcheretianski@intel.com>; Grumbach, Emmanuel
> >> <emmanuel.grumbach@intel.com>; Coelho, Luciano
> >> <luciano.coelho@intel.com>
> >> Subject: Re: [PATCH v2 1/9] cfg80211: add start / stop NAN commands
> >>
> >> On 16-9-2016 10:33, Luca Coelho wrote:
> >>> From: Ayala Beker <ayala.beker@intel.com>
> >>>
> >>> This allows user space to start/stop NAN interface.
> >>> A NAN interface is like P2P device in a few aspects: it doesn't have
> >>> a netdev associated to it.
> >>> Add the new interface type and prevent operations that can't be
> >>> executed on NAN interface like scan.
> >>>
> >>> Define several attributes that may be configured by user space when
> >>> starting NAN functionality (master preference and dual band
> >>> operation)
> >>>
> >>> Signed-off-by: Andrei Otcheretianski
> >>> <andrei.otcheretianski@intel.com>
> >>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> >>> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> >>> ---
> >>>  include/net/cfg80211.h       | 21 +++++++++-
> >>>  include/uapi/linux/nl80211.h | 52 +++++++++++++++++++++++++
> >>>  net/mac80211/cfg.c           |  2 +
> >>>  net/mac80211/chan.c          |  3 ++
> >>>  net/mac80211/iface.c         |  4 ++
> >>>  net/mac80211/offchannel.c    |  1 +
> >>>  net/mac80211/rx.c            |  3 ++
> >>>  net/mac80211/util.c          |  1 +
> >>>  net/wireless/chan.c          |  2 +
> >>>  net/wireless/core.c          | 34 ++++++++++++++++
> >>>  net/wireless/core.h          |  3 ++
> >>>  net/wireless/mlme.c          |  1 +
> >>>  net/wireless/nl80211.c       | 93
> >> ++++++++++++++++++++++++++++++++++++++++++--
> >>>  net/wireless/rdev-ops.h      | 20 ++++++++++
> >>>  net/wireless/trace.h         | 27 +++++++++++++
> >>>  net/wireless/util.c          |  6 ++-
> >>>  16 files changed, 267 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h index
> >>> d5e7f69..ca64d69 100644
> >>> --- a/include/net/cfg80211.h
> >>> +++ b/include/net/cfg80211.h
> >>> @@ -2293,6 +2293,19 @@ struct cfg80211_qos_map {  };
> >>
> >> [...]
> >>
> >>> +/**
> >>> + * enum nl80211_nan_dual_band_conf - NAN dual band configuration
> >>> + *
> >>> + * Defines the NAN dual band mode of operation
> >>
> >> Does it make sense to have such a notion of bands in use. And what
> >> does 5.2GHz mean. Is this a subband within 5G channels? Probably I
> >> should read the NAN spec to understand what is meant here. I would
> >> consider 5.2G as lower 5G, ie. discovery on channel 44 but not sure if that
> is meant here.
> >>
> >
> > The NAN spec defines single and dual band modes of operation. The
> channels are fixed for each band.
> > On 2.4Ghz is channel 6 and 5GHz is either 44 or 149. Regarding 5.2 - it's just a
> typo. It should be 5G - no deeper meaning.
> 
> The thing is that it seems likely other bands will be added so that would kinda
> obsolete this whole enum. So I would propose to have another way to
> configure the bands to use. This enum is not really extensible though it may
> reflect the current state of the spec, which is still in draft if I am not mistaken.
> 

I guess you are talking about additional bands that are mentioned in NAN2 spec (like sub-1Ghz etc..).
I'm not sure that these bands will be used for sync or NAN2 specific operations only (like data path or ranging).
Nevertheless, you're right, I guess it doesn't harm to make it a bitmask of supported bands.

> Regards,
> Arend
