Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbXC1Osm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 10:48:42 -0400
Subject: Re: debugging network manager association failure?
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1175023571.5151.3.camel@johannes.berg>
References: <1175023571.5151.3.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 10:52:10 -0400
Message-Id: <1175093530.6907.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-03-27 at 21:26 +0200, Johannes Berg wrote:
> Hi,
> 
> Usually I simply use wpa_supplicant itself when testing but for some
> reason I decided to use nm today... and it failed.
> 
> My nm is 0.6.4 and wpa_supplicant 0.6.0. When I use wpa_supplicant with
> a config file like this:
> --- %< ---
> ctrl_interface=/var/run/wpa_supplicant
> eapol_version=1
> ap_scan=1
> fast_reauth=1
> network={
>         ssid="berg"
>         priority=1
>         key_mgmt=WPA-PSK
>         psk="stuffhere"
>         pairwise=CCMP
>         group=CCMP TKIP
> }
> --- >% ---
> 
> it works perfectly. But with nm it doesn't do anything at all, stracing
> it yields that it thinks it's getting authentication timeouts with
> 00:...:00. Any idea what could be causing this? Is this a bug in
> mac80211?

There's been weird errors with wpa_supplicant that I can't quite wrap my
head around.  There are two cases:

1) NM can't connect to wpa_supplicant's control socket sometimes; this
is fixed by using the D-Bus interface

2) The _same_ settings sent to wpa_supplicant via NM, and those same
settings in the config file, produce different results.  I've compared
the settings of quite a few cases of this and found no appreciable
differences, but still NM fails to associate.  I was kind of hoping this
would all go away with the switch to the D-Bus interface in 0.7, because
the socket-based control interface has been so much of a hassle.  But it
probably needs to be fixed for the 0.6.x branch.

Could you possibly get some driver traces of what happens in the driver
for plain wpa_supplicant and then with NM+wpa_supplicant?  If the config
that NM is sending to wpa_supplicant is the same, then the only thing I
can think of is some randomly different driver state or interaction
between the 3 unrelated to the specific config info that's causing
associations to fail.

Dan


