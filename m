Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54739 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYI1G4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 02:56:12 -0400
Subject: Re: Getting country alpha2 on network manager and using it for crda
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1222440218.19895.19.camel@localhost.localdomain>
References: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com>
	 <1222440218.19895.19.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 28 Sep 2008 08:56:15 +0200
Message-Id: <1222584975.9600.2.camel@californication> (sfid-20080928_090018_082771_4346C104)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > So since this may not happen for a while I figure I can give a shot.
> > But I'm curious where we should get our country alpha2 from? Does LSB
> > define a country has to be somewhere? Maybe the locale? Timezone?
> > Anyway, in the end the user should be able to change the country too.
> > 
> > I'm thinking to start by just letting the user pick a country for now.
> > We can figure out where the hell it gets the country by default later
> > but if you have ideas that'd be great. It seems reasonable to ask for
> > this upon installation time (?)
> 
> My suggestion: use the current timezone as a fallback unless the user
> has specified the locale somewhere.  That can obviously be done in NM or
> lower, ideally we delegate this sort of thing to the supplicant and just
> pass the alpha2 when NM adds the interface to the supplicant.  The
> addInterface() call args are just a dict, so it would be trivial to add
> another item in that dict for country code.  Since the country code is
> global to the machine it's probably something we should just store in
> the system settings service, and it's also something that probably
> requires privileges to change.

I would prefer if wpa_supplicant gets a global method for setting the
alpha2 value. It should be dynamic and for me wpa_supplicant is the
right place to handle this value.

The question on how we set this value is a little bit more trickier.
What we do need is a Location Manager that can use multiple source to
get our current location (WiFi, GSM/UMTS, GPS etc.).

Regards

Marcel


