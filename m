Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35307 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZGaJlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 05:41:04 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Marcel Holtmann <marcel@holtmann.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249027460.2609.2.camel@maxim-laptop>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1249024097.7653.6.camel@maxim-laptop>
	 <1249026181.29587.14.camel@johannes.local>
	 <1249027087.29587.18.camel@johannes.local>
	 <1249027460.2609.2.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 02:41:13 -0700
Message-Id: <1249033273.23662.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maxim,

> > > Fix it then. Offer an implementation of your superior solution.
> > 
> > I just don't think that this patch is a solution because it means that
> > we'll be connected to the AP forever, without knowing anything is wrong,
> > if the AP can reach us but we can't reach the AP (maybe because we have
> > a good Intel card with great sensitivity).
> > 
> > Sure -- it's possible to factor in transmit status reports (but remember
> > that not all hardware gives those reliably) or do things on a different
> > schedule etc. But as long as nobody wants to really improve things I
> > don't see why we should take the regression and _remove_ the current
> > behaviour.
> 
> It is ok to send probes every minute or so, but not each second, and 
> probes must be retried.
> 
> Because of these probes, wireless literally reconnects every 5 seconds,
> here, and I am 10 meters from the AP.

even with Reinette's patch, I am seeing this:

[18594.423855] wlan0: cancelling probereq poll due to a received beacon
[18629.544841] No probe response from AP 00:1c:f0:xx:xx:xx after 200ms, disconnecting.

So that is with the patch, being 1m away from the AP, in the 18th floor
of a building and with only another 10 APs around me.

The Bluetooth world calls this link supervision timeout and the default
value for that timeout is 30 seconds. I think it is the best to make
this value configurable and increase it to at least 30 seconds by
default. Within Bluetooth you can change it and runtime.

Johannes, I don't care how good or bad some hardware is. How sensitive
or not. This is a clear regression and you are overdoing it here with
only waiting for 200ms.

Regards

Marcel


