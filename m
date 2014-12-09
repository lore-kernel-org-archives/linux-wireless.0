Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44908 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaLIIY0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 03:24:26 -0500
Message-ID: <1418113458.2621.0.camel@sipsolutions.net> (sfid-20141209_092430_230945_3CAD7EFE)
Subject: Re: [PATCH v2] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: vadim4j@gmail.com
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 09 Dec 2014 09:24:18 +0100
In-Reply-To: <20141208214845.GA1709@angus-think.lan> (sfid-20141208_225835_436613_04392401)
References: <1417947627-2329-1-git-send-email-vadim4j@gmail.com>
	 <1418023628.2001.0.camel@sipsolutions.net>
	 <CAMw6YJ+8JpgTG4AbJo71JuOW8jpEo5HxFX=bDDPcpd4L_b6drA@mail.gmail.com>
	 <1418033823.2001.1.camel@sipsolutions.net>
	 <20141208214845.GA1709@angus-think.lan>
	 (sfid-20141208_225835_436613_04392401)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-08 at 23:48 +0200, vadim4j@gmail.com wrote:

> What I worry about is this peace of code in net/core/dev.c : 
> 
>     int register_netdevice(struct net_device *dev)
>     {
>             ...
> 
>             if (!dev->rtnl_link_ops ||
>                 dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
>                     rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL);
>             ...
>     }

rtnl_link_state should be RTNL_LINK_INITIALIZED though, unless somebody
set something else.

johannes

