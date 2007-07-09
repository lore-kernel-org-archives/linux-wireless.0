Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbXGIS0K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 14:26:10 -0400
Subject: Re: Setting channel when interface is down inconsistency
From: Dan Williams <dcbw@redhat.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910707090759v5cd20f2en1f6c4e6fc6279b3f@mail.gmail.com>
References: <9e4733910707090759v5cd20f2en1f6c4e6fc6279b3f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 14:31:02 -0400
Message-Id: <1184005862.5671.2.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-07-09 at 10:59 -0400, Jon Smirl wrote:
> bcm43xx and rx2x00 let me set the channel before the interface is up.
> zd1211 requires the interface to be up before setting the channel.
> 
> Is there a guideline for how this is supposed to work?

In the ideal case, the driver should allow you to set any _attribute_
when the device is down, but if you try to do an _action_ that requires
that the interface be up (for example, associating), it should return an
error of some kind.

So setting things like encryption key, channel, ssid, bssid, etc should
all work when the device is down, but actually issuing the 'iwconfig
wlan0 ssid "foobar"' can be expected to fail because in WEXT that is
supposed to trigger an association.

Splitting up this stuff and having an explicit association request in
nl80211/cfg80211 should make this a lot clearer.  Most drivers don't do
this consistently right now because they often assume that they can
write the new values to card registers and such instead of putting them
into a shadow state structure internally in the driver.

Dan


