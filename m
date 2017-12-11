Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38059 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbdLKO2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 09:28:43 -0500
Received: by mail-wm0-f68.google.com with SMTP id 64so14460522wme.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 06:28:43 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: akolli@codeaurora.org
Cc: akolli@qti.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add BMI parameters to fix calibration from DT/pre-cal
Date: Mon, 11 Dec 2017 15:28:37 +0100
Message-ID: <108074068.BxyvveCqUm@bentobox> (sfid-20171211_152847_590202_D9DB2066)
In-Reply-To: <6b494081c2606c8e523e2c426ab949ed@codeaurora.org>
References: <1495709483-29793-1-git-send-email-akolli@qti.qualcomm.com> <3432385.m9oFIzB3n7@sven-edge> <6b494081c2606c8e523e2c426ab949ed@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3046730.7gPZ9c07nJ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3046730.7gPZ9c07nJ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Montag, 11. Dezember 2017 18:50:09 CET akolli@codeaurora.org wrote:
[...]
> >> > Just tried this on an QCA9984 which doesn't seem to have the
> >> > calibration data in the PCI EEPROM.
> >> >
> >> >     [   71.728929] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0
> >> > target 0x01000000 chip_id 0x00000000 sub 168c:cafe
> >> >     [   71.732926] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1
> >> > tracing 0 dfs 1 testmode 1
> >> >     [   71.752282] ath10k_pci 0000:01:00.0: firmware ver
> >> > 10.4-ct-9984-fW-009-dfa0083 api 5 features peer-flow-ctrl crc32
> >> > 7198d117
> >> >     [   73.805730] ath10k_pci 0000:01:00.0: unable to read from the
> >> > device
> >> >     [   73.805769] ath10k_pci 0000:01:00.0: could not execute otp for
> >> > board id check: -110
[...]
> 
> I tested this on QCA9984 and it worked with below config,
[...]
> 
> Kindly try with the latest firmware from Kalle's git mentioned above.

This didn't change the behavior. It was actually the OTP timeout problem on 
the QCA9984 which Ben Greear fixed [1]. Luckily, LEDE added this patch with 
your patch [2]

Kind regards,
	Sven

[1] https://git.lede-project.org/?p=source.git;a=blob;f=package/kernel/mac80211/patches/327-ath10k-increase-BMI-timeout.patch;h=c9f493bcd8fe29afe1e08dc31b6370507b95fc72;hb=025cb640cdf27f7c68fc1d89d0698605daa06c43
[2] https://git.lede-project.org/?p=source.git;a=commit;h=025cb640cdf27f7c68fc1d89d0698605daa06c43
--nextPart3046730.7gPZ9c07nJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAloulhUACgkQXYcKB8Em
e0Zx2w/9EJfcfAf4FZBcCdJp36qSreUUy8nN1wr7/gZZHcpN2NXrAnLJ5bUGUBK8
EF/hLS+mBHMxE0whD5TpzZaffZMdFtnTLVfj6VorRTYkun0WgWEq4reShCa6NuKh
u9mS5hFOgT/MOOACZOIrYr76DSfj3vyLraogOlSFuJCxu48tfIaTvwEaP5vVSJT6
kcucOZTkE6xXfTAmfwNAfmQwTSK1QJbFCOTjyOsH0oLI4OTBVGgm1aMC0cSZ+6gn
HM0povvX/BMXRgOAFkxOC0uMRE3KAVLnDh88i5h4+flSFAeE4v+6v8Eie33oalXr
GtTVmt2cJ3Dbvpo5iDpf+0PY4t+1+MhZ8PQE9lgYDxcg16XY2mzO2C/K/mMAs6+0
SQ4dvHF4Hw8boLJWmvXjQYa3X/E/aGdYpgV1ofJYb9DzYYNNDEy+fKpOuhRUWMLR
i/p9VWeDAG6OV8/oWanqb4uo32CR8mrKm6O2EER7autnW5CAS4b8MuEo3YoEipQO
zzKREhW7rs74FBEl3/DaXfiYaLAI3ZWw4ohu7nbhvTHDNzBzusjypnG3rwWNYntu
mDoxKHtoZ1Ly8P+EWQD5E3MT1LgFxAHvD0teC3slayVfzSTw2z1c16QcFV978ubb
5pLiNT5KEhAlz5Bp3kaOijoWYEWYPcXqFw1xYGtAL48YzC5M4+A=
=5npb
-----END PGP SIGNATURE-----

--nextPart3046730.7gPZ9c07nJ--
