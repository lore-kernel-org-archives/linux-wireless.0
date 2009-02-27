Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48479 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbZB0A6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 19:58:42 -0500
Subject: Re: [Ipw2100-devel] ipw2100: race between isr_indicate_associated
 and rx path
From: Zhu Yi <yi.zhu@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <200902251340.02010.helmut.schaa@gmail.com>
References: <200901211734.48625.helmut.schaa@gmail.com>
	 <200902241315.43128.helmut.schaa@gmail.com>
	 <1235524696.6354.562.camel@debian>
	 <200902251340.02010.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 08:55:39 +0800
Message-Id: <1235696139.6354.584.camel@debian> (sfid-20090227_015847_987192_2CD1E108)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-25 at 20:39 +0800, Helmut Schaa wrote:
> Argh! Just found out why dev_activate is called such late after
> netif_carrier_on:
> 
> ipw2100 calls netif_carrier_on followed by netif_wake_queue when the
> driver
> moves from associating to associated state. netif_carrier_on will then
> call linkwatch_fire_event. However the carrier_on event is not treated
> as
> urgent and as such the event is delayed (and thus dev_activate too).
> 
> An event is considered urgent if the netdev is running, has a carrier
> _and_ any of the TX qdiscs changed. Since ipw2100 first calls
> carrier_on,
> the last condition is not met and thus the event is not considered
> urgent and gets delayed.

Calling netif_wake_queue() before netif_carrier_on() is not correct in
semantics. Even it works, it looks like a workaround hack. I still think
making a sync version of netif_carrier_on is the way to go.

> Just changing the order to first wake up the queues followed by the
> carrier_on results in an urgent event. I ran a few tests with that
> change
> (+ frame buffering patch) and wasn't able to trigger the race again.
> 
> I'll fold that into the frame buffer patch and send it to
> ipw2100-devel
> once I finished the tests.

Sounds good.

Thanks,
-yi

