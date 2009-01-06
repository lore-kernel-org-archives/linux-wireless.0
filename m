Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58750 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZAFRMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:12:19 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <1231260306.14565.21.camel@localhost.localdomain>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 18:12:17 +0100
Message-Id: <1231261937.5246.16.camel@californication> (sfid-20090106_181223_380955_C1EABD2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > > > > Running pm-suspend from pm-utils directly also triggers the problem, 
> > > > > so that would seem to excuse gnome-power-manager at least.
> > > > 
> > > > What's the status of this? Should I look into things a bit?
> > > 
> > > Well, I guess I should have noticed this a lot earlier, but anyway the 
> > > problem was pm-utils on Fedora 10:
> > > 
> > > /usr/lib/pm-utils/sleep.d/55NetworkManager:
> > > 
> > >     suspend_nm()
> > >     {
> > >         # Tell NetworkManager to shut down networking
> > >         dbus-send --system                         \
> > >             --dest=org.freedesktop.NetworkManager  \
> > >             /org/freedesktop/NetworkManager        \
> > >             org.freedesktop.NetworkManager.sleep
> > >     }
> > > 
> > > I really don't think this is necessary (g-p-m will also do it if you 
> > > set the proper gconf setting.)
> > 
> > this should not be needed at all. I have systems running wpa_supplicant
> > and not any of the pm-utils scripts messing with it. During suspend and
> > later resume it indicates normally just only a new handshake with the AP
> > or a disconnect if the AP got out of range.
> > 
> > I think Network Manager is perfectly capable of handling state changes
> > from wpa_supplicant. I really do think that this hack only exists of
> > some broken drivers from really old kernels or for the 0.6 version of
> > Network Manager. Remember that Ubuntu's suspend/resume solution used to
> > be to unload all networking drivers on suspend.
> 
> You still want to tell NM to go to sleep so it doesn't see the
> disconnection from the supplicant (triggered by the driver because it
> was going to sleep), and thus try to reconnect, or try a different AP.
> Ideally NM would simply listen for signals from some power service such
> that we wouldn't have to have this hack, but there isn't a global power
> service yet on the system bus.
> 
> Furthermore, it's nice to know if we've gone to sleep or not so that we
> can do some optimizations on wakeup to find APs and reconnect faster.

actually the fastest way to re-connect is to just let wpa_supplicant do
it and then you don't even have to go through DHCP again if the lease
time is still valid. This works great if the AP is still in range.

What is your downside with the letting wpa_supplicant send you a
disconnect when the AP is out of range after resume?

Regards

Marcel


