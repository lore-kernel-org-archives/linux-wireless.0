Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [87.106.208.187] ([87.106.208.187]:47243 "EHLO
	mail.holtmann.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaLIXYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 18:24:12 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v3] wireless: Supporting of IFLA_INFO_KIND rtnl attribute
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1418163666-9206-1-git-send-email-vadim4j@gmail.com>
Date: Wed, 10 Dec 2014 00:23:14 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <24A120F8-952B-4471-88A6-463CBAD168BE@holtmann.org> (sfid-20141210_002415_575363_1BE35FD3)
References: <1418163666-9206-1-git-send-email-vadim4j@gmail.com>
To: Vadim Kochan <vadim4j@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> On Dec 9, 2014, at 23:21, Vadim Kochan <vadim4j@gmail.com> wrote:
> 
> It allows to identify the wlan kind of device for the user application,
> e.g.:
> 
>    # ip -d link
> 
>    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
>        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0
>    2: enp0s25: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
>        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
>    3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
>        wlan

have we considered also exposing the mode of this netdev. So for example sta,ap,p2p-go,p2p-client etc. If we can send dynamic updates via RTNL, we could easily tell the networking management system what type of wireless device we have here. I am thinking about it like "wlan/p2p-go" etc. Or should this be better kept strictly to "wlan".

And I am not sure RTNL would be capable of changing this kind strings at runtime anyway.

Regards

Marcel

