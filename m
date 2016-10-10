Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55226 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751590AbcJJK2i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 06:28:38 -0400
Message-ID: <1476095313.7895.12.camel@sipsolutions.net> (sfid-20161010_122842_173464_D28003F4)
Subject: Re: [PATCH v5 3/4] cfg80211: configure multicast to unicast for AP
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        netdev@vger.kernel.org
Date: Mon, 10 Oct 2016 12:28:33 +0200
In-Reply-To: <1475865574-5384-3-git-send-email-michael-dev@fami-braun.de>
References: <1475865574-5384-1-git-send-email-michael-dev@fami-braun.de>
         <1475865574-5384-3-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>   *
> + * @NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED: Multicast packets
> should be
> + *      send out as unicast to all stations.

You should document what type of attribute is expected. You probably
wanted a flag attribute, but ...

> +	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type =
> NLA_U8, },

have u8 in the policy, yet

> +	enabled = nla_get_flag(nla);

actually use as a flag :)


In addition to that, I think you should clarify the "per-BSS" comment
in nl80211, and also clarify (at the same place) what kind of
functionality is expected from this.

johannes
