Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61139 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbcFDF6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 01:58:47 -0400
Subject: Fwd: Re: ath9k_htc firmware
References: <57526D1D.9000305@gmx.net>
To: ath9k-devel@lists.ath9k.org, brucembeach@gmail.com,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <57526DEC.40907@rempel-privat.de> (sfid-20160604_075851_147883_41D0E037)
Date: Sat, 4 Jun 2016 07:58:04 +0200
MIME-Version: 1.0
In-Reply-To: <57526D1D.9000305@gmx.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nbu4k8ejDW1QqVoNTdh1GRMeljfxq6RDd"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nbu4k8ejDW1QqVoNTdh1GRMeljfxq6RDd
Content-Type: multipart/mixed; boundary="VJ2aGISaCHnuW5O5ltFmobjl8QMRaVTP8"
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, brucembeach@gmail.com,
 ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-ID: <57526DEC.40907@rempel-privat.de>
Subject: Fwd: Re: ath9k_htc firmware
References: <57526D1D.9000305@gmx.net>
In-Reply-To: <57526D1D.9000305@gmx.net>

--VJ2aGISaCHnuW5O5ltFmobjl8QMRaVTP8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 03.06.2016 um 19:26 schrieb bruce m beach:
> Hello All
>=20
>  I am still working on cleaning up ath9k_htc firmware build tree for ab=
out 6
> months now ( and looks like I'll be doing this for all eternity**2 ) an=
d am
> not clear myself what I'm looking for right now.
>=20
> I'm looking for some kind of simple request in the ath9k_htc driver, th=
rough
> the usb ep0, like a memory read on the card, where a urb is sent with
> the resulting chain of events. The simpler the better. The simplest.

For EP0 on drivers site:
static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
{
        int transfer, err;
        const void *data =3D hif_dev->fw_data;
        size_t len =3D hif_dev->fw_size;
        u32 addr =3D AR9271_FIRMWARE;
        u8 *buf =3D kzalloc(4096, GFP_KERNEL);
        u32 firm_offset;

        if (!buf)
                return -ENOMEM;

        while (len) {
                transfer =3D min_t(size_t, len, 4096);
                memcpy(buf, data, transfer);

                err =3D usb_control_msg(hif_dev->udev,
                                      usb_sndctrlpipe(hif_dev->udev, 0),
                                      FIRMWARE_DOWNLOAD, 0x40 | USB_DIR_O=
UT,
                                      addr >> 8, 0, buf, transfer, HZ);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D



On side of pre installed firmware, the code looks like this:
open-ath9k-htc-firmware/sboot/magpie_1_1/sboot/hif/usb/src/usb_api.c
LOCAL void VendorCommand(void)
{
#define cUSB_REQ_DOWNLOAD          0x30
#define cUSB_REQ_DOWNLOAD_COMP     0x31
#define cUSB_REQ_BOOT              0x32
#define cUSB_REQ_RESERVED_1        0x33
#define cUSB_REQ_RESERVED_2        0x34

#define cUSB_REQ_FLASH_READ        0x35
#define cUSB_REQ_FLASH_READ_COMP   0x36

//#define ZM_FIRMWARE_ADDR           0x200000

    void (*funcPtr)(void);
    uint16_t *text_addr =3D 0;
    uint32_t ep0_data =3D 0x0;
=2E..






--VJ2aGISaCHnuW5O5ltFmobjl8QMRaVTP8--

--nbu4k8ejDW1QqVoNTdh1GRMeljfxq6RDd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAldSbewACgkQHwImuRkmbWk3cgEAkewRQs09wVA7y7qnsnC+5jqq
kPK3wpTW7j/tdFRqsA0A/1bQnuws0iKW0R1wrC3xxYiCGIq+W07GrYI/UIKast+b
=H++9
-----END PGP SIGNATURE-----

--nbu4k8ejDW1QqVoNTdh1GRMeljfxq6RDd--
