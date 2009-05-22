Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZEVICo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 04:02:44 -0400
Subject: libertas firmware naming confusing
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LFNHC4uR/FBdb7QQMDbm"
Date: Fri, 22 May 2009 10:02:32 +0200
Message-Id: <1242979352.4212.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LFNHC4uR/FBdb7QQMDbm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed yesterday that you updated the page at
http://wireless.kernel.org/en/users/Drivers/libertas to say the
following two things about firmware:


USB=20
      * The Linux firmware tree contains libertas/usb8388_v5.bin and
        libertas/usb8388_v9.bin. The firmware image must be placed
        in /lib/firmware/usb8688.bin. The firmware image can also be
        downloaded from OLPC's libertas firmware page.=20

GSPI=20
      * The GSPI firmware is available in the Linux firmware tree. Copy
        libertas/gspi8686_v9_helper.bin
        to /lib/firmware/libertas/gspi8686_hlp.bin and
        libertas/gspi8686_v9.bin
        to /lib/firmware/libertas/gspi8686.bin.=20


This runs counter to the entire idea of the linux-firmware tree that the
tree is a drop-in for /lib/firmware/ (or wherever you need it on your
distribution) -- the tree should always contain the exact filenames as
required by the kernel drivers. Maybe this needs to be clarified more.
Additionally, if there's a need for different versions of a firmware,
then the driver should detect which one is required for the device, if
it's for different features it should select a good default and possibly
give the option to override it.

In this case, I suspect two things are needed:
 1) rename the GSPI firmware files in the linux-firmware tree to match
    what the driver loads, and document outside the filename what
    version they are;
 2) in the USB case change the driver to load libertas/usb8688.bin
    instead of just usb8688.bin and move one of the versions to that
    filename in the linux-firmware tree.

The current situation is very stupid -- users can find the firmware in a
proper repository but it doesn't work out of the box!

johannes

--=-LFNHC4uR/FBdb7QQMDbm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFlwVAAoJEODzc/N7+QmaXW8P/3slJWmlKhd7RfZHMMXQZvxW
IjE9Ee6ODhEMz+TfZkCMEFkvnxO3htFwqKjULlvHMkHVnmV2v39c2Nq/Ox/XOoT3
ipUpyeFRhWz1SaA3g6aXu+ucrSCjlCquldmdq4wLAWaEdvPftvY+EsOzjkdpt51w
haL85SZVkjWUCMuEebbA1EKEafGKQUU+FliCcXEF3LrY7LInAsBDUb3nLuQKgBb5
py7EZKp0SJpnlSrfoELPma58DTOqrRk7cXv8JgHOMBWepAeki0oUPHW1nvyg08ST
aAdrRVzQlmboTFsn+YT9UygPdqCM8KwuB4kKZp6SOwaFeok4oUmA/sI49FmHu3C1
+ykgBN9PG0kHvzDlwTWCyo5Rr+q48dXBcPK1t0qGQ8/zmTo0HCYVKcbHojpX/4Yf
k3ety1tAd3ZY4S5e14YootXRP49aCh7AaohSbN/MIrPPtS5NOJsdnGFjAlhy0WeI
UFq2+pHAZdcblMm6+yOCnxaZEFsvejo9EcdCIDF+n15ulyqHEDa4L1Hw6h4Lv2oE
dU+hXaSGpF57lw5nVsnqCpC7cZJOLk57ywcZ8ewHU89SHgz9Rdukuk39K0fDrOZF
4CsvpxW0oEz6XTJAg/goikJ1UqhkZuzCWW6c69lKvekqdcqpkY8e4oYoPFOJwrCH
nl/6p1Uu9zVbtpBYs2gs
=iNVQ
-----END PGP SIGNATURE-----

--=-LFNHC4uR/FBdb7QQMDbm--

