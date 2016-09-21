Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35000 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbcIUJkk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 05:40:40 -0400
Received: by mail-qk0-f177.google.com with SMTP id t7so39967200qkh.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2016 02:40:39 -0700 (PDT)
Subject: Re: [PATCH v3 0/9] Add support for Neighbor Awareness Networking
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20160920143121.28247-1-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, ayala.beker@intel.com,
        andrei.otcheretianski@intel.com,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1fea85b0-02f0-964d-ca3d-99453f6de421@broadcom.com> (sfid-20160921_114048_569387_EFBCD98F)
Date: Wed, 21 Sep 2016 11:40:28 +0200
MIME-Version: 1.0
In-Reply-To: <20160920143121.28247-1-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 20-9-2016 16:31, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Hi,
> 
> Now v3 of the NAN patchset.  Ayala has taken care of the kbuild bot
> compilation errors and of all Arend's comments, except for the one
> about adding a helper function instead checking for P2P_DEVICE and NAN
> for non-netdev interfaces.
> 
> Comments are welcome, as always.

This series exports three functions to be used by drivers:

void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
void cfg80211_nan_match(struct wireless_dev *wdev,
			struct cfg80211_nan_match_params *match, gfp_t gfp);
void cfg80211_nan_func_terminated(struct wireless_dev *wdev,
				  u8 inst_id,
				  enum nl80211_nan_func_term_reason reason,
				  u64 cookie, gfp_t gfp);

Some more descriptive text about the use of these functions would be
appropriate I think. For example looking at the patch series it seems
the responsibility to call cfg80211_free_nan_func() is in the driver
although allocation is done by cfg80211. Actually, I do not see mac80211
calling it so are we leaking there? I would expect it being called in
.del_nan_func() callback and/or .stop_nan(). Rather than exporting
cfg80211_free_nan_func() I would prefer calling
cfg80211_nan_func_terminated() and have cfg80211 take care of freeing
nan_func resources.

Regards,
Arend

> Cheers,
> Luca.
> 
> 
> Ayala Beker (9):
>   cfg80211: add start / stop NAN commands
>   mac80211: add boilerplate code for start / stop NAN
>   cfg80211: add add_nan_func / del_nan_func
>   cfg80211: allow the user space to change current NAN configuration
>   cfg80211: provide a function to report a match for NAN
>   cfg80211: Provide an API to report NAN function termination
>   mac80211: implement nan_change_conf
>   mac80211: Implement add_nan_func and rm_nan_func
>   mac80211: Add API to report NAN function match
> 
>  include/net/cfg80211.h       | 184 ++++++++++++-
>  include/net/mac80211.h       |  65 +++++
>  include/uapi/linux/nl80211.h | 253 +++++++++++++++++
>  net/mac80211/cfg.c           | 208 ++++++++++++++
>  net/mac80211/chan.c          |   6 +
>  net/mac80211/driver-ops.h    |  80 ++++++
>  net/mac80211/ieee80211_i.h   |  17 ++
>  net/mac80211/iface.c         |  28 +-
>  net/mac80211/main.c          |   8 +
>  net/mac80211/offchannel.c    |   4 +-
>  net/mac80211/rx.c            |   3 +
>  net/mac80211/trace.h         | 133 +++++++++
>  net/mac80211/util.c          |  50 +++-
>  net/wireless/chan.c          |   2 +
>  net/wireless/core.c          |  35 +++
>  net/wireless/core.h          |   3 +
>  net/wireless/mlme.c          |   1 +
>  net/wireless/nl80211.c       | 642 ++++++++++++++++++++++++++++++++++++++++++-
>  net/wireless/rdev-ops.h      |  58 ++++
>  net/wireless/trace.h         |  90 ++++++
>  net/wireless/util.c          |  28 +-
>  21 files changed, 1888 insertions(+), 10 deletions(-)
> 
