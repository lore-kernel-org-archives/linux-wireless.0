Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53220 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754642AbcIULg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 07:36:27 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH v3 0/9] Add support for Neighbor Awareness Networking
Date: Wed, 21 Sep 2016 11:36:22 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED5728D971@hasmsx108.ger.corp.intel.com> (sfid-20160921_133631_228579_3C190727)
References: <20160920143121.28247-1-luca@coelho.fi>
 <1fea85b0-02f0-964d-ca3d-99453f6de421@broadcom.com>
In-Reply-To: <1fea85b0-02f0-964d-ca3d-99453f6de421@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Wednesday, September 21, 2016 12:40
> To: Luca Coelho <luca@coelho.fi>; johannes@sipsolutions.net
> Cc: linux-wireless@vger.kernel.org; Beker, Ayala <ayala.beker@intel.com>;
> Otcheretianski, Andrei <andrei.otcheretianski@intel.com>; Coelho, Luciano
> <luciano.coelho@intel.com>
> Subject: Re: [PATCH v3 0/9] Add support for Neighbor Awareness
> Networking
> 
> 
> 
> On 20-9-2016 16:31, Luca Coelho wrote:
> > From: Luca Coelho <luciano.coelho@intel.com>
> >
> > Hi,
> >
> > Now v3 of the NAN patchset.  Ayala has taken care of the kbuild bot
> > compilation errors and of all Arend's comments, except for the one
> > about adding a helper function instead checking for P2P_DEVICE and NAN
> > for non-netdev interfaces.
> >
> > Comments are welcome, as always.
> 
> This series exports three functions to be used by drivers:
> 
> void cfg80211_free_nan_func(struct cfg80211_nan_func *f); void
> cfg80211_nan_match(struct wireless_dev *wdev,
> 			struct cfg80211_nan_match_params *match, gfp_t
> gfp); void cfg80211_nan_func_terminated(struct wireless_dev *wdev,
> 				  u8 inst_id,
> 				  enum nl80211_nan_func_term_reason
> reason,
> 				  u64 cookie, gfp_t gfp);
> 
> Some more descriptive text about the use of these functions would be
> appropriate I think. For example looking at the patch series it seems the
> responsibility to call cfg80211_free_nan_func() is in the driver although
> allocation is done by cfg80211.

Regarding the cfg80211_free_nan_func() it is documented in patch "[PATCH v3 3/9] cfg80211: add add_nan_func / del_nan_func"
Here:
 * @add_nan_func: Add a NAN function. Returns negative value on failure.
 *     On success @nan_func ownership is transferred to the driver and
 *     it may access it outside of the scope of this function. The driver
 *     should free the @nan_func when no longer needed by calling
 *     cfg80211_free_nan_func().
 *     On success the driver should assign an instance_id in the
 *     provided @nan_func.

All the others are pretty much straight forward. Match and termination events are defined in NAN spec - so it should be easy to know when to call these functions.

>  Actually, I do not see mac80211 calling it so are
> we leaking there? I would expect it being called in
> .del_nan_func() callback and/or .stop_nan().

It is. Look at "[PATCH v3 8/9] mac80211: Implement add_nan_func and rm_nan_func".
It is called in stop_nan() and nan_func_terminated() callback.
The nan function can't be freed directly in del_nan_func() - otherwise it would be racy with match/termination notifications.

> Rather than exporting
> cfg80211_free_nan_func() I would prefer calling
> cfg80211_nan_func_terminated() and have cfg80211 take care of freeing
> nan_func resources.

As I already answered, there are some situations when the wdev isn't available and mac80211 can't call cfg80211_nan_func_terminated() - for example nan interface is being stopped (at least it's true for mac80211).
Also I think that the driver should be able to free the nan function without being forced to send notification to the user space and the other way around.

> 
> Regards,
> Arend
> 
> > Cheers,
> > Luca.
> >
> >
> > Ayala Beker (9):
> >   cfg80211: add start / stop NAN commands
> >   mac80211: add boilerplate code for start / stop NAN
> >   cfg80211: add add_nan_func / del_nan_func
> >   cfg80211: allow the user space to change current NAN configuration
> >   cfg80211: provide a function to report a match for NAN
> >   cfg80211: Provide an API to report NAN function termination
> >   mac80211: implement nan_change_conf
> >   mac80211: Implement add_nan_func and rm_nan_func
> >   mac80211: Add API to report NAN function match
> >
> >  include/net/cfg80211.h       | 184 ++++++++++++-
> >  include/net/mac80211.h       |  65 +++++
> >  include/uapi/linux/nl80211.h | 253 +++++++++++++++++
> >  net/mac80211/cfg.c           | 208 ++++++++++++++
> >  net/mac80211/chan.c          |   6 +
> >  net/mac80211/driver-ops.h    |  80 ++++++
> >  net/mac80211/ieee80211_i.h   |  17 ++
> >  net/mac80211/iface.c         |  28 +-
> >  net/mac80211/main.c          |   8 +
> >  net/mac80211/offchannel.c    |   4 +-
> >  net/mac80211/rx.c            |   3 +
> >  net/mac80211/trace.h         | 133 +++++++++
> >  net/mac80211/util.c          |  50 +++-
> >  net/wireless/chan.c          |   2 +
> >  net/wireless/core.c          |  35 +++
> >  net/wireless/core.h          |   3 +
> >  net/wireless/mlme.c          |   1 +
> >  net/wireless/nl80211.c       | 642
> ++++++++++++++++++++++++++++++++++++++++++-
> >  net/wireless/rdev-ops.h      |  58 ++++
> >  net/wireless/trace.h         |  90 ++++++
> >  net/wireless/util.c          |  28 +-
> >  21 files changed, 1888 insertions(+), 10 deletions(-)
> >
