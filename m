Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39797 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYLXHPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 02:15:25 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Marcel Holtmann <marcel@holtmann.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	mabbaswireless@gmail.com
In-Reply-To: <20081224054951.GA32398@hash.localnet>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
Content-Type: text/plain
Date: Wed, 24 Dec 2008 08:16:29 +0100
Message-Id: <1230102989.16960.14.camel@californication> (sfid-20081224_081534_551626_74B015DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

> > > Running pm-suspend from pm-utils directly also triggers the problem, 
> > > so that would seem to excuse gnome-power-manager at least.
> > 
> > What's the status of this? Should I look into things a bit?
> 
> Well, I guess I should have noticed this a lot earlier, but anyway the 
> problem was pm-utils on Fedora 10:
> 
> /usr/lib/pm-utils/sleep.d/55NetworkManager:
> 
>     suspend_nm()
>     {
>         # Tell NetworkManager to shut down networking
>         dbus-send --system                         \
>             --dest=org.freedesktop.NetworkManager  \
>             /org/freedesktop/NetworkManager        \
>             org.freedesktop.NetworkManager.sleep
>     }
> 
> I really don't think this is necessary (g-p-m will also do it if you 
> set the proper gconf setting.)

this should not be needed at all. I have systems running wpa_supplicant
and not any of the pm-utils scripts messing with it. During suspend and
later resume it indicates normally just only a new handshake with the AP
or a disconnect if the AP got out of range.

I think Network Manager is perfectly capable of handling state changes
from wpa_supplicant. I really do think that this hack only exists of
some broken drivers from really old kernels or for the 0.6 version of
Network Manager. Remember that Ubuntu's suspend/resume solution used to
be to unload all networking drivers on suspend.

Regards

Marcel


