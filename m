Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39629 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaLIXcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 18:32:55 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so3445490wiv.7
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2014 15:32:54 -0800 (PST)
Date: Wed, 10 Dec 2014 01:23:05 +0200
From: vadim4j@gmail.com
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Vadim Kochan <vadim4j@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3] wireless: Supporting of IFLA_INFO_KIND rtnl attribute
Message-ID: <20141209232305.GA17043@angus-think.lan> (sfid-20141210_003258_666820_BA8D1548)
References: <1418163666-9206-1-git-send-email-vadim4j@gmail.com>
 <24A120F8-952B-4471-88A6-463CBAD168BE@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <24A120F8-952B-4471-88A6-463CBAD168BE@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2014 at 12:23:14AM +0100, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > On Dec 9, 2014, at 23:21, Vadim Kochan <vadim4j@gmail.com> wrote:
> > 
> > It allows to identify the wlan kind of device for the user application,
> > e.g.:
> > 
> >    # ip -d link
> > 
> >    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
> >        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0
> >    2: enp0s25: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
> >        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
> >    3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
> >        wlan
> 
> have we considered also exposing the mode of this netdev. So for example sta,ap,p2p-go,p2p-client etc. If we can send dynamic updates via RTNL, we could easily tell the networking management system what type of wireless device we have here. I am thinking about it like "wlan/p2p-go" etc. Or should this be better kept strictly to "wlan".
> 
> And I am not sure RTNL would be capable of changing this kind strings at runtime anyway.
> 
> Regards
> 
> Marcel
> 

May be better do not mix 2 things in one attribute?

Regards,
Vadim
