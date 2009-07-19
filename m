Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3752 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZGSUcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 16:32:17 -0400
Date: Sun, 19 Jul 2009 16:31:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Using compat-wireless w/ 2.6.27.26
Message-ID: <20090719203150.GA9972@hash.localnet>
References: <4A612514.4050708@redfish-solutions.com> <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com> <4A635E04.4050204@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A635E04.4050204@redfish-solutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 19, 2009 at 10:55:16AM -0700, Philip A. Prindeville wrote:
> Bob Copeland wrote:
> > On Fri, Jul 17, 2009 at 9:27 PM, Philip A.
> >> + iw dev wlan0 interface add ap0 type managed
> >> + ip link set ap0 up
> >> + iw dev ap0 connect xxxx
> >> command failed: Operation not supported (-95)
> > 
> > Why are you adding another interface?  Should be able to use "iw dev wlan0..."
> 
> Because I might want to run two access points (two SSIDs, anyway) on the same
> radio...  one with WEP on one VLAN (for Wifi SIP handsets), and one with
> WPA-PSK2 on another VLAN (for laptops, etc).

Hmm, I don't know if it matters, but you were creating it as a managed
interface.  Anyway I don't believe ath5k supports that yet - ath9k might.
Someone on ath5k-devel was porting the ath9k virtual wiphy stuff to
ath5k but I haven't heard anything recently.

> But, if you think there's still a doubt, what to look for in the modinfo?

If it says "depends: mac80211,cfg80211,ath" then it is probably the right
one.  It just sounds like this bug:

http://bugzilla.kernel.org/show_bug.cgi?id=12315

The fix was merged after 2.6.30, IIRC, but it should definitely be in
compat-wireless.  Also check your modules directory for an old ath5k.ko
sitting in drivers/.../wireless/ath5k.  It should now be in ath/ath5k.

HTH!

-- 
Bob Copeland %% www.bobcopeland.com

