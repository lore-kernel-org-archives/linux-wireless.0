Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:33675 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932399AbeGDKkm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 06:40:42 -0400
Received: by mail-wr0-f181.google.com with SMTP id k7-v6so4850226wrq.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2018 03:40:41 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: s.gottschall@dd-wrt.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org
Subject: Re: [PATCH v8] ath10k: fix crash in recent 3.5.3 9984 firmware due wrong handling of peer_bw_rxnss_override parameter
Date: Wed, 04 Jul 2018 12:40:39 +0200
Message-ID: <5630152.jDWN9V3RzB@bentobox> (sfid-20180704_124055_715246_4C8662C1)
In-Reply-To: <20180704092953.32572-1-s.gottschall@dd-wrt.com>
References: <20180704092953.32572-1-s.gottschall@dd-wrt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4401141.ZugrdnYArS"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4401141.ZugrdnYArS
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mittwoch, 4. Juli 2018 11:29:53 CEST s.gottschall@dd-wrt.com wrote:
> +/* Values defined to set 160 MHz Bandwidth NSS Mapping into FW*/
> +#define BW_NSS_FWCONF_160(x)           (BW_NSS_FWCONF_MAP_ENABLE | \
> +                                       (((x - 1) << BW_NSS_FWCONF_MAP_160MHZ_S) \
> +                                       & BW_NSS_FWCONF_MAP_160MHZ_M))
> +#define BW_NSS_FWCONF_80_80(x)         (BW_NSS_FWCONF_MAP_ENABLE | \
> +                                       (((x - 1) << BW_NSS_FWCONF_MAP_80_80MHZ_S) \
> +                                       & BW_NSS_FWCONF_MAP_80_80MHZ_M))

Please check the shift and mask macros in core.h


#define BW_NSS_FWCONF_MAP_160MHZ_LSB           0
#define BW_NSS_FWCONF_MAP_160MHZ_MASK          0x00000007
#define BW_NSS_FWCONF_MAP_80_80MHZ_LSB         3
#define BW_NSS_FWCONF_MAP_80_80MHZ_MASK        0x00000038
#define BW_NSS_FWCONF_MAP_MASK                 0x0000003F

#define GET_BW_NSS_FWCONF_160(x)     (MS((x), BW_NSS_FWCONF_MAP_160MHZ) + 1)
#define GET_BW_NSS_FWCONF_80_80(x)   (MS((x), BW_NSS_FWCONF_MAP_80_80MHZ_M) + 1)

/* Values defined to set 160 MHz Bandwidth NSS Mapping into FW*/
#define BW_NSS_FWCONF_160(x)         (BW_NSS_FWCONF_MAP_ENABLE | \
                                      (SM((x) - 1, BW_NSS_FWCONF_MAP_160MHZ))
#define BW_NSS_FWCONF_80_80(x)       (BW_NSS_FWCONF_MAP_ENABLE | \
                                      (SM((x) - 1, BW_NSS_FWCONF_MAP_80_80MHZ))

(these snippets were not yet tested and most likely need further adjustments)


Kind regards,
	Sven
--nextPart4401141.ZugrdnYArS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAls8pCcACgkQXYcKB8Em
e0YgFQ//fmRLhV8GGWXxafzDwMIH4JkU2Ilo+XO8gTsbBq4ofe8zGugNwxC9z7m2
FxDi5PqhRZeQ1VG0niPTwQf6jSIBbxnm8tLToHOnvJILlXhDoEUbpzjzaqPoaNhW
Y/oCYNWP7Ss0Z44zzdtOnCua0rDfj1OAEjlTOEcO7I6dK/WEHCcW6VqUDlJuGinZ
kDHVWLE7uASDtWuuL6t4y/l6vQgYkDz+9Cff6KLmeZ25/OJT+X+TOQaulQdIxlv/
sq1ONEIuGlZ4KqUpDTzFhvWqmUEMZpemF9P53Md43FY11IkZ4350CQ57nP3MiwaY
/36Nll+PLU6LDfT9fixq5VqUQoTTJ1uFfV5zyHFvj4gbPvI/YhoI5TyBP4nW8dLP
UnPWn33jIIobwlVo7u+XGHYhhGT3B5NZKrBSzWk/fpX7e7W9liIzztKelTHLhQzF
DVXRS6HiUDClukSgb+3XXShsRrru5Ib4VlP3r5v0Xas0627eaa0Zz31doGOS/hqD
EhET0oANyxSnIl3mAhFVsYDMNUUY30FkbnX4B4Eebce6fXgHZmcfMXkRW574Fx/p
OaXBsHHnSlXPWI9hJDxTqsZQ7/OouKbQYkab7tuVPxHTS/jTANW/tIPRK9l1pdiZ
1x5u7yrdihYri60ZsOzjmMS9xX/91CRyvlLy51B4QpQ9KAlVMsM=
=90cy
-----END PGP SIGNATURE-----

--nextPart4401141.ZugrdnYArS--
