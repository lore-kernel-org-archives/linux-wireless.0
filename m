Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52191 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaLIWSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 17:18:00 -0500
Received: by mail-lb0-f173.google.com with SMTP id z12so1320670lbi.32
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2014 14:17:58 -0800 (PST)
Date: Wed, 10 Dec 2014 00:08:04 +0200
From: vadim4j@gmail.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: vadim4j@gmail.com, John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
Message-ID: <20141209220804.GA3485@angus-think.lan> (sfid-20141209_231804_990080_05CF7106)
References: <1417947627-2329-1-git-send-email-vadim4j@gmail.com>
 <1418023628.2001.0.camel@sipsolutions.net>
 <CAMw6YJ+8JpgTG4AbJo71JuOW8jpEo5HxFX=bDDPcpd4L_b6drA@mail.gmail.com>
 <1418033823.2001.1.camel@sipsolutions.net>
 <20141208214845.GA1709@angus-think.lan>
 <1418113458.2621.0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418113458.2621.0.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 09, 2014 at 09:24:18AM +0100, Johannes Berg wrote:
> On Mon, 2014-12-08 at 23:48 +0200, vadim4j@gmail.com wrote:
> 
> > What I worry about is this peace of code in net/core/dev.c : 
> > 
> >     int register_netdevice(struct net_device *dev)
> >     {
> >             ...
> > 
> >             if (!dev->rtnl_link_ops ||
> >                 dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
> >                     rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL);
> >             ...
> >     }
> 
> rtnl_link_state should be RTNL_LINK_INITIALIZED though, unless somebody
> set something else.
> 
> johannes
> 

OK I tested & checked by code that RTNL_LINK_INITIALIZED is set, and
RTM_NEWLINK message will be sent as it was before.

I will resend the patch.

Thanks,
