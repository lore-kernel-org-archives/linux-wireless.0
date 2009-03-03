Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:64811 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZCCLdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 06:33:37 -0500
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw2100: race between isr_indicate_associated and rx path
Date: Tue, 3 Mar 2009 12:33:23 +0100
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
References: <200901211734.48625.helmut.schaa@gmail.com> <200902251340.02010.helmut.schaa@gmail.com> <1235696139.6354.584.camel@debian>
In-Reply-To: <1235696139.6354.584.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903031233.23702.helmut.schaa@gmail.com> (sfid-20090303_123348_810417_23B8F575)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 27. Februar 2009 schrieb Zhu Yi:
> On Wed, 2009-02-25 at 20:39 +0800, Helmut Schaa wrote:
> > Argh! Just found out why dev_activate is called such late after
> > netif_carrier_on:
> > 
> > ipw2100 calls netif_carrier_on followed by netif_wake_queue when the
> > driver
> > moves from associating to associated state. netif_carrier_on will then
> > call linkwatch_fire_event. However the carrier_on event is not treated
> > as
> > urgent and as such the event is delayed (and thus dev_activate too).
> > 
> > An event is considered urgent if the netdev is running, has a carrier
> > _and_ any of the TX qdiscs changed. Since ipw2100 first calls
> > carrier_on,
> > the last condition is not met and thus the event is not considered
> > urgent and gets delayed.
> 
> Calling netif_wake_queue() before netif_carrier_on() is not correct in
> semantics. Even it works, it looks like a workaround hack. I still think
> making a sync version of netif_carrier_on is the way to go.

Hmm, we could use register_netdevice_notifier to get notified when the
carrier event is sent out and thus the tx queues are available.

The flow in ipw2100 would then be:

1) isr_indicate_associated:
- move to ASSOCIATING state
- start buffering incoming frames

2) ipw2100_ex_event_work:
- call carrier_on and wake_queues

3) netdevice_notification:
- move to ASSOCIATED state and replay buffered frames

I hope I'll find some time to try that soon.

Helmut
