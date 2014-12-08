Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39933 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaLHV6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 16:58:35 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so4907602lbj.27
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2014 13:58:33 -0800 (PST)
Date: Mon, 8 Dec 2014 23:48:45 +0200
From: vadim4j@gmail.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vadim Kochan <vadim4j@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
Message-ID: <20141208214845.GA1709@angus-think.lan> (sfid-20141208_225905_836969_AA489AD9)
References: <1417947627-2329-1-git-send-email-vadim4j@gmail.com>
 <1418023628.2001.0.camel@sipsolutions.net>
 <CAMw6YJ+8JpgTG4AbJo71JuOW8jpEo5HxFX=bDDPcpd4L_b6drA@mail.gmail.com>
 <1418033823.2001.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418033823.2001.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 08, 2014 at 11:17:03AM +0100, Johannes Berg wrote:
> On Mon, 2014-12-08 at 12:07 +0200, Vadim Kochan wrote:
> > You meant here ?
> > 
> > net/wireless/core.c : static int cfg80211_netdev_notifier_call(struct
> > notifier_block *nb,
> >                                           unsigned long state, void *ptr)
> > {
> > 
> >     ...
> >     switch (state) {
> >              case NETDEV_POST_INIT:
> >                      SET_NETDEV_DEVTYPE(dev, &wiphy_type);
> >                      break;
> >              case NETDEV_REGISTER:
> >                      ...
> >                      dev->rtnl_link_ops = &wireless_link_ops;
> >                      ...
> >     }
> 
> Well it seems it could go more with the SET_NETDEV_TYPE()?
> 
> johannes
> 

What I worry about is this peace of code in net/core/dev.c : 

    int register_netdevice(struct net_device *dev)
    {
            ...

            if (!dev->rtnl_link_ops ||
                dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
                    rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL);
            ...
    }

which will skip sending RTM_NEWLINK message if it has rtnl_link_ops ...
Actually meanwhile I dont see any problems as my wifi works OK with
these changes, but I want to be sure in 100% that it does not break
anything ...

So I am under investigating this ... Maybe you can suggest ?

Thanks,
