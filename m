Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:44936 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756488AbcIGIXV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 04:23:21 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Sven Eckelmann <sven@narfation.org>,
        linux-wireless@vger.kernel.org,
        Pannirselvam Kanagaratnam <pannirk@gmail.com>
Subject: Re: Debugging RTL8192CU firmware loading on 3.12 powerpc
Date: Wed, 07 Sep 2016 10:23:17 +0200
Message-ID: <1551808.YAuhaNDynd@prime> (sfid-20160907_102325_730021_BD8BDDAC)
In-Reply-To: <1d72a2ac-03e7-37d8-c367-68413595443e@lwfinger.net>
References: <1586991.4QUcrJhXOm@prime> <2186338.AojtHidiB8@bentobox> <1d72a2ac-03e7-37d8-c367-68413595443e@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2001628.zh0oPaokVt"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2001628.zh0oPaokVt
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, September 6, 2016 8:29:32 AM CEST Larry Finger wrote:
> On 09/06/2016 08:09 AM, Sven Eckelmann wrote:
> > On Dienstag, 6. September 2016 09:40:41 CEST Sven Eckelmann wrote:
> >> On Freitag, 2. September 2016 12:53:28 CEST Larry Finger wrote:
> >> [...]
> >> 
> >>> The patch I included in my previous E-mail, and attached here,  does get
> >>> the firmware loaded correctly. There is still a problem that prevents
> >>> authentication. I'm still looking for that issue.
> >> 
> >> Thanks for the fast update. I am currently testing your patch. It looks
> >> like the initial error is now gone. The hostapd also starts but
> >> beaconing doesn't seem to work at all (no error from the kernel/hostapd
> >> but the device is not sending anything). I am currently checking how
> >> beaconing is supposed to work in your driver. Maybe I will spot
> >> something useful.> 
> > Yes, found something similar in the checksumming algorithm. See the
> > attached patch for details.
> 
> Just for the record, this is not "my" driver. It was provided by Realtek. My
> contribution has only been to clean it up.
> 
> Thanks for the patch. I too had found that checksum code, but I had not sent
> it as there are still problems on BE machines. These difficulties are
> running the NIC in STA mode. I have not tried AP mode. Scan data seem to be
> read OK, but it never authenticates. I do not know if there are further
> errors in setting up the transmit buffer, or if the problem is in the
> encryption/decryption code. I'm still looking.

just as a connected question here - do you know if those devices support 
MultiSSID? The capabilities currently don't allow that, but I'm wondering if 
that could be implemented, or if there are any hardware/firmware limitations?

Thanks,
      Simon
--nextPart2001628.zh0oPaokVt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJXz851AAoJEKEr45hCkp6hE+MQALq5eHE3Kp+SQKufNDQCgyd4
jY/k8YpSjyMtw1iB1t36P6T/9lLOHPwl+R57sSqvxrA1gfL7ygyu9oMlwTcmmEqC
ibLyGjUnj1bUpzaPxXQBZeFoXLKX0BJEEPEsVXkA7cYZ6pVW/c+5UrmS9Kt+C4Hv
Yohf9dpicU+nIri4s6GNbRpcrehLArNPTB/Bb+SXsQS7jeIAY9VxixoSAMLishC7
J5qv24vibr9W8qhjxnl4JCJZnLsZpVFljVC4Sf6PnLkcC0s/bV0y37A+p9zg23me
dun2CDX8rWyH4BX7fBYkSRGm1wug9n7ICOSfi6khn/7CH9yQP/TzWheSKGC22IcW
uYG6TW/uQ6K7nooNVkYaht5+7SPsLN7fV50LCSvcmZY5ch2yeJi3XnoXOP4Lkehp
Boh0mMvsyH5NN3c4AqyIH3KO9rdinWsKc36A0pAT2jYJnwKf2c6aHvCaQIAyRSiH
Jq/xX27IhqXhQV1YjsEWGXJHC0jjOXFj4beHZ9Ukzyx0iJ+bx/2D6rGQbXBWQ+8+
JUB1xjsFrpi2n8OPwSIn71bX3Mi0TFQS+L6AchnXC75UO3XNpMATedC3plxuyyJf
C6LlIMZgwGMqEqD5FFw085J5Zm2v37VbOVgY+QeGLJFvu42ybLw/urWtgRrcoqqI
3VCjupZOp32FGYceOJfl
=hMXn
-----END PGP SIGNATURE-----

--nextPart2001628.zh0oPaokVt--
