Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46375 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab3EAVGP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 17:06:15 -0400
Message-ID: <518183C8.8050606@openwrt.org> (sfid-20130501_230626_137566_12E69935)
Date: Wed, 01 May 2013 23:06:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev <netdev@vger.kernel.org>
Subject: Re: Regression in 3.9 caused by "bridge: respect RFC2863 operational
 state"
References: <518166C5.4080904@openwrt.org> <CABPxzYLP53mnMXAicD33oX8TW77xnZziS=XBuVCy_u4H2oyLUw@mail.gmail.com> <CAOaVG179Rx_JfV99mbjWhwQTALb5gh+2_WVFWDSbngA0qkzoGw@mail.gmail.com>
In-Reply-To: <CAOaVG179Rx_JfV99mbjWhwQTALb5gh+2_WVFWDSbngA0qkzoGw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-01 10:21 PM, Stephen Hemminger wrote:
> What about using AF_PACKET bound to underlying wireless device and the
> packet type. You can even use BPF to filter.
As far as I know, AF_PACKET only works when not binding it to the packet
type (otherwise it get stolen by the rx handler).
Not binding it to the packet type and using BPF to filter is expensive
on small embedded devices with small caches. Still, this requires
userspace changes, so we need a different solution.

> Another alternative would be to have bridge accept control frames on
> dormant device but not send.
Sounds good, will you send a patch for that?

- Felix

