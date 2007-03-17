Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betty.cbit.net.au ([202.55.154.10]:52823 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752135AbXCQGww (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 02:52:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.cbit.net.au (Postfix) with ESMTP id AC69E1080AD
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 17:52:49 +1100 (EST)
Received: from mail.cbit.net.au ([127.0.0.1])
	by localhost (betty [127.0.0.1]) (amavisd-new, port 10024) with LMTP
	id 25089-02-17 for <linux-wireless@vger.kernel.org>;
	Sat, 17 Mar 2007 17:52:47 +1100 (EST)
Received: from keitarou.bubblesworth.net (unknown [202.55.155.91])
	by mail.cbit.net.au (Postfix) with ESMTP id ADBC01080AA
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 17:52:47 +1100 (EST)
Date: Sat, 17 Mar 2007 17:52:43 +1100
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: linux-wireless@vger.kernel.org
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci code
Message-ID: <20070317065242.GB5954@keitarou>
References: <20070317034607.GA1522@keitarou> <200703170037.14875.flamingice@sourmilk.net> <1174107032.17023.14.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
In-Reply-To: <1174107032.17023.14.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 17, 2007 at 12:50:32AM -0400, Pavel Roskin wrote:
> On Sat, 2007-03-17 at 00:37 -0400, Michael Wu wrote:
>> On Friday 16 March 2007 23:46, Paul TBBle Hampson wrote:
> >> The (built-in) bcm43xx-mac80211 driver works, but when I try to load a
> >> CardBus Atheros card I've got lying around with dadwifi-openhal, it
> >> fails with some sort of hardware error.  (ie. it _might_ be a dodgey
> >> Cardbus port, although both cardbus cards used to work in this machine,
> >> using prism54 hardmac and the dadwifi with atheros hal driver
> >> respectively)

>> Can you rule out the port first? Load the fullmac driver first, bring it=
 up &=20
>> down, unload it, and then try p54.

> Oh, and I'm amazed that somebody is using dadwifi-openhal verify the
> hardware!  It's in a pretty poor shape right now.  It prints some
> warnings because it starts with channel 0.  The interface can be brought
> up if you set a valid channel, and I think it might scan.

Well, since I'm at it:
Mar 17 17:28:19 su kernel: pccard: CardBus card inserted into slot 0
	] modprobe ath_pci (dadwifi-openhal)
Mar 17 17:40:02 su kernel: ath_hal: OpenHAL loaded (AR5210, AR5211, AR5212,=
 RF5110/1/2)
Mar 17 17:40:02 su kernel: ath_pci: 0.9.4.5-dadwifi (svn r2196)
Mar 17 17:40:02 su kernel: cannot find mode element.
Mar 17 17:40:02 su kernel: cannot find mode element.
Mar 17 17:40:02 su kernel: wmaster1: Selected rate control algorithm 'simpl=
e'
Mar 17 17:40:02 su kernel: wiphy7: mac 7.9 phy 4.5 radio 5.6
Mar 17 17:40:02 su kernel: wiphy7: Use hw queue 6 for CAB traffic
Mar 17 17:40:02 su kernel: wiphy7: Use hw queue 7 for beacons
Mar 17 17:40:02 su kernel: wiphy7: : mem=3D0xf3000000, irq=3D53
	] iwconfig wlan1 channel 1
	] ifup
lots of:
Mar 17 17:40:56 su kernel: ar5k_ar5212_set_txpower_limit: changing txpower =
to 9999
Mar 17 17:40:56 su kernel: ar5k_ar5212_txpower: invalid tx power: 9999
Mar 17 17:40:56 su kernel: ar5k_ar5212_set_txpower_limit: changing txpower =
to 0
during which it:
Mar 17 17:40:55 su kernel: wlan1: starting scan
Mar 17 17:40:56 su kernel: wlan1: scan completed
Mar 17 17:40:56 su kernel: wlan1: Initial auth_alg=3D0
Mar 17 17:40:56 su kernel: wlan1: authenticate with AP 00:14:6c:ed:c1:76
Mar 17 17:40:56 su kernel: rate_control_lowest_rate - no supported rates fo=
und
Mar 17 17:40:56 su kernel: wlan1: authenticate with AP 00:14:6c:ed:c1:76
Mar 17 17:40:56 su kernel: rate_control_lowest_rate - no supported rates fo=
und
Mar 17 17:40:56 su kernel: wlan1: authenticate with AP 00:14:6c:ed:c1:76
Mar 17 17:40:56 su kernel: rate_control_lowest_rate - no supported rates fo=
und
Mar 17 17:40:57 su kernel: wlan1: authentication with AP 00:14:6c:ed:c1:76 =
timed out

	] if I ifup without iwconfig wlan1 channel 1:
Mar 17 17:28:58 su kernel: ar5k_ar5212_nic_wakeup: invalid radio frequency =
mode
Mar 17 17:28:58 su kernel: wiphy3: unable to reset hardware: 'Hardware I/O =
Error' (HAL status 2) (freq 0 flags 0x0)
	] rmmod
Mar 17 17:44:20 su kernel: ar5k_ar5212_get_isr: 0x00000000
Mar 17 17:44:20 su kernel: ath_pci: driver unloaded
Mar 17 17:44:20 su kernel: ath_hal: driver unloaded

	] modprobe ath_pci (dadwifi)
Mar 17 17:46:29 su kernel: ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF511=
1, RF5112, RF2413, RF5413, REGOPS_FUNC)
Mar 17 17:46:29 su kernel: ath_pci: 0.9.4.5-dadwifi (svn r2195)
Mar 17 17:46:29 su kernel: ath_pci: unable to attach hardware: 'Hardware re=
vision not supported' (HAL status 13)
Mar 17 17:46:32 su kernel: pccard: card ejected from slot 0
Mar 17 17:46:36 su kernel: pccard: CardBus card inserted into slot 0
Mar 17 17:46:36 su kernel: PCI: Enabling device 0001:11:00.0 (0000 -> 0002)
Mar 17 17:46:36 su kernel: cannot find mode element 0
Mar 17 17:46:36 su kernel: wmaster1: Selected rate control algorithm 'simpl=
e'
Mar 17 17:46:36 su kernel: wiphy9: mac 7.9 phy 4.5 radio 5.6
Mar 17 17:46:36 su kernel: wiphy9: Use hw queue 8 for CAB traffic
Mar 17 17:46:36 su kernel: wiphy9: Use hw queue 9 for beacons
Mar 17 17:46:36 su kernel: wiphy9: Atheros 5212: mem=3D0xf3000000, irq=3D53
	] iwconfig wlan1 channel 1
	] ifup
Mar 17 17:46:57 su kernel: wmaster1: Does not support passive scan, disabled
Mar 17 17:46:57 su kernel: wlan1: starting scan
Mar 17 17:46:58 su kernel: wlan1: scan completed
Mar 17 17:46:58 su kernel: wlan1: Initial auth_alg=3D0
Mar 17 17:46:58 su kernel: wlan1: authenticate with AP 00:14:6c:ed:c1:76
Mar 17 17:46:58 su kernel: wlan1: RX authentication from 00:14:6c:ed:c1:76 =
(alg=3D0 transaction=3D2 status=3D0)
Mar 17 17:46:58 su kernel: wlan1: authenticated
Mar 17 17:46:58 su kernel: wlan1: associate with AP 00:14:6c:ed:c1:76
Mar 17 17:46:58 su kernel: wlan1: RX AssocResp from 00:14:6c:ed:c1:76 (capa=
b=3D0x51 status=3D0 aid=3D1)
Mar 17 17:46:58 su kernel: wlan1: associated
Mar 17 17:46:58 su kernel: wlan1: CTS protection enabled (BSSID=3D00:14:6c:=
ed:c1:76)
Mar 17 17:46:58 su kernel: device wlan1 entered promiscuous mode
Mar 17 17:46:58 su kernel: audit(1174114018.835:6): dev=3Dwlan1 prom=3D256 =
old_prom=3D0 auid=3D4294967295
Mar 17 17:46:58 su kernel: audit(1174114018.835:6): arch=3D14 syscall=3D102=
 success=3Dyes exit=3D0 a0=3De a1=3D7fc42364 a2=3D1 a3=3D7fc42390 items=3D0=
 ppid=3D2278 pid=3D2284 auid=3D4294967295 uid=3D0 gid=3D0 euid=3D0 suid=3D0=
 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3D(none) comm=3D"guessnet-ifupdo=
" exe=3D"/usr/sbin/guessnet" key=3D(null)
Mar 17 17:47:00 su kernel: wlan1: duplicate address detected!

	] If I ifup without doing the iwconfig wlan1 channel 1:
Mar 17 17:34:23 su kernel: wiphy4: unable to reset hardware: '' (HAL status=
 0) (freq 0 flags 0x0)
	] modprobe -r
Mar 17 17:34:50 su kernel: ath_pci: driver unloaded
Mar 17 17:34:50 su kernel: ath_hal: driver unloaded

Sometimes, when modprobing ath_pci from the dadwifi driver:
Mar 17 17:38:42 su kernel: ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF511=
1, RF5112, RF2413, RF5413, REGOPS_FUNC)
Mar 17 17:38:42 su kernel: ath_pci: 0.9.4.5-dadwifi (svn r2195)
Mar 17 17:38:42 su kernel: ath_pci: unable to attach hardware: 'Hardware re=
vision not supported' (HAL status 13)
but usually ejecting and reinserting the card while the driver's loaded
will fix that.

So in short, the channel-0 bug is the only thing keeping dadwifi from
working like a charm for me. And that's only a udev-rule away. ^_^

Meanwhile, dadwifi-openhal won't associate.

> And if you want to use madwifi-old-openhal for the purpose of testing,
> please use today's revision, or it will corrupt memory due to incorrect
> get_order() rounding that Linus has reverted in 2.6.21-rc4 (the fix is
> not in wireless-dev.git yet).

I've got that fix in my kernel already, it makes a 512MB powermac unbootabl=
e. ^_^

However, I'm not really interested in non-mac80211 drivers right now.

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
On-hiatus Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.Com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+5A6exDuohKLFuARAsiPAJ9IDSXEM5Rjw+t0J1vimDT4aKf1UACgoGSv
9QlXd5hSAN2Lr3vp36+QgjI=
=YNTs
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
