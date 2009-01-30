Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46978 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZA3V2j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 16:28:39 -0500
Message-ID: <498370F2.4040804@hauke-m.de> (sfid-20090130_222846_557023_688B1EAA)
Date: Fri, 30 Jan 2009 22:28:18 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [RFT V2] rtl8187: Fix OFDM power settings for RTL8187L
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net> <4979DD39.9000601@hauke-m.de> <20090123153144.GA13658@tuxdriver.com> <497B05AF.5050701@hauke-m.de> <497D2BB3.9000002@lwfinger.net> <497F5F70.50304@hauke-m.de> <497F67D9.5040709@lwfinger.net>
In-Reply-To: <497F67D9.5040709@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4BB3A003B44AF95CDC0E6C89"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4BB3A003B44AF95CDC0E6C89
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Larry Finger schrieb:
> Hauke Mehrtens wrote:
>> With this patch included and pid the rate goes up to 24Mb/s, but the
>> connection is stable. Without this patch is is only up to 11Mb/s. The
>> connection is still unusable with minstrel, it goes up too fare. It
>> starts with 24Mb/s and the connection drops. After some time it goes u=
p
>> to 54Mb/s, but then it goes down again and the connection is working
>> again for a minute till the procedure begins again.
>>
>> What do you mean with rc_stats ?
>=20
> The statistics for the mistrel algorithn are presented in the /sys
> tree in a file named rc_stats. The easy way to see that data is to do
> the following:
>=20
> STATS=3D$(find /sys -name rc_stats)
> sudo cat $STATS
>=20
> You will get output that looks like
>=20
> rate     throughput  ewma prob   this prob  this succ/attempt
> success    attempts
>      1         0.9       99.9      100.0          0(  0)        855
>       873
>      2         1.8       95.7      100.0          0(  0)         11
>        11
>   P  5.5       5.0       99.9      100.0          0(  0)         77
>        77
>     11         9.1       95.9      100.0          0(  0)         14
>        16
>      6         5.4       95.6      100.0          0(  0)         16
>        19
>      9         8.0       95.7      100.0          0(  0)         11
>        11
>     12        10.6       95.7      100.0          0(  0)         11
>        11
>     18        15.5       95.7      100.0          0(  0)         11
>        11
>     24        20.4       96.0      100.0          0(  0)        276
>       279
>     36         5.9       96.0      100.0          0(  0)         76
>        78
>  t  48         6.5       76.5      100.0          0(  0)       2958
>      3034
> T   54        20.0       99.9      100.0          1(  1)       6220
>      6400
>=20
> Total packet count::    ideal 9216      lookaround 485
>=20
> These data are for my RTL8187, which is running at 54 Mb/s (the line
> with the T) and the success rate at this speed is 6220/6400 (97%).
>=20
> Let the mistrel method go through several of those cycles that you
> mention and then dump and post this table. Perhaps the experts will
> see what is wrong.
>=20
> Larry

Hi Larry,

I captured the rc_stats for my rtl8187 device. These stats are created wi=
th kernel
2.6.29-rc3-wl (master-2009-01-28). I tried to get traffic through the lin=
k, but I was almost
dead. Most of the time it showed me 54Mb/s in iwconfig.

Hauke


hauke@hauke-desktop:~/kamikaze/openwrt5$ sudo cat $STATS
rate     throughput  ewma prob   this prob  this succ/attempt   success  =
  attempts
     1         0.2       25.0      100.0          0(  0)          1      =
     1
     2         0.0        3.1       12.5          0(  0)          1      =
     8
     5.5       1.2       25.0      100.0          0(  0)          1      =
     1
  P 11         5.5       57.8       12.5          0(  0)       3924      =
  4064
     6         1.4       25.0      100.0          0(  0)          1      =
     1
     9         2.1       25.0      100.0          0(  0)          1      =
     1
    12         2.7       25.0      100.0          0(  0)          1      =
     1
    18         2.0       12.5       50.0          0(  0)          1      =
     2
    24         5.3       25.0      100.0          0(  0)          1      =
     1
 t  36         6.8       22.3       12.5          0(  0)          6      =
    34
T   48         9.1       23.3       12.5          1(  8)         27      =
   190
    54         1.3        3.1       12.5          0(  0)          1      =
     8

Total packet count::    ideal 212      lookaround 11

hauke@hauke-desktop:~/kamikaze/openwrt5$ sudo cat $STATS
rate     throughput  ewma prob   this prob  this succ/attempt   success  =
  attempts
     1         0.2       25.0      100.0          0(  0)          1      =
     1
     2         0.0        3.1       12.5          0(  0)          1      =
     8
     5.5       1.2       25.0      100.0          0(  0)          1      =
     1
  P 11         5.5       57.8       12.5          0(  0)       3924      =
  4064
     6         1.4       25.0      100.0          0(  0)          1      =
     1
     9         2.1       25.0      100.0          0(  0)          1      =
     1
    12         2.7       25.0      100.0          0(  0)          1      =
     1
    18         2.0       12.5       50.0          0(  0)          1      =
     2
    24         5.3       25.0      100.0          0(  0)          1      =
     1
 t  36         5.8       19.2       10.0          0(  0)          7      =
    44
T   48         6.0       15.4       12.5          1(  8)         36      =
   273
    54         1.3        3.1       12.5          0(  0)          1      =
     8

Total packet count::    ideal 222      lookaround 11

hauke@hauke-desktop:~/kamikaze/openwrt5$ sudo cat $STATS
rate     throughput  ewma prob   this prob  this succ/attempt   success  =
  attempts
     1         0.2       25.0      100.0          0(  0)          1      =
     1
     2         0.1        5.4       12.5          0(  0)          2      =
    16
     5.5       1.2       25.0      100.0          0(  0)          1      =
     1
  P 11         4.4       46.4       12.5          0(  0)       3925      =
  4072
     6         1.4       25.0      100.0          0(  0)          1      =
     1
     9         2.1       25.0      100.0          0(  0)          1      =
     1
    12         2.7       25.0      100.0          0(  0)          1      =
     1
    18         2.0       12.5       12.5          0(  0)          2      =
    10
    24         4.6       21.8       12.5          0(  0)          2      =
     9
 t  36         4.6       15.3       12.5          0(  0)         11      =
    76
T   48         6.4       16.3       12.5          1(  8)         83      =
   649
    54         1.3        3.1       12.5          0(  0)          1      =
     8

Total packet count::    ideal 274      lookaround 14

hauke@hauke-desktop:~/kamikaze/openwrt5$ sudo cat $STATS
rate     throughput  ewma prob   this prob  this succ/attempt   success  =
  attempts
     1         0.1       17.7       12.5          0(  0)          4      =
    25
     2         0.3       16.6       50.0          0(  0)          3      =
    18
     5.5       1.9       39.6      100.0          0(  0)          4      =
    18
    11         3.0       31.6       12.5          0(  0)       3927      =
  4088
     6         0.9       17.4       12.5          0(  0)          4      =
    27
     9         1.4       17.7       12.5          0(  0)          4      =
    25
    12         4.6       41.9      100.0          0(  0)          4      =
    14
  P 18         7.9       48.8       12.5          0(  0)        120      =
   206
    24         7.4       34.7       12.5          0(  0)        133      =
   418
T   36        11.6       38.1       12.5          1(  8)         21      =
   135
    48         5.3       13.6       12.5          0(  0)        217      =
  1684
 t  54         8.3       19.2       12.5          0(  0)        139      =
   963

Total packet count::    ideal 793      lookaround 41

hauke@hauke-desktop:~/kamikaze/openwrt5$ sudo cat $STATS
rate     throughput  ewma prob   this prob  this succ/attempt   success  =
  attempts
     1         0.1       17.7       12.5          0(  0)          4      =
    25
     2         0.3       16.6       50.0          0(  0)          3      =
    18
     5.5       1.9       39.6      100.0          0(  0)          4      =
    18
    11         3.0       31.6       12.5          0(  0)       3927      =
  4088
     6         0.9       17.4       12.5          0(  0)          4      =
    27
     9         1.4       17.7       12.5          0(  0)          4      =
    25
    12         4.6       41.9      100.0          0(  0)          4      =
    14
  P 18         7.9       48.8       12.5          0(  0)        120      =
   206
    24         7.4       34.7       12.5          0(  0)        133      =
   418
T   36        11.6       38.1       12.5          1(  8)         21      =
   135
    48         5.3       13.6       12.5          0(  0)        217      =
  1684
 t  54         8.3       19.2       12.5          0(  0)        139      =
   963

Total packet count::    ideal 793      lookaround 41

hauke@hauke-desktop:~/kamikaze/openwrt5$ sudo cat $STATS
rate     throughput  ewma prob   this prob  this succ/attempt   success  =
  attempts
     1         0.1       17.7       12.5          0(  0)          4      =
    25
     2         0.7       37.4      100.0          0(  0)          4      =
    19
     5.5       1.9       39.6      100.0          0(  0)          4      =
    18
    11         2.5       26.8       12.5          0(  0)       3928      =
  4096
     6         0.9       17.4       12.5          0(  0)          4      =
    27
     9         1.4       17.7       12.5          0(  0)          4      =
    25
  P 12         4.6       41.9      100.0          0(  0)          4      =
    14
    18         5.5       33.8       12.5          0(  0)        124      =
   229
    24         5.3       25.0       12.5          0(  0)        136      =
   442
 t  36         5.8       19.3       12.5          0(  0)         33      =
   224
    48         5.3       13.6       12.5          0(  0)        217      =
  1684
T   54         6.7       15.5       12.5          1(  8)        153      =
  1061

Total packet count::    ideal 826      lookaround 43

hauke@hauke-desktop:~/kamikaze/openwrt5$ sudo cat $STATS
rate     throughput  ewma prob   this prob  this succ/attempt   success  =
  attempts
 tP  1         0.7       81.8       50.0          0(  0)         21      =
    23
     2         0.0        0.0        0.0          0(  0)          0      =
     0
     5.5       0.0        0.0        0.0          0(  0)          0      =
     0
    11         0.0        0.0        0.0          0(  0)          0      =
     0
     6         0.0        0.0        0.0          0(  0)          0      =
     0
     9         0.0        0.0        0.0          0(  0)          0      =
     0
    12         0.0        0.0        0.0          0(  0)          0      =
     0
    18         0.0        0.0        0.0          0(  0)          0      =
     0
    24         0.0        0.0        0.0          0(  0)          0      =
     0
T   36         4.5       14.8       12.5          1(  8)         15      =
   106
    48         0.0        0.0        0.0          0(  0)          0      =
     0
    54         0.0        0.0        0.0          0(  0)          0      =
     0

Total packet count::    ideal 36      lookaround 1


--------------enig4BB3A003B44AF95CDC0E6C89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJg3D3AAoJEIZ0px9YPRMyuzsP/35d3266V0N2SUXJimfEvgdo
Z1dFKFkqITNRnhBMuXUsSf+69upiezBYAA47GehOF+cTBDjVWJ7zrBlVdbKMi32p
KJ/kACxjk313i0e/pcHjYzMIwcQs2H4WMiIR8QYmMHAYUyee9+wM1BEFueS6gtdD
vrwRjrSoa4w5wGUrHNfeTuPX9qoGwKFvweuDJc7zMQcGOdd2dweXDTyk1EWxjkx4
n2aaEHrmYK+gC/nyMcRYNzYeRVOF+ObT8m1EnE2r63AkEYwjNf2vZl/2rbQKguH6
TxWKwjpMN+KB0B7ddIruOW/MwM+I1wDcP/IqpDcAeVQCvB/eIerJnyOHNRuO6HmC
qLsLBJSPOHzxCWVpHyCC+Y7429GMkaZY4107fyog4LtUtdKQX2VNQFLVP5qYRhof
fC4hWH8d5OUlFssPvwWw3WhNR+CvxD8nEdstTPVrn6yOupcKQ8U3JOkV/hwsrZWP
Ra9aX2tpZkyc6K8fXyeX9oo+1xmZgNB6WEDSZy7OXcgQm83s9kymOO3j2IfAd/+v
XEyp4l2bFwBuoRIN5dp4ZjRwDYKUJK9eAuKU00iIIwTt4ohdky8NIXALM9tow/FC
B/l3m+hxJTuTRCF4KGBDaECpgpD5hb6eXsYfCa23tJkfCUaHnFw3LbQTMXIIEu9F
5Gc4PtXv4RvfIJCTle+i
=oqyY
-----END PGP SIGNATURE-----

--------------enig4BB3A003B44AF95CDC0E6C89--
