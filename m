Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41324 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZAFTgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 14:36:18 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <1231267979.14565.34.camel@localhost.localdomain>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <1231261937.5246.16.camel@californication>
	 <1231267979.14565.34.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 20:36:15 +0100
Message-Id: <1231270575.14901.6.camel@californication> (sfid-20090106_203622_844997_B8F175D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > > > > > > Running pm-suspend from pm-utils directly also triggers the problem, 
> > > > > > > so that would seem to excuse gnome-power-manager at least.
> > > > > > 
> > > > > > What's the status of this? Should I look into things a bit?
> > > > > 
> > > > > Well, I guess I should have noticed this a lot earlier, but anyway the 
> > > > > problem was pm-utils on Fedora 10:
> > > > > 
> > > > > /usr/lib/pm-utils/sleep.d/55NetworkManager:
> > > > > 
> > > > >     suspend_nm()
> > > > >     {
> > > > >         # Tell NetworkManager to shut down networking
> > > > >         dbus-send --system                         \
> > > > >             --dest=org.freedesktop.NetworkManager  \
> > > > >             /org/freedesktop/NetworkManager        \
> > > > >             org.freedesktop.NetworkManager.sleep
> > > > >     }
> > > > > 
> > > > > I really don't think this is necessary (g-p-m will also do it if you 
> > > > > set the proper gconf setting.)
> > > > 
> > > > this should not be needed at all. I have systems running wpa_supplicant
> > > > and not any of the pm-utils scripts messing with it. During suspend and
> > > > later resume it indicates normally just only a new handshake with the AP
> > > > or a disconnect if the AP got out of range.
> > > > 
> > > > I think Network Manager is perfectly capable of handling state changes
> > > > from wpa_supplicant. I really do think that this hack only exists of
> > > > some broken drivers from really old kernels or for the 0.6 version of
> > > > Network Manager. Remember that Ubuntu's suspend/resume solution used to
> > > > be to unload all networking drivers on suspend.
> > > 
> > > You still want to tell NM to go to sleep so it doesn't see the
> > > disconnection from the supplicant (triggered by the driver because it
> > > was going to sleep), and thus try to reconnect, or try a different AP.
> > > Ideally NM would simply listen for signals from some power service such
> > > that we wouldn't have to have this hack, but there isn't a global power
> > > service yet on the system bus.
> > > 
> > > Furthermore, it's nice to know if we've gone to sleep or not so that we
> > > can do some optimizations on wakeup to find APs and reconnect faster.
> > 
> > actually the fastest way to re-connect is to just let wpa_supplicant do
> > it and then you don't even have to go through DHCP again if the lease
> > time is still valid. This works great if the AP is still in range.
> > 
> > What is your downside with the letting wpa_supplicant send you a
> > disconnect when the AP is out of range after resume?
> 
> Depends on the driver what the resume behavior is with the supplicant.
> But you want to alert *something* that the system is now going to sleep,
> so that it can clean up state before doing so.
> 
> The problem is that you have absolutely no idea how long the sleep will
> be.  It's at least 2 minutes with S2D, because that's how long it takes
> to write your state out to disk.  It's less with S2R obviously, but when
> you resume, there's no guarantee that you'll be in the same place.  You
> cannot assume that you will be.
> 
> If you keep trying to reconnect to the same AP, many times you simply
> won't be there and you'll spend the 10 or 20 seconds reconnecting to an
> AP miles away, time that could have been spent scanning for the AP
> that's *really* where you are.  Many people I know don't often suspend
> at the same location they resume, thus trying to reconnect hurts
> reconnection latency.
> 
> The ideal way to handle all this is to be *aware* of suspend/resume in
> the supplicant (or NM), and on resume, do a quick probe-scan or two to
> find out if the old AP is still around.  If it's not, do a full scan to
> find all APs, and then pick the best one, which is probably not the one
> you were associated with before.  Then you actually start the auth/assoc
> process with an AP you know exists.
> 
> So my point is that *something* needs to be aware of the suspend/resume
> at a userlevel, whether it's NM or the supplicant doesn't really matter
> as long as you can do what I describe above on resume.

since mac80211 gets suspend/resume support, I think it is the best that
we signal this to wpa_supplicant. In that case it can do the hard work
here. Either it re-connects to the last AP or signals a disconnected
state or trigger scanning.

Having the suspend scripts to tell NM to disconnect is just not a good
solution and especially in the embedded world this is a broken design
concept.

Regards

Marcel


