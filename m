Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53932 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab3EBAyD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 20:54:03 -0400
Message-ID: <5181B927.5010407@openwrt.org> (sfid-20130502_025409_473336_8653D954)
Date: Thu, 02 May 2013 02:53:59 +0200
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
References: <518166C5.4080904@openwrt.org> <CABPxzYLP53mnMXAicD33oX8TW77xnZziS=XBuVCy_u4H2oyLUw@mail.gmail.com> <CAOaVG179Rx_JfV99mbjWhwQTALb5gh+2_WVFWDSbngA0qkzoGw@mail.gmail.com> <518183C8.8050606@openwrt.org> <20130501154904.0ea31991@nehalam.linuxnetplumber.net>
In-Reply-To: <20130501154904.0ea31991@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-02 12:49 AM, Stephen Hemminger wrote:
> On Wed, 01 May 2013 23:06:16 +0200
> Felix Fietkau <nbd@openwrt.org> wrote:
> 
>> On 2013-05-01 10:21 PM, Stephen Hemminger wrote:
>> > What about using AF_PACKET bound to underlying wireless device and the
>> > packet type. You can even use BPF to filter.
>> As far as I know, AF_PACKET only works when not binding it to the packet
>> type (otherwise it get stolen by the rx handler).
> 
> You can do AF_PACKET and it gets handle before rx_handler.
If I don't bind it to a protocol, it ends up in ptype_all, if I do, it
ends up in &ptype_base. ptype_all is processed before the rx_handler,
ptype_base is processed after the rx handler.
Hooking into ptype_all wastes tons of CPU cycles, hooking into
ptype_base does not solve the problem.

- Felix
