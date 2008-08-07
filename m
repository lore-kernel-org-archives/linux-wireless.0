Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:33092 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYHGSCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 14:02:09 -0400
Received: by an-out-0708.google.com with SMTP id d40so98151and.103
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2008 11:02:08 -0700 (PDT)
Message-ID: <43e72e890808071102t281f3c4ctb9d1f1c5822dbc8f@mail.gmail.com> (sfid-20080807_200214_879940_716BCB0F)
Date: Thu, 7 Aug 2008 11:02:08 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] cfg80211: keep track of supported interface modes
Cc: "Dan Williams" <dcbw@redhat.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1218122495.3630.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1218122495.3630.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 7, 2008 at 8:21 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> It is obviously good for userspace to know up front which interface modes
> a given piece of hardware might support (even if adding such an interface
> might fail later because of concurrency issues), so let's make cfg80211
> aware of that. For good measure, disallow adding interfaces in all other
> modes so drivers don't forget to announce support for one mode when they
> add it.
>
> This patch is incomplete as it doesn't modify all drivers. The driver
> modifications should be straight-forward, I'm hoping somebody else
> can pick it up and collect the necessary driver changes. Included is a
> b43 change because I tested it with that. I have also pushed an iw
> change to print out this information.
>
> It's a bit ugly that it requires drivers to use nl80211 constants, but
> if anything mac80211 should migrate to using those completely instead
> of translating them to its own versions.

This is nice :)

> --- everything.orig/drivers/net/wireless/b43/main.c     2008-08-07 16:49:57.000000000 +0200
> +++ everything/drivers/net/wireless/b43/main.c  2008-08-07 16:57:12.000000000 +0200
> @@ -4165,11 +4165,11 @@ static int b43_op_add_interface(struct i
>
>        /* TODO: allow WDS/AP devices to coexist */
>
> -       if (conf->type != IEEE80211_IF_TYPE_AP &&
> -           conf->type != IEEE80211_IF_TYPE_MESH_POINT &&
> -           conf->type != IEEE80211_IF_TYPE_STA &&
> -           conf->type != IEEE80211_IF_TYPE_WDS &&
> -           conf->type != IEEE80211_IF_TYPE_IBSS)
> +       if (WARN_ON(conf->type != IEEE80211_IF_TYPE_AP &&

When would we hit the WARN_ON() ?

  Luis
