Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39421 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbaLHKRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 05:17:10 -0500
Message-ID: <1418033823.2001.1.camel@sipsolutions.net> (sfid-20141208_111722_441010_48A60C5F)
Subject: Re: [PATCH v2] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 08 Dec 2014 11:17:03 +0100
In-Reply-To: <CAMw6YJ+8JpgTG4AbJo71JuOW8jpEo5HxFX=bDDPcpd4L_b6drA@mail.gmail.com> (sfid-20141208_110743_993632_79B20769)
References: <1417947627-2329-1-git-send-email-vadim4j@gmail.com>
	 <1418023628.2001.0.camel@sipsolutions.net>
	 <CAMw6YJ+8JpgTG4AbJo71JuOW8jpEo5HxFX=bDDPcpd4L_b6drA@mail.gmail.com>
	 (sfid-20141208_110743_993632_79B20769)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-08 at 12:07 +0200, Vadim Kochan wrote:
> You meant here ?
> 
> net/wireless/core.c : static int cfg80211_netdev_notifier_call(struct
> notifier_block *nb,
>                                           unsigned long state, void *ptr)
> {
> 
>     ...
>     switch (state) {
>              case NETDEV_POST_INIT:
>                      SET_NETDEV_DEVTYPE(dev, &wiphy_type);
>                      break;
>              case NETDEV_REGISTER:
>                      ...
>                      dev->rtnl_link_ops = &wireless_link_ops;
>                      ...
>     }

Well it seems it could go more with the SET_NETDEV_TYPE()?

johannes

