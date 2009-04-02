Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZDBS6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 14:58:21 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238698084.7630.3.camel@johannes.local> (sfid-20090402_204842_882765_82560824)
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local> <49D5018E.6050001@lwfinger.net>
	 <1238696967.6137.5.camel@johannes.local> <49D506FE.5070405@lwfinger.net>
	 <1238698084.7630.3.camel@johannes.local>
	 (sfid-20090402_204842_882765_82560824)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oVkiUlwz3KiXsX+tFOA0"
Date: Thu, 02 Apr 2009 20:57:47 +0200
Message-Id: <1238698667.7630.7.camel@johannes.local> (sfid-20090402_205824_088630_A59B9DFB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oVkiUlwz3KiXsX+tFOA0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 20:48 +0200, Johannes Berg wrote:
> On Thu, 2009-04-02 at 13:42 -0500, Larry Finger wrote:
> > Johannes Berg wrote:
> > >=20
> > > Also, if increasing that helps, does it also work then? I mean, does =
the
> > > LED get turned on/off?
> >=20
> > No. I'm still not getting the appropriate call to the set brightness ca=
llback.
> > Actually, I didn't expect any change as the truncation from the too-sho=
rt array
> > length only occurs when the pseudo file is dumped.
>=20
> Hmm. In my tree TRIG_NAME_MAX is only used when you try to /write/
> something to the trigger sysfs file, so that garbling and the patch
> don't make much sense to me. There must be some other weirdness going
> on.

Could you try something for me?

In drivers/leds/led-triggers.c in led_trigger_show you have

        list_for_each_entry(trig, &trigger_list, next_trig) {
+		printk(KERN_DEBUG "available trigger: %s\n", trig->name);
                if (led_cdev->trigger && !strcmp(led_cdev->trigger->name,
                                                        trig->name))
                        len +=3D sprintf(buf+len, "[%s] ", trig->name);
                else
                        len +=3D sprintf(buf+len, "%s ", trig->name);
        }

could you do the modification, with a kernel that has the TRIG_NAME_MAX
set to 50, and see what it prints? I'm completely confused by this
failure mode since the garbage you get is actually put into brackets, so
it seems the strcmp() is returning 0 which seems odd.

johannes

--=-oVkiUlwz3KiXsX+tFOA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1QqoAAoJEKVg1VMiehFY6g0P/0TeVtpzXWqvKWKtEGcyY4F5
m3ttpiuEGNP/qh8+gw9WJ1vpB6eh9mYOVEsq3Use7izhhpLn36T+R+q7RHqGIW0S
TUHCPr4PJeECyBWZCq972UD0dKAzYkZYGgZgDdiretwyJdamh+JJTZYvcV1ovY87
+KjN96z8jl2V+i6upb34UND9Pt3vCx2QbmZ8WRy48UY5Wlee55NgK704zBW2xYDm
e4S1ZdVjK9/k0vSFUdK+AZH0rqNDgsW/1E4i6uxvr24hYoKpIODBf+Y4KqFk5OJj
qHIhvJ2bJMWOoffFXzmb3oP5SSIIjIoOiPWd28ALC3qQML459TiIfXz7Wv6ApUsU
gUJmO/nDqnSZfZaKJhx01Q4C4KxrhXfvX5oWXcnzsmnBe6lvuYDtrAeSZZZRVWAb
Hngaeeft9Wg4CyCYQ0FidlQJU4dfgPxYPdjs/JGk/nAslhHYD+lUsuttjNrVkPAB
6D97xxp6eUQBcuvM+mX3qWLdVOpI11/OrvnC0RA9Nmd70+GmjjmC8t75z+XIaEqe
wrML6EAwZdM5ni5GzwoDcPbdsJbdvWTyVg6j2S4huvdrJG3ZuCzRfygZAt0vdmAi
Xdtp8hosaL7NVA5T2lIjB7tQbKDUWLjwxM+LuKYcZmhy+qQI214oHnja4uUqeWL8
7f/iU5dIv4ftCtjt/AFm
=gegD
-----END PGP SIGNATURE-----

--=-oVkiUlwz3KiXsX+tFOA0--

