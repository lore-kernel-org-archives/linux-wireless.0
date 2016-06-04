Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54657 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbcFDFze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 01:55:34 -0400
Subject: Re: ath9k_htc firmware
To: bruce m beach <brucembeach@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>
Cc: ath9k_htc_fw@lists.infradead.org
From: Oleksij Rempel <fishor@gmx.net>
Message-ID: <57526D1D.9000305@gmx.net> (sfid-20160604_075536_847147_82964C2C)
Date: Sat, 4 Jun 2016 07:54:37 +0200
MIME-Version: 1.0
In-Reply-To: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Vxlja0aqvL0tcchTuJCIF66TsPhGSt6nn"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Vxlja0aqvL0tcchTuJCIF66TsPhGSt6nn
Content-Type: multipart/mixed; boundary="s8jeXg9ps4kGAOx2dCPqRd004wSnLD153"
From: Oleksij Rempel <fishor@gmx.net>
To: bruce m beach <brucembeach@gmail.com>, linux-wireless@vger.kernel.org
Cc: ath9k_htc_fw@lists.infradead.org
Message-ID: <57526D1D.9000305@gmx.net>
Subject: Re: ath9k_htc firmware
References: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>
In-Reply-To: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>

--s8jeXg9ps4kGAOx2dCPqRd004wSnLD153
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


--s8jeXg9ps4kGAOx2dCPqRd004wSnLD153--

--Vxlja0aqvL0tcchTuJCIF66TsPhGSt6nn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAldSbSoACgkQHwImuRkmbWmo6QD+NDlezBIA5ela9tNrCH9vARV0
CKO/WUp7IttJskfRefAA/2Vd3QNl2zuHZp68lk13iqVQoduIxYhYlXOHdX/y4WhV
=7y/f
-----END PGP SIGNATURE-----

--Vxlja0aqvL0tcchTuJCIF66TsPhGSt6nn--
