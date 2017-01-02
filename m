Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:51600 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932651AbdACE5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 23:57:43 -0500
Date: Tue, 3 Jan 2017 06:10:12 +0800
From: kbuild test robot <lkp@intel.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: kbuild-all@01.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V2 1/3] cfg80211: allow passing struct device in the
 wiphy_new call
Message-ID: <201701030537.mz31vRQH%fengguang.wu@intel.com> (sfid-20170103_055747_936164_3F45A2B7)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
In-Reply-To: <20170102132747.3491-1-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Rafał,

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on v4.10-rc2 next-20161224]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/cfg80211-allow-passing-struct-device-in-the-wiphy_new-call/20170103-014525
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'
>> include/net/cfg80211.h:3734: warning: No description found for parameter 'dev'
   include/net/cfg80211.h:3751: warning: No description found for parameter 'dev'

vim +/dev +3734 include/net/cfg80211.h

  3718	
  3719	/**
  3720	 * wiphy_new_nm - create a new wiphy for use with cfg80211
  3721	 *
  3722	 * @ops: The configuration operations for this device
  3723	 * @sizeof_priv: The size of the private area to allocate
  3724	 * @requested_name: Request a particular name.
  3725	 *	NULL is valid value, and means use the default phy%d naming.
  3726	 *
  3727	 * Create a new wiphy and associate the given operations with it.
  3728	 * @sizeof_priv bytes are allocated for private use.
  3729	 *
  3730	 * Return: A pointer to the new wiphy. This pointer must be
  3731	 * assigned to each netdev's ieee80211_ptr for proper operation.
  3732	 */
  3733	struct wiphy *wiphy_new_nm(struct device *dev, const struct cfg80211_ops *ops,
> 3734				   int sizeof_priv, const char *requested_name);
  3735	
  3736	/**
  3737	 * wiphy_new - create a new wiphy for use with cfg80211
  3738	 *
  3739	 * @ops: The configuration operations for this device
  3740	 * @sizeof_priv: The size of the private area to allocate
  3741	 *
  3742	 * Create a new wiphy and associate the given operations with it.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--x+6KMIRAuhnl3hBn
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICGy3algAAy5jb25maWcAjDzZcuO2su/nK1jJfZhU3cxie3ycuuUHCAQlRCTBIUBJ9gtL
I2tmVLElHy3JzN/fboAUt4bmpCqJhW6svTca/PVfvwbsdNy9LI+b1fL5+Ufwdb1d75fH9VPw
ZfO8/r8gVEGqTCBCad4CcrzZnr6/21zf3QY3b/94+z6Yrvfb9XPAd9svm68n6LnZbf/1K2By
lUZyXN7ejKQJNodguzsGh/XxX1X74u62vL66/9H63fyQqTZ5wY1UaRkKrkKRN0BVmKwwZaTy
hJn7X9bPX66vfscV/VJjsJxPoF/kft7/styvvr37fnf7bmVXebDrL5/WX9zvc79Y8WkoslIX
WaZy00ypDeNTkzMuhrAkKZofduYkYVmZp2EJO9dlItP7u0twtrj/cEsjcJVkzPx0nA5aZ7hU
iLDU4zJMWBmLdGwmzVrHIhW55KXUDOFDwGQu5Hhi+rtjD+WEzUSZ8TIKeQPN51ok5YJPxiwM
SxaPVS7NJBmOy1ksRzkzAmgUs4fe+BOmS54VZQ6wBQVjfCLKWKZAC/koGgy7KC1MkZWZyO0Y
LBetfdnDqEEiGcGvSObalHxSpFMPXsbGgkZzK5IjkafMcmqmtJajWPRQdKEzAVTygOcsNeWk
gFmyBGg1gTVTGPbwWGwxTTwazGG5UpcqMzKBYwlBhuCMZDr2YYZiVIzt9lgMjN+RRJDMMmaP
D+VY+7oXWa5GogWO5KIULI8f4HeZiBbd3Uy5CplpUSMbGwanAWw5E7G+v2qwo1ocpQb5fve8
+fzuZfd0el4f3v1PkbJEIG8IpsW7tz0Blvmncq7yFpFGhYxDOBJRioWbT3ek10yARfCwIgX/
KQ3T2NkqsLHVhM+otE6v0FKPmKupSEvYpE6ytsqSphTpDI4JV55Ic3993hPPgfZWTCXQ/5df
GvVYtZVGaEpLAmFYPBO5Bv7q9GsDSlYYRXS2AjEF9hRxOX6UWU9UKsgIIFc0KH5sq4U2ZPHo
66F8gJsG0F3TeU/tBbW300fAZV2CLx4v91aXwTfEUQJTsiIGOVXaIAfe//Jmu9uuf2tRRD/o
mcw4ObajPwiFyh9KZsCaTEi8aMLSMBYkrNAC1KaPzFY4WQFWGtYBrBHXXAwiERxOnw8/Dsf1
S8PFZ+UPEmMlmbALANITNW/xOLSA2eWgXZzcdNSLzliuBSI1bRxNqlYF9AE1ZvgkVH2F1Ebp
aog2ZAY2I0STETPUxA88JlZs5XzWHEDf7uB4oG1Soy8C0dSWLPyz0IbASxQqP1xLfcRm87Le
H6hTnjyiHZEqlLzN6KlCiPRR2oJJyATsMSg/bXea6zaO87my4p1ZHv4KjrCkYLl9Cg7H5fEQ
LFer3Wl73Gy/Nmszkk+dkeRcFalxtDxPhbS259mAB9PlvAj0cNeA+1ACrD0c/AQNDIdBaTnd
Q0YtrLELeQg4FDhkcYzKM1EpiWRyISym9dq84+CSQGZEOVLKkFjWgIBrlV7Roi2n7g+fYBbg
yjq7A25L6NisvVc+zlWRaVptTASfZkqC+QeiG5XTG3EjoxGwY9GbRU+L3mA8BfU2swYsD4lt
cH72KlD6kaOt751y0dlIDw2dM2I0loLBkim49LpnKQoZfmjFACjGJgYKcZFZ98pSstcn4zqb
wpJiZnBNDdTxWnt9CehvCUo0p88QvKoE2K6stAeN9KAjfRFjCgD9kNDkzHKg5NTDZWO6S3d/
dF/whMqo8KwoKoxYkBCRKd8+5ThlcRTSkoWqxwOz+tMDG2XR5cOdgH0kIUzSFpuFMwlbrwal
zxwJbk23Z1Uw54jlueyyRb0djBFCEfaZDoYsz3bEasIqCs7W+y+7/ctyu1oH4u/1FlQvAyXM
UfmCiWhUZHeI82oqnxyBsPBylljXnFz4LHH9S6ude8ag415iZJjTbKdjRnkUOi5G7WXpWI28
/csIVC266mUOzouiSQg0MhAcon0vwWuVkeQ2ZvLIiYpk3DM4bQIoh9FSBnVLmSbScWh7/X8W
SQaOw0jQnFeFMrTFxflsDgMiWhALVLScC619axMR7E0iYSBU6fTo+T1IYDQuYC3LkZ6zvnsu
Qd1jgA+LMz3QtB97udZcGBIAapnu4FoxlIko5Qpn2WuxC7eoE6WmPSDmGOC3keNCFYSHBeGS
9Xkq35EIciEofQDvGj05q4ptDqg3Sy7GGoxI6HIy1dGWLOsvFVcDrU6kerDJHCRCMGdae7BE
LoBiDVjbGfumCrQKtJsiT8FbM8DO7QRVX0kQB2mhxMC16OfV9sIi6fOFPa2GowcZEke4UrNI
gLOaYT6mP0LFlu58bQqgh1H1c1GmBxaqwpPMgCiodLFAHbkSO9CCo3IqQWrN4PDG4ExkcTGW
aUc9tpp94gcY9uRQagQHl6nnonSBtLfTxQECp31Hp4cBhCxiRjsWQ2w4duXXbe4YpZmAWnA8
EOUQcPYZhXDPPbKaYlwmqhxTl9aJCosYFACqIhEjQw7ZSTuIVe3DdNswn9lDEAvQnKTAd3vd
damosoc6NWPiDg8008La6CgaE5qjwioFisAx0BOcJj6dszxsrVeBnw+eT5Wuux4AmM1HdzgB
oicI1hqVH0UXrIhd9Ax3bek6iKbGXM1+/7w8rJ+Cv5w78brffdk8d6K2M1UQu6ytXifcdRJU
KV2nlCcCOaCVFUOXUaN3cf+h5Qs5diDOrGYUG1XFoPqLTuJmhEEN0c2mIGGiDHi5SBGpmx2o
4JbMDn4JRvad5xi9eTq3gd3e3VwmMwqNTp7MexgoGJ8KUaCyhE3YfIQfJZ/XCI33DQf22PUt
La2z/W61Phx2++D449VF6l/Wy+Npvz60L08ekVVDT7YL7CnZjvnbSDAwTmAJUHX4sTCXUqNi
BpJGHYMARNIjbDiOWBiQGEyaX4pTqryyzCU9jQtjgRLGqbzS2l9PvDZ5AFMJ7j/o03FB505B
MjGqd6nohslv7m7pSODjBYDRtBeOsCRZUCJzay+0GkxQKhB/JlLSA53Bl+H00dbQGxo69Wxs
+m9P+x3dzvNCKzoHkVglKDwefTKXKZ+AX+BZSAW+9sVoMfOMOxYqFOPFhwvQMqbD34Q/5HLh
Pe+ZZPy6pPPQFug5Ow5uu6cXqhmvZFQK23NTagUBkybV9ZeeyMjcf2yjxB96sM7wGZgKEPWU
UzkZREA9ZpFs0kkXrVwKgkEAug2VG3h7029Ws25LIlOZFIk1lhE49/FDd93WQecmTnTHV4Ol
oGeP/pKIwXGiLDmMCDrcHk7L/tXNlr6dO+YawpKQQAcRYkU+BFgfKhEQuVJjFQl37Y1qyoRx
MShJ7DChvJLU3jZqMMfn/QuRZGbgfdbtMxWD28dyOqlXYXm5DQ8hk7ROs0Tr8omzWa3kxstu
uznu9s41aWZtxTxwxqDA555DsAwrwKV6AI/Io3e9AKOAxUe0UZR3dKYDJ8wF2oNILnz5VnAC
gOtAyvznov37AfpJWoGlChP3vfRWzS0OctNJvleNtzdUmDBLdBaDkbzudGlaMd73HKhDuaJz
jQ34pyN8oNZlb8oVuMDC3L//zt+7f3r77HlPETgM0FqKlBEX5zaI9IOtXqhv1cBFbSsBGSN7
xbUPgfdHhbg/r+Zi33pRCUsLG/42Lsp5RQ5GnELVuTtaaVW369eK55vhICIwsqVhXSpCJKOu
X9tprgZtD+gKX6TmENm0u3cDkcorcpfeaY/dz0tDOmfGTmQ1000vq8j9+bvJA8h/GOal8Zb/
zGQOSlJhnNa5AtaUjNS3rzZkdJdzYX5/8/6P2/aFzzDSpfRsu7Zj2vEMeSxYak0oHch73PDH
TCk6r/g4Kmh98KiHid3a167iNltJUecA/SUckcjzbibH3uP0dUlm/CrN2nsIwhUWKOR5kfXp
2tGgGrxuDAHn97cthkhMTutFu94LeWEcFA7DH8hY2w7+Le3DVUkkOkJ4LD+8f09p3Mfy6uP7
zhE9ltdd1N4o9DD3MEw/fJnkeK9K3w2JhfCVBzA9sbk+Sq2CNEkOqgx0RI6a9UOlWNt3e4oz
e8t4qb9N+0H/q1736o5gFmr6moUnoY2mRz4+B/Upo4cyDg11wdPmBKfHa7U7UQazefUdSrb7
Z70PwL9Yfl2/rLdHGxUznslg94pVhZ3IuMrS0PrHcwcRdRyv+sI8iPbr/5zW29WP4LBaPvdc
Guu15uIT2VM+Pa/7yN5bfXsAqH70GQ/vbrJYhIPBR6dDvengTcZlsD6u3v7WcbU4HbdUuS8q
GePK/KpUebuDJxpHRiFBKvaUuQCH0XKaCvPx43s6Sss4Wiu/dnjQ0WhwQOL7enU6Lj8/r22Z
amAd0+MheBeIl9PzcsAuI7B1icFUJn036cCa5zKjrJXL36mio1irTth8adBEenIHGCl6ZN7N
57JSUjkL0D7MwXmE67834JaH+83f7p6xqWDbrKrmQA3FqHB3iBMRZ75wRcxMknnymqCS0pBh
QtUXhdjhI5knczDNrpiCRI3mYFRY6FkEWsu5rVKgDq21Vrw+DXM5827GIohZ7smKOQRMhVXD
gHKFiNZTdwFuTpOHolNnddUQSDxMKzmZXm1jYRlHXZDVihmZqwwN4QijiEgoosZ4skzQoW9i
6ONWEbEMl5bHkt9zgS84VFW1c0NU1zRYQbI5rKglALWSB8y+kgsRKY+Vxvwjehb982mOOme0
UudX5GKEgDNMgsPp9XW3P7aX4yDlH9d8cTvoZtbfl4dAbg/H/enFXt8fvi3366fguF9uDzhU
AAZiHTzBXjev+Gctauz5uN4vgygbM9BI+5d/oFvwtPtn+7xbPgWufLXGldvj+jkA2bZUc8JZ
wzSXEdE8UxnR2gw02R2OXiBf7p+oabz4u9dzelofl8d1kDRG+Q1XOvmtr2lwfefhmrPmE49L
sYjtHYQXyKKiFkCVeS/7ZHiuwdNcy4r7WlQ/2zIt0UvphHLY5kutJ4yD46nQKbOLGFbaye3r
6TicsDGraVYM2XIClLCcId+pALt0fRosFfzv5NKidq5GWSJISeDAwMsVMCclm8bQ6SNQVb5i
HABNfTCZJbJ0JayerP38UjCQznxSnvG7f1/ffi/HmacUKNXcD4QVjV2U48/KGQ7/ehxHiEB4
/4bLMcEVJ2nvKRXUGe2z6SyhARM99FgzEAdiziwb8ii2Vc95drY+te7loCYLVs+71V99gNha
vwriBqw3RiccPA6sqsdQwh4hmP0kw/qc4w5mWwfHb+tg+fS0Qfdi+exGPbxtLw9p06tePsPm
Hr8Qk4clm3lq6SwU41Ha+XJwjJRjmsUnc2/p6ETkCaNDnbqGmcqY6FH7iYfTSrvtZnUI9OZ5
s9ptg9Fy9dfr83LbCRqgHzHaiIPJ7w832oMxWe1egsPrerX5Ap4dS0as4+f2shTOMp+ej5sv
p+0K6VPrrKezAm+0XhRa/4pWiQjMlS49MSzCxeIhBYw4Y9pzD27QpYBw9No7xlQkmcdHRHBi
bq//8Fy9AFgnvjCDjRYf37+/vD+MXn03WAA2smTJ9fXHBd6GsNB/DibxaCJXKGI8zmIiQsnq
7M6AiuP98vUbchMh/WH3ytV5JDwL3rDT02YHBv183/zb4KWeRY72y5d18Pn05QsYinBoKCJa
dLGKIraGKeYhtfImczxmmOP0ONKqSKnK4wJESk24LGNpDITLEPBL1qomQvjgPR42nqskJrxj
9As9DCWxzXp2T12XBtuzbz8O+C4yiJc/0IIOZQZnA7VIGyWVWfiCCzkjMRA6ZuHYo8QQXMSZ
7Ef0DcKcpkuSeJhTJNqbn0oFxGAipGdydXZyJIEUDwSpRMh4HbFCGF20HqhZUEOmxjuEdmKk
HHQEmIqmPzYk/MPN7d2HuwrSCJTBlxs+dQPuHRF0uYA5YRBJkZmlh5RjVZoni1MsQqkzXzF9
4RF8m+72+ZKzzR5WQXEXdpMKyNkdtoq3VvvdYfflGEx+vK73v8+Cr6c1RAGEegDJG/fKaTs5
lrpsgwpRG7d8AnGTOOMOt3F2bvXrZmsdi55Ecduod6d9x/7U48dTnfNS3l19bNVeQauYGaJ1
FIfn1oY6JhFxmUlanMCdtw5gyZOfICSmoO/wzxgmoR+niKRCADnzhBYyHik6TSZVkhReA5Cv
X3bHNYZmFKtoI+w9VlLmeHU+7P36cvjap4gGxDfaPt8J1BZihc3rb41z0Yvxzt6H3nFyBUW6
kP5IHeYqPWeSWc7rp1mbM10Yr1m2mWT6MD2imM2pKyYG3D8G3ZWwRZnm7ao4mWERpk8DWw/U
lj3nKvaFPVEypAcajfbbqUHKyGdV0AnPFqy8uksTjBBoTd/BAjtCszO4i+VUpcxi+GdEX5p7
LmkSPjSpRKUApZZyNlQibPu0322e2mgQMObKd7PujVO18cSo9kLJTAYz29RNxzkC+gzWbLEG
XeuETziUChF6Ep51ThQ24LsAC0Ucl/mI1jQhD0fMV7CnxrE4T0GsF+I7x3ktBRy68iGI9Fov
Fpr1agxH5AJAdGgkFqi1AM1dTitPjYWtV0UMn0GKtK2o9yQmLsCkg5XeN14Ru9D7U6EMnQyy
EG7oXWO6NtI3pSdBHmFZlQemwBkAP6IHdryzXH3rOeB6cDPtRO2wPj3t7CVIQ9BGcsES+Ka3
MD6RcZgLWrnii2hf4h9fwtEhnvs+wWVo2b+db7wM+z/gIs8AeJtieci9KKKR0nh4pNULrW8Q
gnefwdqvesj8UxSzsW75qbbX636zPf5lkyBPL2swoI3DeLZAWuO1e4wiNwPVUhUr3N9UpNy9
vAJxfrcvcoGqq78OdriVa99TLqi7hcDyDFrS3C0qiDZ+HSXLBYfAyvMgr7pwLeznKwRZpe2K
bXG0+w/vr27aKjSXWcl0UnqfNGJ5tp2BaVrdFilIAEbWyUh5nui5uqF5evHOJiKTwAJvjLTb
2fAdnRbuCzLAMwnmbWhO7iG5Y1VpTEU5zRuXToVyr+T7Z7XL1Y6UfRQv2LSuR/H4i+iWALd3
L1A6Q7lPF9Q8m4CfuP8BUfzn09ev/Qo9PGtbrq191Tu974L4SQZb1Cr1qXE3jBr9CefrTeBX
ywcTGMM5DClYQy7M4N7IFNqnUBzWzJfMtkCIsgpPws9hVAULWFpzAetCkV+zWbteVP1RbD+t
QG2nBvtGsmyIZzNg/HPjpROb9C7jqhtkYJcghgjt9Oo01GS5/dpRS2i1iwxGGT6eak2BQNDz
qXvGT2dRP5GJ1BZ7pcDzIJSKvvzpwPulfQ6IQRje1w8KdLxa1YEdO+Hnen52jDjDVIiM+jAC
HmMjgMGbQxURH/43eDkd19/X8AeWdLztFnVU9KlemlziR3zUffEKez53SPh2d54xQys/h2v9
tQvCnqvZZZfNDoDpvQuT1LmhGI7sJ2uBaezTTS3iyP8qxU4KbHh+vOIJA+ovd12YdOrU1KVl
Sc/4lbaUP8PQl7Rk/YT0EkF5LkJ85MEI3wa/lEGre0s634c0qg+24HcwLpmrn56xHQBLvy9i
/FfD/ORrHZ+qz1ZdYvzqEzVl7rep9XmXIs9VDirhT+GvZnWlpyRO7eOc3+t6PhFnlXZUpLz5
jkX/xesZOs5ZNqFx/r+Pq2luEwaif6U/wa47nV6RgFQJkRkQHZML02Z8yKkzbnLIv+9+YARi
V0f7LbaA1Wq12vfu5GiRrL0FiUEqEYxn+JlIo2BgYbeXmMw9fDwG5kCnFOD5Qv6VCOIVOHmF
Ym+9e7PsuahKA4lxuP57T3yXmnBIV6DXDhVMfORIUtU9yxBxUcU5Nn3/tkQceR7ggH5WF7X9
iAwwafYPc0eVPKHJ7gkMg1IHJANSC5Hb1Qg3Lmh1A8IHjY1AaIfs2V3LaHKvGsF2w63PjKBU
RWcgTdFDdvHcyjTUVfLzUG7OAfCzlq/jOdBg+sLDL0MCh/o0zJeN7z8KELChP09eE1Qhi9x/
cfPE5HpuW6u2bSfgHpAfZRossCAP+Z8599yprwj6cIN4RlKGCvsBnVU/9Iw2mYjKwn367Jnj
ruzKrBJAMTSXSzWmbgaNzs1VcZjCuuoGnpAowdedWWZyCmNbTYfLj0PMFVMM3tVRxtiXo0rh
FiWS1mmH0Z+te20joOzXF4vM3FlsfNJ3uTzSeclaD3GdCNu2yEzdRcTpLiCZeW+QkCjV94XZ
N9XKItwOqJiIoXc/GD6cuL5+3N7eP6UKyVM1KoWpyg6dCyPEqKqn8jxNuKytXFsgoZCig6QL
tgW4xJMoAaXJBetK7KLSznxLvUnAzKuLd1GsSEEpuhWS7MY2owL5a0N1mXe87kUX4THOF90o
rEK8wXn7c/t9+/xy+/sB6/Z1VQ9b1F5C5y08sBq7LfGWBUEYMGkqr6C183d9VuMEIb7WuqU3
OoHUrwV1C+LAkzZY27itbJDt7GStC7L3AHqU+Yl4XTgeSiev3gi7ALmuhp7kwxpA5MaXxhm6
SiOXWJnOTWqRswYjU0AEDnLMoahv7/Q1nyNdXlCvOQNNxj6KTtrjW1vz5vgrjOVbjhstsaRL
uioad6Uy7LKUNzWke6nqn838Nw1MGV+pT/V4Wl44L7gbLlQTrXUA/gel/iB+flsAAA==

--x+6KMIRAuhnl3hBn--
