Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173001pub.verizon.net ([206.46.173.1]:63183 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3BTShj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 13:37:39 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173001.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIJ00LGT4XGPG50@vms173001.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Wed, 20 Feb 2013 11:36:53 -0600 (CST)
Date: Wed, 20 Feb 2013 12:33:15 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless
	<linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: brcmsmac and AP mode
Message-id: <20130220173315.GK14102@odin.tremily.us> (sfid-20130220_193744_330497_EB0B19B9)
References: <1360604039.1559.44.camel@dcbw.foobar.com>
 <511940E6.7010303@hauke-m.de>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=g4MvFqI7wmANiPDo
In-reply-to: <511940E6.7010303@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--g4MvFqI7wmANiPDo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 11, 2013 at 08:05:10PM +0100, Hauke Mehrtens wrote:
> I started to add AP mode support to brcmsmac. The hardware is
> capable of all the stuff needed. At least the firmware extracted
> from the proprietary driver is also capable of everything needed,
> but I think the normal firmware has the same features. At least the
> BCM43224 is used in standalone APs.

I'd like AP mode for my BCM4313, so I was digging through the list
archives trying to figure out the current situation.  As far as I can
tell, b43 still doesn't support the BCM4313 [1], so Hauke's brcmsmac
adjustments seem like my best option.  An older post says they're in
wireless-testing [2], but I don't see them grepping though the logs:

  $ git log --oneline -S NL80211_IFTYPE_AP wireless-testing/master \
      -- drivers/net/wireless/brcm80211/brcmsmac/
  1525662 brcm80211: smac: changed check to confirm STA only support
  5b435de net: wireless: add brcm80211 drivers

Can someone point me to the code Hauke was referencing?

I'd also be interested in the b43 support for the BCM4313, but

  $ git log -S 4727 wireless-testing/master -- drivers/net/wireless/b43/

turns up no commits at all.

My only kernel experience is with some limited Comedi patches, so
apologies if I'm barking up the wrong tree.

Thanks,
Trevor

[1]: http://permalink.gmane.org/gmane.linux.kernel.wireless.general/76100
[2]: http://linuxwireless.org/en/users/Drivers/b43#Supported_devices
     which claims 14e4:4727 is a WIP

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--g4MvFqI7wmANiPDo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJQjZAAoJEEUbTsx0l5OMgd4P/1pe02c1+IB+ZmUjMLO3Q0kk
Iw/szjR0zbyMynV0cFjCjd8W+IPOOaVEE1rQ9CW2a5MFMSyOv0+KEeIpTUBh+oS0
QlxXAhPEPDcZ2bL1lDtlDgxFHuIgETIpwKQRSmNCQu/Umj18fCwHLONLLQ4QGcrk
vX/qTArPHOmw+8h/R30gFaS62rJm3UiZIKZtHxPq1+J4UoEcjo5BoZQeywG6cbn9
koUm0qGZnFVGoMSHhD9cP3MreZqvkqFbT2nStriT0gZQyVPIg8Av7NG++zqRj52c
y4JzLhjVvuugBOTRXa8VTmKKghAq+b0cwaOP57a1kY2d9Ubl0f5uT/x+73sk+Lgw
r9eBbmqLUGoUYPGHjZshSDR5Kt0X+kXQ/d72oVK2gzOcsVlZzo5jeNxUyDK3nNc+
JNxKAknIKbD11GoXR8MBzpbp+6Gs3pNqZyVpOKqeaPDzPXdlgXTpovcxQxMAsA63
A2Zm/TAl82AMDbQi4q2VZuA38547omMeYp/4vVdLKj4YQ+9ErLSXCHoxDThLdF9K
wmmSFuZint5ZHeQdEw25kkv2H+z/nnZMKLvhMfUe8OigtjKjsQWK5kMRhE0980sw
/3OKDYh2eciLtVm40ZfJ4/DpWPhnbkuS1rBjItMWZoja595KJ0NI/Q4mLYzV5hN2
mI5v+rrUELTJ/A1HTQt8
=4TnC
-----END PGP SIGNATURE-----

--g4MvFqI7wmANiPDo--
