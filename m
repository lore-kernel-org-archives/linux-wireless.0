Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYG3Lh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 07:37:58 -0400
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Dan Williams <dcbw@redhat.com>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <1217416640.6379.144.camel@localhost>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost>
	 <200807281600.39103.mb@bu3sch.de>
	 <1217257174.28198.27.camel@localhost.localdomain>
	 <1217257628.15381.2.camel@johannes.berg>
	 <1217258040.28198.40.camel@localhost.localdomain>
	 <1ba2fa240807280858o4020fec8k4c287567dff177ca@mail.gmail.com>
	 <1217262158.28198.44.camel@localhost.localdomain>
	 <1217416640.6379.144.camel@localhost>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 07:35:21 -0400
Message-Id: <1217417721.11432.21.camel@localhost.localdomain> (sfid-20080730_133802_319921_33B5BD97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 13:17 +0200, Luis Carlos Cobo wrote:
> So I see three options:
> 
> 1) Use 00:... and be happy. No problem with udev, we use an address that
> is actually valid.
> 
> 2) Use 01:00... and fix udev so it ignores it.
> 
> 3) Use 44:44..., because it is what orinoco used and fix udev so it
> ignores it.
> 
> I would go for solution 2, 00:00:00:00:00:00 is a valid address for a
> device and multicast addresses are not, and that should be reflected on
> udev's policy.

I guess, but having a zero MAC seems more logical to me, and it's also
the failure case if something doesn't get properly initialized.  WEXT
uses it for "disassociated".  We already check for the zero MAC in a
number of places.

But in the end, doesn't really matter to me.

> About persistent names, can we get a persistent name after the device
> gets its MAC address? Before that, the device is not being used and it
> does not matter much.

Yes, if the udev bits are good enough.  Just need something unique, and
for net devices, the MAC is supposed to be unique, of course.

Dan


