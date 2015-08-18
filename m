Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33943 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbbHRJik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 05:38:40 -0400
Received: by wicne3 with SMTP id ne3so95444179wic.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 02:38:38 -0700 (PDT)
From: Sven Eckelmann <sven@open-mesh.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	simon@open-mesh.com, Marek Lindner <marek@open-mesh.com>
Subject: Re: CT ath10k firmware now supports IBSS + RSN
Date: Tue, 18 Aug 2015 11:38:33 +0200
Message-ID: <4035168.MK6Xi4n7uL@bentobox> (sfid-20150818_113852_355096_2A268CD2)
In-Reply-To: <55D1FEB2.4060205@candelatech.com>
References: <55285D8D.6070703@candelatech.com> <1701816.PemaYpqoq5@bentobox> <55D1FEB2.4060205@candelatech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart16744776.4JOd2HK7IN"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart16744776.4JOd2HK7IN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 17 August 2015 08:33:06 Ben Greear wrote:
[...]
> >  * IBSS/RSN isn't working between ath10k<->ath10k, ath9k<->ath10k
> >    (works well between ath9k<->ath9k)
> >    - the ath10k device doesn't seem to send its broadcast frames
> >      after the handshake finished (ath9k already tries to transmit
> >      bcast frames)
> >    - also doesn't work with firmware-2-ct-non-commercial-full-14.bin
> >      and nohwcrypt=1
> 
> I believe I had ath10k to ath9k + RSN work, but I did see problems with ath10k-ath10k + RSN.

Yes, this was what I was reading in a different mail and also the reason
why I've tried to get it working for ath9k<->ath10k. But unfortunately,
I had no success.

I have also tried to use your config without the overrides and with
overrides without any success.

> I think sometimes it worked a bit, and then stopped.  Truth is, my customers
> interested in IBSS are not doing encryption on the IBSS interface, so I have no plans to work on this
> soon.  And, even if offered the opportunity, I'm not sure what I could do to
> improve the problem.  Possibly someone at QCA would have ideas and might share
> them with me...
> 
> 
> >  * IBSS stops working everytime an AP interface is added to the same
> >    PHY (it isn't importing whether it is using WPA/WPA2 or configured
> >    as open AP)
> >    - tested again with ath9k on the same OpenWrt version and it
> >      working quite well with 1x IBSS + 2x AP
> 
> One of my customers is using AP + IBSS interface with no obvious problems
> related to concurrency.  But, maybe they are doing things in a different
> order.  Does it work for you if you bring up AP first and then add IBSS?
> 
> This is likely fixable.

I had to hack a little bit of OpenWrt away but it seems that it works for
a simple setup to first create the adhoc interface and then sometimes later
add the AP interface.

[...]

Thanks for your feedback.

Kind regards,
	Sven
--nextPart16744776.4JOd2HK7IN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJV0v0cAAoJEF2HCgfBJntG+9IQAL1Qmy4DV3vpyRv1fatSFquP
qCPTzZpb5Fn7Dr41J3HA8y2geE5jHX4UsXDlnz+i6jtkcfanXfPDjOw4RPkHeh28
hWAlLlwgRaU+6Rm9bsPsuo2Vdf4ZkgHRToHZ56hZGwPaTvUXReNEYPL7VO0q/iJB
+1hr54L0G+j4JCWYMGUjTahyChA2lMJFP8dxM6QOWZah/gLn3hcwYfpCAWh9fVME
b840s6N1yjKHQb44EMe4NENxBr85zDQZNuJoooYK1/WFHmUAOo4s7GtKDGfCyQTQ
T/PoivNcqPATTp3AsHeqVwjgcFDMzlEGk62oItoZYXSWGXX55GImsfSuBA+4JAVb
LRho2eqn1Y4SmmkYkMK1J9AOMhn/8c+xjRiQe6jz1L+n4wsz5nyNKYsmLlqCwJnL
9gLQKkW9toueOqIRCwTzYmighmZDGFFNlxUfwFDvKcCUGsrfoxKNIqWPnajblcCz
m1f9TVBXNk1kxkrz0QTEkeDtE6MaBGOMI3GmcExlrIpCM0i/CnkWeGOa46cW404k
ihMG2385i7ypoo6WLvHLPZaeOEwt713psvG/mBhpL/1lZSqNXnG0XBo+4bQ6QlUG
1vb0vhROthcbSjh76GAUMR5cjF+51G2RWSjTQeR07+enAod0uh/HvUyKl0ksVgNb
Ur/LDPrLTh75+FAvbeUD
=mtom
-----END PGP SIGNATURE-----

--nextPart16744776.4JOd2HK7IN--

