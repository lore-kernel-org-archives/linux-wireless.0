Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betty.cbit.net.au ([202.55.154.10]:52085 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933671AbXCQGPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 02:15:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.cbit.net.au (Postfix) with ESMTP id 6D66A108069
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 17:15:09 +1100 (EST)
Received: from mail.cbit.net.au ([127.0.0.1])
	by localhost (betty [127.0.0.1]) (amavisd-new, port 10024) with LMTP
	id 22757-01-14 for <linux-wireless@vger.kernel.org>;
	Sat, 17 Mar 2007 17:15:08 +1100 (EST)
Received: from keitarou.bubblesworth.net (unknown [202.55.155.91])
	by mail.cbit.net.au (Postfix) with ESMTP id 312AD1080AD
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 17:15:08 +1100 (EST)
Date: Sat, 17 Mar 2007 17:15:02 +1100
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: linux-wireless@vger.kernel.org
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci code
Message-ID: <20070317061502.GA5954@keitarou>
References: <20070317034607.GA1522@keitarou> <200703170037.14875.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
In-Reply-To: <200703170037.14875.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 17, 2007 at 12:37:10AM -0400, Michael Wu wrote:
> On Friday 16 March 2007 23:46, Paul TBBle Hampson wrote:
>> The (built-in) bcm43xx-mac80211 driver works, but when I try to load a
>> CardBus Atheros card I've got lying around with dadwifi-openhal, it
>> fails with some sort of hardware error.  (ie. it _might_ be a dodgey
>> Cardbus port, although both cardbus cards used to work in this machine,
>> using prism54 hardmac and the dadwifi with atheros hal driver
>> respectively)

> Can you rule out the port first? Load the fullmac driver first, bring it =
up &=20
> down, unload it, and then try p54.

OK, with the current prism54 as it appears in wireless-dev:
Mar 17 16:32:41 su kernel: pccard: CardBus card inserted into slot 0
 ] modprobe prism54
Mar 17 16:33:04 su kernel: Loaded prism54 driver, version 1.2
Mar 17 16:33:04 su kernel: PCI: Enabling device 0001:11:00.0 (0000 -> 0002)
Mar 17 16:33:04 su kernel: prism54: pci_set_mwi(pdev) succeeded
 ] ifup prism54-0 (fires up wpa_supplicant and tries to associate to local =
WPA AP)
Mar 17 16:33:54 su kernel: prism54-0: resetting device...
Mar 17 16:33:54 su kernel: prism54-0: uploading firmware...
Mar 17 16:33:54 su kernel: prism54-0: firmware version: 1.0.4.3
Mar 17 16:33:54 su kernel: prism54-0: firmware upload complete
Mar 17 16:33:54 su kernel: prism54-0: interface reset complete
Mar 17 16:33:55 su kernel: prism54-0: WPA IE Attachment was set
Mar 17 16:34:05 su kernel: prism54-0: no IPv6 routers present
Mar 17 16:34:08 su kernel: prism54-0: WPA IE Attachment was set
Mar 17 16:34:21 su kernel: prism54-0: WPA IE Attachment was set
Mar 17 16:34:34 su kernel: prism54-0: timeout waiting for mgmt response 300=
, triggering device
<repeat last two lies x 3>
Mar 17 16:35:14 su kernel: prism54-0: mgt_commit_list: failure. oid=3D19000=
004 err=3D1
Mar 17 16:35:14 su kernel: prism54-0: mgt_commit: failure
Mar 17 16:35:14 su kernel: prism54-0: WPA IE Attachment was set
<repeat last three lines>
Mar 17 16:35:30 su kernel: prism54-0: timeout waiting for mgmt response 300=
, triggering device
Mar 17 16:35:30 su kernel: prism54-0: mgt_commit_list: failure. oid=3D19000=
004 err=3D1
Mar 17 16:35:30 su kernel: prism54-0: mgt_commit: failure
Mar 17 16:35:30 su kernel: prism54-0: WPA IE Attachment was set
<repeat these four lines a lot>
Mar 17 16:37:40 su kernel: prism54-0: timeout waiting for mgmt response 300=
, triggering device
Mar 17 16:37:40 su kernel: prism54-0: timeout waiting for mgmt response 270=
, triggering device
Mar 17 16:37:40 su kernel: prism54-0: timeout waiting for mgmt response 240=
, triggering device
Mar 17 16:37:40 su kernel: prism54-0: timeout waiting for mgmt response 210=
, triggering device
Mar 17 16:37:41 su kernel: prism54-0: timeout waiting for mgmt response 180=
, triggering device
Mar 17 16:37:41 su kernel: prism54-0: timeout waiting for mgmt response 150=
, triggering device
Mar 17 16:37:41 su kernel: prism54-0: timeout waiting for mgmt response 120=
, triggering device
Mar 17 16:37:41 su kernel: prism54-0: timeout waiting for mgmt response 90,=
 triggering device
Mar 17 16:37:41 su kernel: prism54-0: timeout waiting for mgmt response 60,=
 triggering device
Mar 17 16:37:41 su kernel: prism54-0: timeout waiting for mgmt response 30,=
 triggering device
Mar 17 16:37:41 su kernel: prism54-0: timeout waiting for mgmt response
<repeat above lines again>
Mar 17 16:37:51 su kernel: prism54-0: mgmt tx queue is still full
<lots of these until I shut down the interface>
Mar 17 16:39:25 su kernel: prism54-0: islpci_close ()

Bleh, that doesn't look healthy.

 ] rmmod prism54
Mar 17 16:43:26 su kernel: prism54-0: removing device
Mar 17 16:43:26 su kernel: Unloaded prism54 driver

Then, with the p54 code, patched with the patch you attached.

 ] modprobe prism54pci
Mar 17 16:48:56 su kernel: p54: LM86 firmware
Mar 17 16:48:58 su kernel: 0001:11:00.0 (prism54pci): Cannot read eeprom!
Mar 17 16:48:58 su kernel: prism54pci: probe of 0001:11:00.0 failed with er=
ror -22

Hmm, I guess the patch fixed the BUG_ON. ^_^

Removing the modules produced nothing in the kernel log.

 ] eject card
Mar 17 16:51:14 su kernel: pccard: card ejected from slot 0

Excellent. So that's fixed the BUG_ON and the hard lock.

Still fails to read an eeprom from my card though. I'm wondering if the cra=
pspew
=66rom the prism54 driver implies card or socket badness?

However, the hardmac driver is able to get a MAC address (with an OID query,
according to the code) and the MAC address is correct: 00:60:64:03:41:81

Is it worth dumping the purported eeprom to see if it's actually a valid
eeprom in a format unexpected by the code? (The card is very old now...)

>> (Albeit the hardmach driver never managed to WPA, and as of 2.6.20 still
>> doesn't, haven't tried the version in wireless-dev yet)

> Hardmac version in wireless-dev is the same thing. wireless-dev is just f=
or=20
> mac80211 and cfg80211 code.

Ah, right. The changes I'm seeing are post-2.6.20 changes in linus'
tree. I rebuilt my prism54 module with them for the above.

>> So maybe the BUG isn't a problem with the p54 driver, but I'd appreciate
>> help with making it find the eeprom so it doesn't happen...
> I just found a leak in a probe error path. It might somehow cause the pro=
blem=20
> in the pci code. I've attached a patch to fix it.

> Thanks,
> -Michael Wu

> p54pci: Fix error path when eeprom read fails

Patch applied offset 11 lines...

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

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+4dmexDuohKLFuARArQNAJ9cwk05EEtR/t83kL7OTJ/M+NNx8gCgx2aO
hYziso3lkj76LBYj6lQR7FQ=
=TUg4
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
