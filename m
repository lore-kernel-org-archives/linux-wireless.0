Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38146 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbZEYHwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 03:52:12 -0400
Date: Mon, 25 May 2009 10:51:46 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] libertas: fix WPA adhoc network creation
Message-ID: <20090525075146.GA20673@jm.kir.nu>
References: <1243037398.2495.14.camel@localhost.localdomain> <1243067061.4606.43.camel@johannes.local> <1243171190.24236.1.camel@localhost.localdomain> <1243185886.29222.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243185886.29222.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 24, 2009 at 07:24:46PM +0200, Johannes Berg wrote:
> On Sun, 2009-05-24 at 09:19 -0400, Dan Williams wrote:
> > On Sat, 2009-05-23 at 10:24 +0200, Johannes Berg wrote:
> > > On Fri, 2009-05-22 at 20:09 -0400, Dan Williams wrote:
> > > > Oddly enough, the firmware's JOIN/START commands don't appear to have
> > > > any facility for setting custom IEs, thus the started adhoc network
> > > > doesn't advertise its WPA capability in the beacon.  Whee!
> > > 
> > > We don't even properly support WPA IBSS in mac80211...
> > 
> > Hmm, I support creating WPA-PSK adhoc networks in the NM UI (worked last
> > summer when I added the code), can you give a 10 second summary of
> > what's missing here?
> 
> Hm, well, Jouni says it doesn't play well with XP or Vista and we don't
> have per-station group keys we'd need in theory.

Please note that "WPA IBSS" and "RSN IBSS" are two quite different
beasts. WPA (as in the old v1 before IEEE 802.11i was finished)
introduced a WPA-None mode in which there is actually no key management
and the TKIP (or CCMP) key is pre-configured on the stations. This
interoperates to more or less the extent possible (the mode itself is
not really very nice design taken into account the replay protection and
no mechanism to deliver current packet number). I do not know how
strictly various implementations require the WPA IE to be in the Beacon
frames for WPA IBSS/WPA-None to work.

RSN IBSS (the mechanism introduced in the IEEE 802.11i-2004 and in
theory, included in WPA2, but not really interop tested that much)
includes full authentication and key management step similarly to the
managed AP--station case. This is likely to require the Beacon and Probe
Response frames to include the correct RSN IE.

I haven't tested RSN IBSS with XP (and don't even know a driver that
would support it there), but as far as brief tests with Vista are
concerned, there seemed to be some interop issues in the 4-way
handshake. Anyway, we do not yet have the needed support for this in
mac80211 (per-STA GTK/group key).

-- 
Jouni Malinen                                            PGP id EFC895FA
