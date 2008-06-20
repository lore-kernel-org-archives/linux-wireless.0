Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47784 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbYFTNHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 09:07:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 suspend gotchas
Date: Fri, 20 Jun 2008 15:07:28 +0200
Cc: linux-wireless@vger.kernel.org
References: <1213966018.8967.176.camel@johannes.berg>
In-Reply-To: <1213966018.8967.176.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806201507.29030.mb@bu3sch.de> (sfid-20080620_150801_801180_35BC284F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 June 2008 14:46:58 Johannes Berg wrote:
> Hi driver authors :)
>=20
> I suggest you guys get together and write some proper suspend support
> for mac80211. We can discuss in Ottawa, but I just wanted to let you
> know that I just ran into this:
>=20
> [...]
> [55292.062873] adb: starting probe task...
> [55292.063012] adb: finished probe task...
> [55292.502871] wlan0: No ProbeResp from current AP 00:1a:2a:2c:a2:c5 =
- assume out of range
> =EF=BB=BF[55292.502883] phy2: Removed STA 00:1a:2a:2c:a2:c5
> [55292.562874] mac80211-phy2: failed to remove key (0, 00:1a:2a:2c:a2=
:c5) from hardware (-19)
> [55292.563229] phy2: Destroyed STA 00:1a:2a:2c:a2:c5
> [55292.768591] hda: host max PIO4 wanted PIO255(auto-tune) selected P=
IO4
> [55292.776295] hda: UDMA/100 mode selected
> [55292.777058] ide-cdrom 1.0: resuming
> [55292.779026] hdc: host max PIO4 wanted PIO255(auto-tune) selected P=
IO4
> [55292.779210] hdc: MWDMA2 mode selected
> [55292.779533] therm_adt746x 8-002e: resuming
> [55292.779548] b43 ssb0:0: resuming
> [55292.779552] b43-phy2 debug: Resuming...
> [...]
>=20
> As you can see, mac80211 "noticed" that the AP was "out of range",
> probably because it sent a probe request just before or during
> suspending and the time till now was about an hour.
>=20
> We _really_ need to tie mac80211's workqueues and everything to the
> hardware so we don't try to do these things before the driver resumes=
=2E

Yeah I agree.

However, currently wpa_supplicant will notice the connection loss right
after resume and scan for APs and connect, for me.

> I don't even know if b43 keeps hardware keys across suspend

It doesn't.

> This is not a hard problem to solve.

>  - suspend does, in this order (callback used):
>     * stop aggregation (ampdu_action)
>     * remove all keys (set_key)
>     * remove all STAs (sta_notify)
>     * remove all interfaces (remove_interface)
>     * stop the hardware (stop)

I think the hardware-stop should probably be done in the driver
suspend routine after the mac80211 notification and not by a mac80211 c=
allback.
Otherwise this is going to get complicated wrt locking.

--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
