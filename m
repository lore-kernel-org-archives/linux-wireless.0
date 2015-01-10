Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:33639 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbbAJQ0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2015 11:26:32 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	stable@vger.kernel.org
Subject: Re: Re: [PATCH] ath9k: ignore radar PHY errors when DFS is not enabled
Date: Sat, 10 Jan 2015 17:26:26 +0100
Message-ID: <2179820.H2CYa3nAla@prime> (sfid-20150110_172636_266990_D09C4242)
In-Reply-To: <54B024A1.4040809@broadcom.com>
References: <1420822458-531-1-git-send-email-sw@simonwunderlich.de> <54B024A1.4040809@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1801107.alIDg1nCx7"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1801107.alIDg1nCx7
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

On Friday 09 January 2015 19:57:37 Arend van Spriel wrote:
> On 01/09/15 17:54, Simon Wunderlich wrote:
> > Performing spectral scans on 5 GHz channels may result in PHY errors
> > sent by the hardware, even if DFS support is not enabled in the driver
> > (e.g. channel scanning or passive monitoring). In that case channels may
> > falsely get marked as 'unusable'. To fix that, only process radar PHY
> > errors when radar is explicitly enabled in the driver.
> 
> Hi Simon,
> 
> Not an ath9k expert, but I would think those channels would already be
> marked as unusable, because DFS is disabled in the driver. Or does this
> also affect 5G channels that do not require DFS.
> 
> Regards,
> Arend

Hey Arend,

maybe that was not really clear, but this is talking about the DFS state 
"unusable". By default, channels are marked in DFS state "usable", and after 
the clear channel assessment (which is done e.g. when starting AP mode) they 
are marked as "available". As soon as radar is detected they are marked as 
"unusable".

These DFS state changes should only happen while there is something operating 
with radar enabled, e.g. AP mode. It should not happen if we just have monitor 
mode or scan for channels. These channels should then stay in their previous 
DFS state (e.g. 'usable'). This was borked and this patch tries to fix it. :)

Cheers,
     Simon
--nextPart1801107.alIDg1nCx7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSxUrQACgkQrzg/fFk7axYWhwCg5e7HjO0eXyIr3QEUCBzQKDtD
6skAn2oiJ6MN9yg27RW//IiOS1dRuyq8
=gNBG
-----END PGP SIGNATURE-----

--nextPart1801107.alIDg1nCx7--

