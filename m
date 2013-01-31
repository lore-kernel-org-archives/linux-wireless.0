Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3AaNdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:33:43 -0500
Message-ID: <1359639241.8415.17.camel@jlt4.sipsolutions.net> (sfid-20130131_143348_032228_424B84AA)
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH
 response
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Date: Thu, 31 Jan 2013 14:34:01 +0100
In-Reply-To: <5107D5D5.3070601@lri.fr>
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
	   <1355146824-25012-2-git-send-email-antonio@open-mesh.com>
	   <1356706268.9922.23.camel@jlt4.sipsolutions.net>
	   <20130102063255.GA27676@open-mesh.com> <50E400A7.5060100@lri.fr>
	   <20130107114048.GH27589@ritirata.org> <50EACA95.8040004@lri.fr>
	  <1359151524.4655.37.camel@jlt4.sipsolutions.net> <5103C774.4080403@lri.fr>
	 <1359459469.8108.11.camel@jlt4.sipsolutions.net> <5107D5D5.3070601@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 14:59 +0100, Nicolas Cavallari wrote:

> > I think that would make sense. However, to really implement that it
> > seems that wpa_s should be able to control the in-kernel station
> > "authenticated" state, not just "authorized" state?
> 
> Theoritically, yes. However, i don't remember that the "authenticated" state actually
> changes anything in IBSS mode. In fact, with the current code, all stations have the
> "authenticated" state, whatever the specified parameters and even when the kernel
> initiates an open system authentication.

Good point, so there's not really a reason to manage this at all.

> > What's the status we have today in the kernel, without the patches, and
> > what would that "revert" mean?
> 
> Right now, all IBSS stations have the "authenticated" flag.
> 
> If userspace is subscribed to auth frames, userspace have to handle everything, else, if
> userspace is not subscribing to auth frames:
> - When detecting a new station, the kernel sends an open system auth request, as part of
> node reboot detection.
> - When the kernel receives an open system authentication request, it destroys the station
> and recreates it as part of node reboot detection. If all goes well, it answers it.
> - wpasupplicant uses the NEW_STA and DEL_STA events to maintain a list of stations. It
> starts RSN handshakes on NEW_STA, and destroy its state on DEL_STA. Eventually, if
> handshakes succeeds, wpasupp authorize the stations with SET_STA (i think). much older
> wpasupplicant do not support authorizing stations, so the kernel always authorize stations
> (but all their unencrypted frames will be dropped until wpasupp configures a PTK after a
> successful handshake).
> 
> The revert is just my personal taste, but in the case where userspace does not subscribe
> to auth frames, i would just make the kernel answer an open system authentication request
> if it receives one, and not send any open system auth by itself. That would mean no reboot
> detection unless userspace does it. wpasupplicant would maybe need a way to reset the
> kernel's sta_info if not already possible.

That seems reasonable. Actually there's no reason for wpa_s to "reset
the [...] sta_info", all it really has to do is set it to unauthorized
if it detects it was rebooted, and then start key negotiation again, I
think?

> > What changes could we make today to solve this in a way that's
> > compatible with today's wpa_supplicant (and maybe Will's SAE
> > implementation, though maybe he wouldn't mind small changes too much)?
> 
> Will's SAE will not be affected by any of this, as it's done in userspace by subscribing
> to auth frames. If Will need node reboot detection, he has to do it himself.

Makes sense.

> If we want a working node reboot detection with the current wpasupplicant, we need, in
> IBSS mode, to only make the kernel send NEW_STA when a station is authenticated. There's
> not much choice here.
> 
> If it's acceptable to not have node reboot detection with current wpasupplicant, we could
> make a future wpasupplicant add a flag saying it supports the new IBSS_STA event, and the
> kernel would only do reboot detection in this case.

I think that's acceptable, but if it requires a wpa_s change anyway we
could just implement reboot detection there instead of adding all these
new events etc.? I.e. rather than having a new supplicant say "OK I will
listen to the right event when handling reboot detection", it could just
use the existing infrastructure and implement it itself?

johannes

