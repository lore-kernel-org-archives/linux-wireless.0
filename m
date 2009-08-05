Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47570 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751AbZHEPxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 11:53:31 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 08:53:32 -0700
Date: Wed, 5 Aug 2009 08:53:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: andrea rossato <andrea.rossato@unitn.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>
Subject: Re: [ath5k-devel] a possible regression in managed mode ?
Message-ID: <20090805155330.GC4727@mosca>
References: <43e72e890908050810h29c28945o4732f8606caab9fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890908050810h29c28945o4732f8606caab9fb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 05, 2009 at 08:10:18AM -0700, Luis R. Rodriguez wrote:
> On Wed, Aug 5, 2009 at 6:41 AM, andrea rossato<andrea.rossato@unitn.it> wrote:
> > On Tue, Aug 04, 2009 at 08:36:43AM -0700, Luis R. Rodriguez wrote:
> >> Also, can you try wpa_supplicant from git, to see if that makes a
> >> difference?
> > ...
> >>
> >> I should note that new kernel stuff should not bust with old
> >> userspace. If upgrading to a newer supplicant fixes your issue
> >> we may have a regression somewhere in wireless-testing, which
> >> I have been suspicious about, but haven't had time to look at it.
> >
> >
> > On Tue, Aug 04, 2009 at 08:36:43AM -0700, Luis R. Rodriguez wrote:
> >> Also, can you try wpa_supplicant from git, to see if that makes a
> >> difference?
> > ...
> >>
> >> I should note that new kernel stuff should not bust with old
> >> userspace. If upgrading to a newer supplicant fixes your issue
> >> we may have a regression somewhere in wireless-testing, which
> >> I have been suspicious about, but haven't had time to look at it.
> >
> >
> > Well, I need to correct myself a bit: after trying wpa_supplicant from
> > git and noticing it worked fine I wanted to investigate a bit further
> > and went back to the 0.6.9 release. And it worked too, sort of...
> >
> > Basically both versions work with the first association and
> > authentication. The problem comes when I ask them or they need to
> > reassociate.
> 
> Can you try with -D nl80211 and see if that fixes your issue?
> 
> Also from your description of the issue below it is unclear to me if
> you do not see these issues with an older kernel or if this is only
> happening with newer kernels or wireless-testing. Can you please
> clarify.
> 
>   Luis
> 
> > Now, since I do not use NetworkManager, and I need to connect to
> > different wireless networks with different configurations (dhcp,
> > proxies, etc.), in my scripts I use something like:
> >
> > wpa_cli -a/usr/local/sbin/wpa_action -B
> >
> > followed by a:
> > wpa_cli rea
> >
> > And whenever wpa_supplicat tries to associate for a second time I keep
> > getting an authentication timeout error.
> >
> > For instance:
> >
> > [13:38:02]$ wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf
> > CTRL-EVENT-SCAN-RESULTS
> > Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> > CTRL-EVENT-SCAN-RESULTS
> > Associated with 00:22:b0:70:1f:67
> > WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
> > CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (auth) [id=1 id_str=]
> >
> > The first run is ok. But I cannot reassociate. Below you'll see the
> > output of wpa_supplicant and iwevent when I run `wpa_cli reas`.
> >
> > Now, if I run the adapter in Master mode (as an access point) and then
> > go back to Managed mode with wpa_supplicant, the first association and
> > authentication will work most of the time (not always).
> >
> > I'm puzzled but that could be a useful piece of information,
> > hopefully. Take into account that my other Eee pc connects always
> > perfectly with the very same AP (as mine does when running
> > wpa_supplicant for the first time).
> >
> > Right now I have some troubles in providing some better debugging
> > output (I cannot reboot right now, due to some unfinished work that
> > must have the precedence), but please let me know what might be useful
> > and I'll try to come up with something in the next few days.
> >
> > Andrea
> >
> > The wpa_supplicant output:
> >
> > CTRL-EVENT-SCAN-RESULTS
> > Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> > Authentication with 00:22:b0:70:1f:67 timed out.
> > CTRL-EVENT-SCAN-RESULTS
> > WPS-AP-AVAILABLE
> > Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> > Authentication with 00:22:b0:70:1f:67 timed out.
> > CTRL-EVENT-SCAN-RESULTS
> > WPS-AP-AVAILABLE
> > Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> > Authentication with 00:22:b0:70:1f:67 timed out.
> > CTRL-EVENT-SCAN-RESULTS
> > WPS-AP-AVAILABLE
> > Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> > Authentication with 00:22:b0:70:1f:67 timed out.
> > CTRL-EVENT-SCAN-RESULTS
> > Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> > Authentication with 00:22:b0:70:1f:67 timed out.
> > CTRL-EVENT-SCAN-RESULTS
> > Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> > Authentication with 00:22:b0:70:1f:67 timed out.
> > CTRL-EVENT-SCAN-RESULTS
> > WPS-AP-AVAILABLE
> > Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> > Authentication with 00:22:b0:70:1f:67 timed out.
> >
> > The iwevent session:

Also please install iw, and provide 'iw event -t' log.

http://wireless.kernel.org/en/users/Documentation/iw

  Luis
