Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:30934 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXIZACk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 20:02:40 -0400
Received: by py-out-1112.google.com with SMTP id u77so3838435pyb
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 17:02:39 -0700 (PDT)
Message-ID: <43e72e890709251702q27bbfa5eoe65a626ced383dd6@mail.gmail.com>
Date: Tue, 25 Sep 2007 20:02:38 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix interface initialisation
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1190755892.18521.330.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200709252206.57855.mb@bu3sch.de>
	 <1190755892.18521.330.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/25/07, Johannes Berg <johannes@sipsolutions.net> wrote:

> --- wireless-dev.orig/net/mac80211/ieee80211_iface.c    2007-09-25 22:26:40.111572537 +0200
> +++ wireless-dev/net/mac80211/ieee80211_iface.c 2007-09-25 23:28:21.651570910 +0200
> @@ -127,6 +127,12 @@ int ieee80211_if_add_mgmt(struct ieee802
>         if (ret)
>                 goto fail;
>
> +       /*
> +        * Called even when register_netdevice fails, it would
> +        * oops if assigned before initialising the rest.
> +        */
> +       ndev->uninit = ieee80211_if_reinit;
> +
>         ieee80211_debugfs_add_netdev(nsdata);
>
>         if (local->open_count > 0)

What still uses ieee80211_if_add_mgmt()? I don't see anything using
it. Also, did we decide on what to do with IEEE80211_IF_TYPE_MGMT?

  Luis
