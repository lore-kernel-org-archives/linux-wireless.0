Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from seehuhn.de ([80.68.93.199]:1733 "EHLO seehuhn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbXH2IMp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 04:12:45 -0400
Date: Tue, 28 Aug 2007 23:27:15 +0100
From: Jochen Voss <voss@seehuhn.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: which hostapd version for which wireless driver
Message-ID: <20070828222714.GA21719@seehuhn.de>
References: <20070827223833.GA15515@seehuhn.de> <1188291275.7837.72.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
In-Reply-To: <1188291275.7837.72.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[ sorry if you get this twice, my first attempt did not seem to have made
  it to the list ]


Hi Johannes,

On 28 Aug 2007, at 09:54, Johannes Berg wrote:
>> Any help about which combinations of hostapd and device driver have at
>> least a chance of working together would be more than welcome.
>
> Both git trees (wireless-dev and hostapd) work fine together :)

Ok, it works now for me.  Knowing which of the many combination to play
with
helped to focus my efforts.  Thanks a lot for your help.

>> *** Netgear WG511 (prism54) ***
>>
>> I tried the following drivers:
>>
>> 5) CONFIG_P54_PCI in the latest wireless-dev
>
> I don't think that supports AP mode.
>
>> 6) PRISM54 in the lates wireless-dev
>> 7) PRISM54 in 2.6.23-rc3
>> 8) PRISM54 in 2.6.22.5
>
> Nor do those, HOSTAP driver is the one you'd want here, along with the
> hostap hostapd driver.

I tried this only shortly, but I am not so sure about this one.  The hostap
driver states that it is for "Prism 2/2.5/3 wlan cards".  Isn't there a
difference between this and prism54?

>>     root@funk [~] iwconfig wlan1 mode master
>>     root@funk [~] iwconfig wlan1 essid "SR20"
>>     root@funk [~] iwconfig wlan1 channel 6
>>     root@funk [~] iwconfig wlan1 rate 11M
>>     root@funk [~] ifconfig wlan1 up
>
> Don't do any of that, hostapd configures everything.

Ok, it does now.  My problem turned out to be the "hw_mode=b" in the config
file.  When I use "hw_mode=g" instead, everything suddenly starts to work
:-)

Many thanks,
Jochen
--
http://seehuhn.de/

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG1KFCf+iD8yEbECURAohSAJ9B/SPgWXvC0tHgzKzxKTpPE3HWVQCgrFXR
IpxFcV/FvyHYRcgcZqLK5d0=
=scpH
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
