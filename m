Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1LLJEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 04:04:20 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EE35877.1060507@gmx.net> (sfid-20111210_140255_490293_C3C0F113)
References: <4EE2202A.4080303@gmx.net>
	 <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>
	 <1323451436.13074.158.camel@wwguy-huron>
	 (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>
	 <4EE35877.1060507@gmx.net> (sfid-20111210_140255_490293_C3C0F113)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:04:17 +0100
Message-ID: <1323680657.3442.7.camel@jlt3.sipsolutions.net> (sfid-20111212_100425_577039_B740C70E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-12-10 at 14:02 +0100, Wolfgang Breyha wrote:
> On 09/12/11 19:26, Johannes Berg wrote:
> > What's "this area"? This isn't exactly the first report of random memory
> > corruption ... I think the last one was something with 32/64 bit but I
> > don't remember.
> 
> To narrow down "this area" I tried the following:
> 
> *) I reconfigured my soekris AP hostapd to use wpa_group_rekey=0
>    .... and it works like a charm since then
> 
> *) I reconfigured the ubiquiti UniFi AP to use wpa_group_rekey=120
>    ... and I'am pretty sure now that it is exactly the second rekeying
>    that starts messing up the system. Exactly after wpa_supplicant logs
> WPA: Group rekeying completed with 06:27:22:xx:xx:xx [GTK=TKIP]
>    the second time, video streaming with VLC immediatly leeds to all the
>    mentioned sideeffects.
> 
> Maybe it's possible to reproduce it with any hostapd based AP with
> active wpa_group_rekey.

Ok, thanks.

Are you running a 32-bit kernel on a 64-bit machine by any chance?
Somebody else reported that using a 64-bit kernel helped similar issues.

johannes

