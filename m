Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:52060 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab3EAWtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 18:49:17 -0400
Received: by mail-da0-f48.google.com with SMTP id h32so4932dak.21
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 15:49:17 -0700 (PDT)
Date: Wed, 1 May 2013 15:49:04 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev <netdev@vger.kernel.org>
Subject: Re: Regression in 3.9 caused by "bridge: respect RFC2863
 operational state"
Message-ID: <20130501154904.0ea31991@nehalam.linuxnetplumber.net> (sfid-20130502_004921_928796_3DF7C1D0)
In-Reply-To: <518183C8.8050606@openwrt.org>
References: <518166C5.4080904@openwrt.org>
	<CABPxzYLP53mnMXAicD33oX8TW77xnZziS=XBuVCy_u4H2oyLUw@mail.gmail.com>
	<CAOaVG179Rx_JfV99mbjWhwQTALb5gh+2_WVFWDSbngA0qkzoGw@mail.gmail.com>
	<518183C8.8050606@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 01 May 2013 23:06:16 +0200
Felix Fietkau <nbd@openwrt.org> wrote:

> On 2013-05-01 10:21 PM, Stephen Hemminger wrote:
> > What about using AF_PACKET bound to underlying wireless device and the
> > packet type. You can even use BPF to filter.
> As far as I know, AF_PACKET only works when not binding it to the packet
> type (otherwise it get stolen by the rx handler).

You can do AF_PACKET and it gets handle before rx_handler.

> Not binding it to the packet type and using BPF to filter is expensive
> on small embedded devices with small caches. Still, this requires
> userspace changes, so we need a different solution.
> 
> > Another alternative would be to have bridge accept control frames on
> > dormant device but not send.
> Sounds good, will you send a patch for that?
> 
> - Felix
> 

