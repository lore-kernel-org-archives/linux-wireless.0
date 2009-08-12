Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:34787 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZHLTlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 15:41:55 -0400
Date: Wed, 12 Aug 2009 12:41:50 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Multiple SSID
Message-ID: <20090812124150.025b4538@nehalam>
In-Reply-To: <43e72e890908121025p75b141b6o86c30518bf9de7ea@mail.gmail.com>
References: <20090812100416.744dc5ba@nehalam>
	<43e72e890908121025p75b141b6o86c30518bf9de7ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 12 Aug 2009 10:25:34 -0700
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> On Wed, Aug 12, 2009 at 10:04 AM, Stephen
> Hemminger<shemminger@vyatta.com> wrote:
> > I have a dumb questions. How does one setup multiple SSID's with
> > current (ie not madwifi) wireless API?
> >
> > 1. I assume need to run multiple instances of hostapd with different
> >   config. Will that work?
> 
> Yes. But the next question is how to create new wlan%d AP interfaces.
> That is answered below.
> 
> > 2. Since IP address is attached to device (wlan0), how can each SSID
> >   have different IP address? Use vlan's?
> 
> The new 'iw' [2] utility could be used to create monitor interfaces or
> ad-hoc interfaces for example. We decided to only allow you to create
> an "AP" type of interface with a utility that handles the MLME in
> userspace, such a utility is hostapd. You will need to use the nl80211
> driver with hosatpd [2]. We have documented the supported wireless
> modes in our wiki [3], I suppose that could use some updating.
> 
> Anyway I believe AP-enabled devices right now only support creating 1
> AP interfface. I believe the exception to this right now is ath9k
> through the private virtual interface stuff Jouni created, but to be
> honest I have to go and review that to make sure you can create 2 APs.
> 
> Typically drivers (MadWifi) which supported multiple BSSs (therefore
> with two SSIDs) would allow you to do this by creating BSSes on the
> same channel. The ath9k virtual interface thing allows you to create
> interfaces on *separate* channels, and provides its own scheduler,
> which you can tune, for switching back and forth.
> 
> [1] http://wireless.kernel.org/en/users/Documentation/iw
> [2] http://wireless.kernel.org/en/users/Documentation/hostapd
> [3] http://wireless.kernel.org/en/users/Documentation/modes

The existing API creates another entity 'phy0' which lives in
yet another namespace, it is not a filesystem or a network device.
The only way to enumerate these is the 'iw phy' which is okay,
but does this work with hotplug (it doesn't go through udev?)
and what about network namespaces?
