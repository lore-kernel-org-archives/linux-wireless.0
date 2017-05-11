Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:35809 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754486AbdEKKIl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 06:08:41 -0400
Received: by mail-wr0-f181.google.com with SMTP id z52so16329458wrc.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 03:08:40 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        akolli@qti.qualcomm.com
Subject: Re: [PATCH] ath10k: Fix reported HT MCS rates with NSS > 1
Date: Thu, 11 May 2017 12:08:37 +0200
Message-ID: <1754114.EBhbnoIm2s@bentobox> (sfid-20170511_120849_884188_DB79AF51)
In-Reply-To: <6e066fe4-35e0-981a-a86e-d9dcaf6ec3b1@broadcom.com>
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com> <6e066fe4-35e0-981a-a86e-d9dcaf6ec3b1@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4423655.Riqkk3SaUx"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4423655.Riqkk3SaUx
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Donnerstag, 11. Mai 2017 11:39:46 CEST Arend Van Spriel wrote:
[...]
> So you leave VHT as is. Did you check with 11ac device? I am wondering
> if it needs the same change.

VHT MCS rates are reported by drivers with NSS + MCS rates 0-9 [1] as 
separated values. So I would say that the code is correct to report them as 
separate values. But no, I haven't tested with an 802.11ac capable device 
which I can fully trust because I didn't have one in arms reach (and I would 
have to compile a new firmware for it). But the output for a second ath10k 
based device looks ok'ish:

    Station ac:86:74:61:6b:30 (on wlan1)
            inactive time:  700 ms
            rx bytes:       10741
            rx packets:     95
            tx bytes:       9886
            tx packets:     86
            tx retries:     0
            tx failed:      0
            rx drop misc:   1
            signal:         -22 dBm
            signal avg:     -21 dBm
            tx bitrate:     780.0 MBit/s VHT-MCS 8 80MHz short GI VHT-NSS 2
            rx bitrate:     780.0 MBit/s VHT-MCS 8 80MHz short GI VHT-NSS 2
            rx duration:    8172 us
            authorized:     yes
            authenticated:  yes
            associated:     yes
            preamble:       long
            WMM/WME:        yes
            MFP:            no
            TDLS peer:      no
            DTIM period:    2
            beacon interval:100
            short slot time:yes
            connected time: 106 seconds

Kind regards,
	Sven

[1] http://mcsindex.com/

--nextPart4423655.Riqkk3SaUx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlkUOCUACgkQXYcKB8Em
e0ZxxA/9G185Mxios+ISuM6sJGJbBSzdG0HtNMXfr1rXriPOoQMfQLIrKInguJ6E
dSL17sawa/6wvkuaxlvxZiW7VooSyyMHJXymDisDMz+vD3Q0HovLMuegVa6B7r1b
dqJuQRQZgBm3lYq6NxCAMSSlH5SePUhq5RUU1I6jG271pbhSqid/+tltbzTS7+Eq
RD7DO612aHK2+saaHy3p9OT83v1sFW5dBbp/Oyy4YjOYJYm3/FtKmUBs5JPV/RMc
8BUGb2vOlha8S3JZUncowl6BrI3PggBD/X04yk70CUzAmoCN3PN+Vawmz8mfdXhS
NZRTfQgW3Hbe/MVOxv2CdL8PWSU+HVMxIjT4gOqVSsCVlquWskfRUkigA0vqwxsf
D3kbgIZZARxEacB+B6TYmYioxnR1Dop0S++DYSjRLUaudYAaMC05ZD3W6tEkzm5t
1NnkS9HiQ+O4LsUAFKwDjO8sENvL60vGXodfQKFBh1JIjcbDg8qEoK+FmbecGL3+
rKINAfWM/q7Ahry3dKN2oe5lZR5RtHaealYfVE5D+R+GlAhSlTYwXru4M5n8vzIR
J3PtzzDeh7fLY4V3gnm1SKlUfJXFAmgAzAEZbeMmmDl8PR24UBSP3X0UYFZttB46
CVvo4hn8NFNjA0nMG5a/7vY/ZRhzF9UT0qRPc/SXWc+4vT3osgM=
=DXQt
-----END PGP SIGNATURE-----

--nextPart4423655.Riqkk3SaUx--
