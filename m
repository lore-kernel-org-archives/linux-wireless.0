Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55464 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbZETVM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 17:12:27 -0400
Subject: Re: DHCP broken when using A-band only
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1242720983.29049.16.camel@johannes.local>
References: <1242701451.3147.2.camel@localhost.localdomain>
	 <1242720983.29049.16.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 20 May 2009 14:12:13 -0700
Message-Id: <1242853933.3147.35.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > so I am running the latest wireless-testing.git tree based on 2.6.30-rc6
> > and when connecting to my A-band only configured AP, I don't get any
> > packets through. Even DHCP fails. The only thing I see in dmesg is
> > 
> > [ 3221.246392] wlan0: dropped frame to 00:1f:f3:xx:xx:xx (unauthorized port)
> > 
> > The wireless-testing.git tree based on 2.6.30-rc5 was working fine with
> > that access point. I was actually happily using the A-band since it is
> > less busy here. Any ideas why this might broke?
> 
> Not at all, sorry. Were there any driver changes? There shouldn't be
> many changes at all maybe you could bisect?

so I started to bisect this issue, but just accidentally booted into an
updated wireless-testing.git with the new 5350 ucode and my A-band only
access point does work again.

This either was a iwlwifi driver issue or maybe one of the regdomain
race conditions patches fixed it. Which could actually explain it.

Regards

Marcel


