Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:46535 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753191AbdLHNkV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 08:40:21 -0500
Received: by mail-wr0-f181.google.com with SMTP id x49so10826241wrb.13
        for <linux-wireless@vger.kernel.org>; Fri, 08 Dec 2017 05:40:20 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: akolli@codeaurora.org
Cc: akolli@qti.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add BMI parameters to fix calibration from DT/pre-cal
Date: Fri, 08 Dec 2017 14:40:14 +0100
Message-ID: <3432385.m9oFIzB3n7@sven-edge> (sfid-20171208_144025_527062_889C7F95)
In-Reply-To: <637ab47b1794b409e595b7e219cd904f@codeaurora.org>
References: <1495709483-29793-1-git-send-email-akolli@qti.qualcomm.com> <6476910.M9FJQ0px1r@bentobox> <637ab47b1794b409e595b7e219cd904f@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4558582.kxKg9Csv2l"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4558582.kxKg9Csv2l
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Freitag, 8. Dezember 2017 18:05:38 CET akolli@codeaurora.org wrote:
> On 2017-12-08 17:42, Sven Eckelmann wrote:
> > On Donnerstag, 25. Mai 2017 16:21:23 CET akolli@qti.qualcomm.com wrote:
> >> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
> >> 
> >> QCA99X0, QCA9888, QCA9984 supports calibration data in
> >> either OTP or DT/pre-cal file. Current ath10k supports
> >> Calibration data from OTP only.
[...]
> > Just tried this on an QCA9984 which doesn't seem to have the
> > calibration data in the PCI EEPROM.
> > 
> >     [   71.728929] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0
> > target 0x01000000 chip_id 0x00000000 sub 168c:cafe
> >     [   71.732926] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1
> > tracing 0 dfs 1 testmode 1
> >     [   71.752282] ath10k_pci 0000:01:00.0: firmware ver
> > 10.4-ct-9984-fW-009-dfa0083 api 5 features peer-flow-ctrl crc32
> > 7198d117
> >     [   73.805730] ath10k_pci 0000:01:00.0: unable to read from the 
> > device
> >     [   73.805769] ath10k_pci 0000:01:00.0: could not execute otp for
> > board id check: -110
> > 
> 
> 'ATH10K driver <-> 10.4 firmware' expects cal data to be either in 
> EEPROM or pre-cal-file or DT.
> Hope the error is observed when there is no cal data loaded.

The problem happens when pre-cal data file is loaded using the userspace 
helper on the QCA9984. I was only able to use the device when I (for a test) 
used the pre-cal data as cal-data (file).

The EEPROM on the on the PCI device doesn't seem to be populated with a valid 
pre-cal data. I've already tested it with a QCA9984 device which had pre-cal 
data in the PCI device's EEPROM and this worked fine (without cal file and 
without pre-cal file).

> > It works when I use the pre-cal data as calibration data. The checksum 
> > in the
> > pre-cal seems to be correct. Also the pre-cal data from 0:ART for the 
> > 2.4GHz
> > and 5GHz QCA4019 seem to work perfectly fine.
> > 
> 
> Do you mean this patch works for only QCA4019 and not working for 
> QCA9984 ?

Worked fine for QCA4019 and QCA9888 - but I had no luck with QCA9984. The 
error shown above it the only thing I get.

Kind regards,
	Sven
--nextPart4558582.kxKg9Csv2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAloqlj8ACgkQXYcKB8Em
e0ZmFg/+OGPTT+bnrwYoOM5Gh8WdbEKbm/XvFxjds0w7tgP60QlKN9i/dozqiBU5
zEQynxotuwwZ36M5kH7B3Vq9bVKPZFRPjkL2kTel3tDJPSte2pPbH9EBj1zDyg3D
FGzWxEtGQEBWb0dJzhRYcngwoqyMOZqNanfpOXGNYlC5We0U6lS/RoasgA7K0wT2
3YYq3SuToS7LO0VZzKXRZQpCIspwz+yGV/VBfO71M1y6EAdv/fTkfyWEJ4mMMCOH
9F2IgbZlbLeAXTvz7axv8izvwS8gnx+LCHf2BYfI04To7HBg4bl2v5Joh0j4aZtN
2zYto1rKsGPPqNESn3uoityclogZMzAE12w6jl2h25woTkdf9U63dot5XNeKFQNf
siztswEcj9UBz7Tl0wRhfDh2RFcpxU3rgIots7VUmKRbU6w/3is//PP91Ihg9H4S
BOvCREqg4bljzZjQTIE2tVApA5Dtim1fRW1y1egjukpNrYQGHO8bQQOKRd/okUDV
QlMJXI+kdwCdnKR+r7miDJqKMUGEBde+wbSHjcHftlpw+NNMzHZBxBCCuDYA0sJz
+JVVyM7Wjid0pxnX+2LkdlZWCNdoB9F+/TecZpIOyiqmyhmwHiSC/+aUj2oNSruk
PDFctDbyVAeihWkxqE2eRgEu/MvTbfGrgAiHSAcJABIfh2Sz4Jc=
=OOEu
-----END PGP SIGNATURE-----

--nextPart4558582.kxKg9Csv2l--
