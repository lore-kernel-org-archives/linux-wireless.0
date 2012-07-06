Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:60381 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab2GFQf6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 12:35:58 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: Re: ath9k: Problems with diversity on AR9330
Date: Fri, 06 Jul 2012 18:35:55 +0200
Message-ID: <4991617.K7XqcvhjBY@bentobox> (sfid-20120706_183602_745593_DF01F485)
In-Reply-To: <5244861.J1Tyef1FCX@bentobox>
References: <20120706125043.GA23189@pandem0nium> <CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com> <5244861.J1Tyef1FCX@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1607143.Dtdhpfl4v5"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1607143.Dtdhpfl4v5
Content-Type: multipart/mixed; boundary="nextPart5244880.eeimT6VzcV"
Content-Transfer-Encoding: 7Bit


--nextPart5244880.eeimT6VzcV
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 06 July 2012 17:13:42 Sven Eckelmann wrote:
[...]
> > I just also observer the chain0 is "preferred" unless the RSSI is so
> > poor in it so chain1 is taken.
> > Please check if this work out for your case too.
> 
> Removing the antenna on chain0 doesn't change the alt_rssi value for us. We
> only noticed that frames with alt_rssi != -128 have  the value rx_ant_conf
> == 1 (LNA2) when only chain1 is attached and rx_ant_conf == 2 (LNA1) when
> both/chain0-only are attached. Still most of the packets had alt_rssi ==
> -128 and we saw changes in curr_main_set and curr_alt_set (after lot of
> data was sent).

Here are some logs. We added some debug printk before first check in 
ath_ant_comb_scan ("if (main_rssi > 0 && alt_rssi > 0) {"). We can see a 
difference in the output after (a more or less long time) both antennas were 
unplugged. The output looks extreme different when at least one antenna is 
attached.

alt_ant_conf is calculated using 
"alt_ant_conf = (rs->rs_rssi_ctl[2]) & ATH_ANT_RX_MASK;" and could be wrong. 
curr_alt_set and curr_main_set come from div_ant_conf queried using 
ath9k_hw_antdiv_comb_conf_get.

Kind regards
	Sven
--nextPart5244880.eeimT6VzcV
Content-Disposition: attachment; filename="after_both_antennas_unplugged.txt.zip"
Content-Transfer-Encoding: base64
Content-Type: application/zip; name="after_both_antennas_unplugged.txt.zip"

UEsDBBQAAAAIAIc7R/yAUUHLngQAAGdYAAAhAAAAYWZ0ZXJfYm90aF9hbnRlbm5hc191bnBsdWdn
ZWQudHh0xVxdapw5EHzfU8wBnObTv3SWsBgTdiGQ9YLthRw/GmetfHY1mpd0tZ/izJiipFZ1tdTS
peQeJI1j/vx5+efh6+P90/Pz10u5uzx8e/n573F3+fLf09P966fPf71cwv//cf3G9fd09/MvHx5f
7r/8+/j39QvXz9bv8wtP308f//H58oqb20fcfMJtZril7/ja4dYt32qG24BvtMRNb7jdie/Yzm+x
w4V1xOAb5YBxThTcsB1nK92IEl3Wb1R08jy/3Qx3r5PZDBd1MlqOc3rDfaXL06vFtwef+R3pI24/
4QYrgU5yAPAgAUNkmWb+hRtgBTOUMkkE3HAm/ClEq+hKkmE1MVQ6SQFchrubuBDUiRJbNfrNcdty
tlvHPQPnxOLcudl4cUaXx3AfWUL5iNvOYv3bbW16A44AzArsLAlS8jAlvYAzrGZKasxS9oztgBX9
ioREkaUBY158dSBdLEVk4Q7kXDicixzAmWFziwTAZZQTRSLXECy+CQwQw4gUyRBb59CyKheLlOq1
jotUwGaYgSINcyPJABXpgM3hrGgXaZ6rUrEyCscqwScrV4kuYl1viFcyw92Ll1VQVylQyXACq8Ii
Nq0mFm6DPUWWcNUb5wJWCVnDZZmuqogmw/w0xeydKVvteDVFMM/hZVWsNrZe/sJ1iemmFMim47xw
sT5m7II0ZXePM84V8gOHb+PmpYWL5pLDd2zXrxVuV4wlw+90CYDLOJvvEl3iqjtuJnZJoNHvztms
klJXDnB5pItLQuyKUNvu3C7g6lIidsVRkwgrtpZk5btydM2JroEHT6QVNeRwsQJDAuBS2gSGptmk
ABuS3E4Yh+TtBpuVkgxlL4I00bgZQQJGl8tbzuh0zwFmxxkljDHY45DDI6wnro9+TWDUL4JgT1zU
Lsam8QRG4SJtdE3s/Uaq0enTxN1vpBo5kYnrJl0Te1+k23F2kq6gSBeDcFCk691KttLMcEO6rCIr
aLaLFNXBUb2Col6mzZJrnpVW64PFucJRHxEb5ppRNE9gPLgnAZM1e400ajbD9UUnyZ640BFCMV9R
6dNkyVfUKnUadvLa2Z3YGSabE2QFOR+cKMOGp0qQkag1PJEYdyfGY58prAgnRcEYXiQpAkY4Gpq4
cdvDZ1U5JkfhSjeEy26OUbgo9iexGzXXQCu6RcqMExsbYymamRTNZJjNpGgmw2zmG5Jp5QO0uzln
vkZdOBMXJZPDN2FEk1ZTVg7TCR1tExfb2yk+ICvPRpgan4WryBZtkvFMmyFcWYYb56I848BYzEWC
172NiY1tkxzOfgJWbgiYHWflfg7Fhkxkr/6nib1XT6NbjRMX1ZNRzZQbymlVURSfa9GjSoDda0am
0C7mUOxAlcS9srpwseObJZlVuRTN4YzHMu+6j676acS4erzJNnHxrbBEGWl8zYEhW1V5K4wV1U0O
F85NebeLUZ035RUchlQ39rtdiy++gMOZX1RLXkyjYnLGGvWSZTGbopmMk4mmaCYDt8sBcX3OEVa7
XV25U8iw8l3idh1bWduu3O3j8M0ed+wm7r510C6ey/ZVOKt82JV3Dhkeb+Ky8/APUEsBAhQDFAAA
AAgAhztH/IBRQcueBAAAZ1gAACEACQAAAAAAAAAAAKSBAAAAAGFmdGVyX2JvdGhfYW50ZW5uYXNf
dW5wbHVnZ2VkLnR4dFVUBQAH/////1BLBQYAAAAAAQABAFgAAADdBAAAAAA=

--nextPart5244880.eeimT6VzcV
Content-Disposition: attachment; filename="at_least_one_antenna.txt.zip"
Content-Transfer-Encoding: base64
Content-Type: application/zip; name="at_least_one_antenna.txt.zip"

UEsDBBQAAAAIAIc7R/xqFR2mdgQAABaHAAAYAAAAYXRfbGVhc3Rfb25lX2FudGVubmEudHh0xZzR
ahsxEEXf+xX7AanxSjO72m8JxZjQQqB1wXahn185DcFF97G+p2+uFw6ys1czq+N5nqZtLbttf/v3
ZfpxfD0dzpfL61TL03T8fv374vNc2tP08ut8Prxdcfl6neb3/7hddHvdr39773i6Hl5+nr7dLri9
9/G6X3D+fff2p+d39jywZxu7gOuuIDtAdoLsBWSvILuB7I1i190ey7XOHnOt2thjrvnYWK51NpZr
nY3lWmdjudbZWK519pgttr/zGcyWGcyWGcyWecwWH3vMFh97zBYfe8wWH3vMFh97rJls7DJmi48N
ZksBs6WA2VLAbCljtuxt7DFbTL1/3VVw/67gPVaxZx6dDd5jFbzHKrh/V3D/ruD+XcH9u4J9SYC1
Q4C5FmOu2faSGHPNxx5zzccec83HBmuHGHPNx8ae5dZdjtliW3eC2ZJgtiRYMyVYMyVYMyVYMyVY
MyVYMyVYMy1gzbSAubaA2bKA2bKAZzULmC0LeFazgNmygNmygvf3Cj7rWcFz4BXMlhWsW1YwW1aw
blnBbFnBbGlg3dLAXGvgOVEDa6YG5loDc62BudbAXGtgrjUw14QTbKsdhBNse9YjnGDbWaxwgn3f
N9iPcU5wBZ3gCjrBFXSCA3SCQznBPjbWCwbo5Qbo5Qbo5Qbo5XY2li2hnGAbm3OCQzjB7Q5d/zu4
fICHYJnvFx37x5GxY/cQOvA/q67b41aNHbqHkoF9bOzQPZQMbCrMOxsMNCEi2z5zISL72FgTGEpE
9rExmSiUiOxjg7lWwFwrY67Z2ELA9rHBbBECto8NZgsnYIeSoG17qJCgfZ852IgJCdrGFhK0jw0+
5BEStI+NHfiHkqB9bPABk5CgfWzwARMnQXc2mGtCwPaxwZpJCNi+dYO5JiRoHxvMFiFB+9hgtggJ
2sYWErSPDdZMC5gtQsD2scGaSQjYtr1ECNg+NtgLCgHbxx5zzcZewVwTArZv3ZioGKCAHUrA9n3f
YM0kBGwfG6yZhIBtYwsB28cGayYhYPvYYM0kBGwfG8w1IUH72GC2CAnaxuaGE4cSkW37NzecOJSI
7Fs32JcIEdm3buxHDqFEZBM7lYjsY2M/3kpwOHGq4cQ+NpYtqURkHxvLlgRF5ARF5FQismkvSTUg
2LdurDdINSDYxwazhRsQnOCA4AQHBKdygm1sbjhxggOCExwQnOCA4FRero8NZovwcn1ssG4pYN3C
OcGpvFzb9y28XN9nDtYtYjCyj42d1aRygn1sMFs4JzhBLzdBLzeVl2vLNeHl+thg3SK8XB8brFuE
l+tjgz0R5+WmcmNNv01N5cba6jVuOHEqL9e3buycKJWX62Nj/loqN9bHxrz7VG6sjw32RJwbm+Bw
4lRurI8N9kTCjfWxwZ6Ic2NTDUb2scF+THi5tnpNeLm2PBdero8N1kzCjfWxMe8+lRvrY4M1k3Bj
fWywHxNurI8NZosYTuxjg/2Y8HJ9bLBm2sCaaRyMvN2hHzZ0LoWMPN8/bHnYkL8UKvK8f/Ca/wBQ
SwECFAMUAAAACACHO0f8ahUdpnYEAAAWhwAAGAAJAAAAAAAAAAAApIEAAAAAYXRfbGVhc3Rfb25l
X2FudGVubmEudHh0VVQFAAf/////UEsFBgAAAAABAAEATwAAAKwEAAAAAA==

--nextPart5244880.eeimT6VzcV--

--nextPart1607143.Dtdhpfl4v5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJP9xPrAAoJEF2HCgfBJntGk+EP/3pL4QIYrsPY7oUG9vIGXUoY
RVmUOMiPTh9mCN93rD2vVBxl0MD/hcA0gPSG/uzlg6sUi74DQsmJ6i/XvQ/FwLFm
gk8CK9SxR4Gf1M3sCXnzqXKBfP62ZLs/9Jhvl3gWr+O7xeJSzH6d6rW9Yx1w7WU2
daikkIIf4mkruKsv+/k5/2/Hq1/F+ZkjYcs4AQrVpA0RFjFrw860LlBROxEZyraE
cFvYD2jvE31voPVJfF8cbEsHqOGpF9A1jrSgUWTdh6TcAmIBMdef5Ea19OP4xohE
TZn44eNY3KqYdv/gzAK7gDKoeANfdwlzJpTXeN1/TwFK4eSR+2QgJP0H3Ks8D1rY
2gBIvbtSmo85SlGowwxF18dUH1YVkiktOcAu07RFnSoktSS/7oU8LXvjYGXXC69c
C733e42uAm/4UmNSfmi8WLNubu00/tkVI3B+tj5NhgNgokbMLCXC66NtKyCzIVkn
jKJcU0LrEYT4B5o767Tm18PZfY0YcxTyfdkzce1QekxdAexQQ3QEGZ4oZrE6dyaC
mcwghlUXiH4v07+0h7e7TcXM1J5Osmmp/VVaxMak14XHeDJljgfluQeyZV1XEBQM
awZMdR1Sr+3EY3rCcuzc0VhF4VoU75QBBHiFXoLqfATce3yaRMszD5OOCHXKSLnM
K166MjVtE5E1iA+4Y1Ub
=LGCu
-----END PGP SIGNATURE-----

--nextPart1607143.Dtdhpfl4v5--

