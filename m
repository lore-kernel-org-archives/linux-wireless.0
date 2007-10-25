Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:60871 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbXJYP74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 11:59:56 -0400
Received: by py-out-1112.google.com with SMTP id u77so845431pyb
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2007 08:59:55 -0700 (PDT)
Message-ID: <43e72e890710250859t278155a9v4349d9fc8f85bc98@mail.gmail.com> (sfid-20071025_170003_077795_0E583E4F)
Date: Thu, 25 Oct 2007 11:59:54 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [patch 5/9] mac80211: add beacon configuration via cfg80211
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071025093716.172679000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071025093618.440937000@sipsolutions.net>
	 <20071025093716.172679000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> This patch implements the cfg80211 hooks for configuring beaconing
> on an access point interface in mac80211. While doing so, it fixes
> a number of races that could badly crash the machine when the
> beacon is changed while being requested by the driver.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> ---
> The dtim_count field should possibly also be part of the beacon
> structure, but the possible race there doesn't really matter,
> worst thing is that one beacon will be sent with a wrong dtim
> count if (and only if) userspace changes the dtim period during
> operation.
>
>  net/mac80211/cfg.c             |  108 +++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/debugfs_netdev.c  |   27 ----------
>  net/mac80211/ieee80211_i.h     |   14 +++--
>  net/mac80211/ieee80211_iface.c |    4 -
>  net/mac80211/tx.c              |   63 ++++++++++++++---------
>  5 files changed, 156 insertions(+), 60 deletions(-)
>
> --- linux-2.6.orig/net/mac80211/cfg.c   2007-10-24 11:35:49.722690568 +0200
> +++ linux-2.6/net/mac80211/cfg.c        2007-10-25 10:46:56.070256998 +0200
> @@ -10,6 +10,7 @@
>  #include <linux/nl80211.h>
>  #include <linux/rtnetlink.h>
>  #include <net/net_namespace.h>
> +#include <linux/rcupdate.h>
>  #include <net/cfg80211.h>
>  #include "ieee80211_i.h"
>  #include "cfg.h"
> @@ -269,6 +270,112 @@ static int ieee80211_config_default_key(
>         return 0;
>  }
>
> +static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
> +                               struct beacon_parameters *beacon)

To be consistent how about s/beacon/params here for beacon_parameters.

 Luis
