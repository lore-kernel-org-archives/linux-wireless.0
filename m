Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2IBXUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 19:20:24 -0400
Message-ID: <1346628057.10113.13.camel@jlt4.sipsolutions.net> (sfid-20120903_012027_869798_25F4CF35)
Subject: Re: [RFC][PATCH] rtl8192cu: completing beaconing support
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: coekbe <coekbe@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 03 Sep 2012 01:20:57 +0200
In-Reply-To: <5043E582.6070205@lwfinger.net> (sfid-20120903_010233_586023_7DF08501)
References: <CAK678xg-uD6rKdcZVksAdAwMtsvmcn6GmYsSa1gWS=CNTLpenw@mail.gmail.com>
	 <5043E582.6070205@lwfinger.net> (sfid-20120903_010233_586023_7DF08501)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-02 at 18:02 -0500, Larry Finger wrote:

> Changing rtlwifi is not acceptable when you only wish to modify a single driver. 
> That code in any other routine than usb.c will affect all the other drivers.
> 
> I used my hostapd script to start an AP with rtl8192cu using the ESSID "TEST". 
> After I did tat, I did an 'iw scan' with a different interface and got
> 
> BSS 00:1f:1f:c8:8e:cb (on wlan2)
...

> Obviously, the rtl8192cu is beaconing with no changes to the wireless-testing 
> code.

Just FYI -- that's not guaranteed if "iw scan" returns results, you'd
have to run "iw scan passive" to make sure you pick up beacons rather
than just probe responses.

johannes

