Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33977 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbcIPJAx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 05:00:53 -0400
Received: by mail-qk0-f182.google.com with SMTP id h8so76838224qka.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2016 02:00:52 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] Add support for Neighbor Awareness Networking
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20160916083321.5840-1-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1055fff0-4eb0-08c5-2e16-a0b6f2887bda@broadcom.com> (sfid-20160916_110057_232990_3359C696)
Date: Fri, 16 Sep 2016 11:00:38 +0200
MIME-Version: 1.0
In-Reply-To: <20160916083321.5840-1-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-9-2016 10:33, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Hi,
> 
> This is v2 of the NAN patches that Emmanuel sent a while back[1].  In
> this version, we squashed some patches and took care of some comments
> after reviews (both internal and public).

Hi Luca,

You may have missed some as I think this should be v4.

Regards,
Arend

[1]
http://mid.gmane.org/1458845547-28762-1-git-send-email-emmanuel.grumbach@intel.com

> NAN was described in the original post[2].
> 
> I hope they're good for merging now, because I'm tired of carrying
> this changes forward in our internal trees. :P
> 
> Nevertheless, comments are welcome, as always.
> 
> [1] http://mid.gmane.org/1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com
> [2] http://mid.gmane.org/1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com
> 
> Cheers,
> Luca.
> 
> 
> Ayala Beker (9):
>   cfg80211: add start / stop NAN commands
>   mac80211: add boilerplate code for start / stop NAN
>   cfg80211: add add_nan_func / rm_nan_func
>   cfg80211: allow the user space to change current NAN configuration
>   cfg80211: provide a function to report a match for NAN
>   cfg80211: Provide an API to report NAN function termination
>   mac80211: implement nan_change_conf
>   mac80211: Implement add_nan_func and rm_nan_func
>   mac80211: Add API to report NAN function match
> 
>  include/net/cfg80211.h       | 184 ++++++++++++-
>  include/net/mac80211.h       |  65 +++++
>  include/uapi/linux/nl80211.h | 258 +++++++++++++++++
>  net/mac80211/cfg.c           | 208 ++++++++++++++
>  net/mac80211/chan.c          |   6 +
>  net/mac80211/driver-ops.h    |  82 +++++-
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
>  21 files changed, 1894 insertions(+), 11 deletions(-)
> 
