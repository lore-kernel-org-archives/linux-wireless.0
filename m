Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B7A466B6E;
	Wed,  7 Oct 2026 09:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365852; cv=none; b=gzYv0N5vWnt6t5xCZh55ox/f0gNIMf8scEDC5VScu7AJy7zh5DDi16LbG3/OGfJ6rqeTL56nGM/h2KTBJKjxfOENA/ZUevbYgO3MZuVE1yd+n4ozB46m7LthiwJXMD9fAZFazSHXjbTnuiyvzw3vL9A7OOY3E6+kRWwZL4LHUO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365852; c=relaxed/simple;
	bh=t5KliWj7qfXb2lJXNKSKooH/wMB6fzYk1fqjNUim0l4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fs5twu+8imWyks1WRmTH9VaXmsJpAasKBSzK3XIQcd9btSnSuRHnBsWvdtLfRW2kg0sfI2ivAhIvh3qx6ZwJRvBkPmnOBxrQb8eLCtUMEoPHGq0LzjuMhKrzgUrQhT8t8U+GNwryAmY1oBV0QHE01kSQvtpgVFuIqHygQMikL4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=f3lix.dev@gmx.de header.b=qOP1OoDo; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=f3lix.dev@gmx.de header.b="qOP1OoDo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1791365836; x=1791970636; i=f3lix.dev@gmx.de;
	bh=30IP6yBa+2ZXqTwZ8IAod6KCj3XnLFTAdgFmC7ZcatE=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qOP1OoDoAKfuw7no3UXnCIcEQTH1Gjc5wn1os4v64qLr9k0W/AhSaix3uKavukT1
	 /eoX5/CGSSOedJUSW5IZDUrwrgJ88cOS2V2qhTmQQgxUCe+QvNFiLaM33hcpt68jn
	 pMXdH/rM/fQM3gehnG7pWwlVikU+uWpg8QdKTT6Luu/ue3TVtCafl+rjPkBf6TplD
	 F7nX1Htbtmo9zmd6WYq4km3VFT2+uU9xBScjUUIL81cmko5EuJCWrrzBmKz29pwjl
	 ntjtvttg+H2eMN8zIOos21jBYm+zSTljmfLX88/R+kIBe3TA0RPK9uk96I3axrRHE
	 9jPkBbWBPNG/kGCSXA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MatRZ-1whG7j1MoV-00aEbC; Wed, 07
 Oct 2026 11:37:16 +0200
From: Felix Hoffmann <f3lix.dev@gmx.de>
To: linux-wireless@vger.kernel.org
Cc: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless v2] wifi: mm81x: validate YAPS receive framing
Date: Wed,  7 Oct 2026 11:30:21 +0200
Message-ID: <20261007093021.17132-1-f3lix.dev@gmx.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YX//OnbdN0I7rICQ7pZV7+m4us2u6+hVz9gufXszjSvhJvNFzE1
 /73n1MlgAchxChBjnFvF2GRYa5aBNgzNZJ59IDmqAb0ns7QnnfG/kjz9hQNJphREsvBXMWN
 1Cc3coMI+eN6HvhDOmzaXAaDFUvDou7EWrOovEouQeW1pZVIVySW8aKDxuoV5VEiQXw4ckb
 xfiMNJwGzG8wTMImbSOlg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ESa+9FncyNY=;ts95gDxC3zN+IBExgDf8VkLhjGu
 qAVbMsSO7Lsz/eAaaUly6R1AFEZhZXAZi9CGYKXbjnW/nUfn35PAhDTQaZ9vC9tCH57t0u8Am
 tk6TD4p72+hXfrDVE66hGGAKKqYuY/0BQEbnTR0wwGkxDJ48XcVlTFmyCnhRAKf4rTSonLN3h
 Osrk2FGgNL1usJqvXbmoafY/PN6SyKxkh2TIeyXiCZ52pR7b4GB/61OjFerk0JaPpotpi2MS6
 lcrDr0+ww1Li2B5NTFpUr/rp9E6pRRiOcpdOJFHPw2gU0Cu75afkX8W7Afv7raveqOZXM+DB1
 Dy9++JM9ZtkVF0mqyDv12lN4EbTI9mr7up2sOc70swmc0+hjEzCGlA665rTqLsqTGKJAQuEZo
 uSlbNcRU4GIDCsI2P+4pPWRdNbpAUJ8uKx5Y81RWt/sA2KUFxPp5hc5GuOcTN2JYd2pNMasxe
 8ysnJ96dp/4nhq0x0/lmdeBjMUdaYbmhPbFCz9S0kBeBX2LTiGpeYiWzg61vpxrX9eDYMOyqs
 jzc5EmlA3Kby+7houZ9htdOrI6dA+z3PdjPmydkxWiJtv9KvZn5krkJJgoZSgKIJydz8GOkpk
 QXvqtbPiWGcYgoo2Cj7mJFJ0NNRgdiFAd1mRLKFSjRkLwNIBigFZi84XMkYQmW4Xbbcoi0pPE
 o2UmeDpFXb3NOuIndg6MEpIH0VdKWtQHFpVqceROiUMs8IMjwgjsxj13Hlmt7Mywm3QLHjZA9
 oGUYyjN77+zKZ8QAlEwuKbxvxF7CqKOt9NTcbvbJChciWmAlvGF7/b7KDKYUj8JfBScKf1/Dh
 NRWUGRxGsqplVpYmlnO7ZVSXU/N3uJuVflAP/MZrsbTi8qzrEl+EcB9ZpRFkutemxiH5CC3Pt
 phb4lTYwVSCp4ALXe4OEeLHEUiWlsIWML3YPW8/FCnI/GOIiwkG9xfMC/pVeceGqjP26at4kk
 Cs/i5E1DEuOhX2uVJVIyiWicN/ejWpFDbDuwSIsNHrmdXYdDOdDDD+hPulom1Bv+ZYy+eYqJ6
 Qv4vAeMPsX3CwKNodpH1GSyckJUAJNlh64MPLhXr9nEvUxVj61H00oyzftHJpymBDM+IIS+BL
 drY9wEYv1qTBjxYfX/61izCZPasn9iLkitJ9eGIbN10T2tr2MxSI8OJuShoRax0ZTCQva6Ut8
 FGLPZapPjog3kkCknSTCoLMCVnYELwx2WZyujqk30MU3GpxbU6wDi4roVd1yhIc0Km8PuY43V
 i1q6MPTte8sACGfyzvp2HTogV4hQKVBPlNMyfi4VmjH3qv4x0fQbUnuLpxhlRMMDmSHwvEwQ7
 5eQ4RoyNMCSFkPn0ldsX2/vsvDT7GObnWF29X8tdwqWjAS5BXYzSGkOuTMXjRJOhBrYhdVkvh
 T8LyPJn0Ffo7vq9DgjFxzLIyQ+B6HLnVslKCFUmvfZic8/4SKnW4ZnDMXvJoxjc/kWblzqdvt
 nM5K/MAM/dz/v/jJ4SGyjsL7hCNTxP3BFJzSrb2PU+iC9HjScx5UpuCgRCwxDSMtOKXuLyzLA
 8xQtQXiMkiUcGzuZvHim3K+q8IEEAWdJUQwyIIZKJRFCVuiFkULo4Uj7zaOzwMCiOeVO9qlrI
 uH1ODI0WyxysSrOo4s6Bo1KrHXVrEeZah5VeakmwmuNL/lySE0exM4lmuxwQYfRsFfDKIBc5K
 Mm5NVrs2viZVAioRs//+xXUITBawINgZaXg0E7qLJjsvdNP8rI35SNorN8U6k/C8ubIT084KN
 BuGP+FAfTEMy43HALrF8ea1ASP/hXiIQD93dF+kFnV9e3QC9Ra0FsEaVrtRlSOeVgkDDYMGok
 5q4oO7c36KrfeQGlbM9/ksoMjkVkgOZ2RLtw6EeCquBdCqKkEzcmENQuW6vROWhGhx3nvquvk
 G1Oywn78ce1SfmehjhVX56XoC/2UlQHEcq8h8fISl7bNmbP6vDDRoTceYfqyaIyvEahRWm1DC
 8V40jQaib+V+qEaYJgUWw0QzsENJJ1Uet1E7L+iGlDr0DfwWNfPb/Co8eO1C7yvw5a82oWWkD
 +dpEZ3LDzm39I1U0iIJ8u2LmRGA1VXKklkD34wLlVZ7FjeFawR8Oq5UxaWfpZCSNGX0BlyRVW
 EIV2IqUjmEo4RpNCWx6CLMEx3mmG7fTCN+0wSwgUEkbAyRKWNyHNKRst/1Ffha22tbTSWbSEQ
 swQ2US/jjDgcZ6EOXYzA7oixI2/F+iTjpctH8dMVvLlGEuoXx5/uwN7FW7QEzgwkX12rj5ZYe
 Yl5T3KvwwobwtEEI3T2ZR6C/XEqCwz6G8cFXxioKR1wTxI+xZVp4ux6A4egQz+oKQ3+LRtF+U
 7nWr9PNSxRqKnxcnnR8tST/J5X20eNSoQFB1etUrkfAqYjHHxUsR7zXLg6aAgmPZo7xFMncQv
 T+l2hG0EZcPDLy/rL2SXriibzlNqgHR0/iv1hklZU0zTVoTetbKOU/8zR539whPsoDvLHv5pJ
 EvVvUZf/qX8m2qqM6BYgxXvFi95uonUyvPmjfN6Du48w0QFJjsEus3q+vnUaQ142J9FHUuxKS
 Ttv6T01ETYANE1a64dsWqtMnSS5McYc7XG8MbYiJtj0DTH+lMYX4qqAB8WSXXNFX3x+LbGlOu
 QMCTQs3vPEaj/MbibJELiNgJzpvmYTNW78RN0jV4/UIrlyKDMT0LYS8a7HYFjwzchOTbCwh+r
 PtBXi/3UC6olkLkuTDcTZXfdm0PGTzQ0RDCbGIxy6s8H/UivddTxFLwkteumepCjq1GvpBRFr
 XbDmU4d1ifgYg9CBSn7r5ecVWjNk93zewuxup6jD/7E+SetJWEGT7PeAQqBk7+N4sH5eO5Dk+
 /XgTgBN7scA07cgsHTWQ/p8+yd3XMRlx5zQT4tBcESoVJOv6dyhgrEAV3WAE0dsytNBraG0Do
 yxCXiSsS5zkrmmz4gkG1keCJHIfQhmvkn61KDabXPU+h6FI5FaQUs3kbtp9lQ4NiQfVmGOKkP
 RwHiq+/v1SXq6o/NgoydZ4bgHwq5IBbJwVnhB/X0mZdafcZAh2O76i0YfsnwCEZ2G44eyvmzO
 EtQxUVKJmNNLS4ACvJtjYTO7MgMm/FTwzE5fSPjgf/FUOShTwQ/SMaSA/gelORE0YeqKepXcD
 Lv9gxC63Ztb0a20KLNGT9DYzH4o2DKLJDidLMSFk/Ad+3v+6sItkTVX9R/MXfWg3lXp3rZpac
 5Koxm91O3E5kZlzLrEzIyRtdqN22zHxE6LWrByAUyTA6x/IF1k+4ST6TXCZK9O4PtpGISosaq
 e1Azw7ebghF+pQEzzUUeK3+h/mfuF0W8dabVWa0eoPeEkGL8W2h6K7cJsB7DS3uZgUaSFOdJQ
 OKF0a4CfE1Vue4xMiBsY1hZs5CcmUX8RO/YSv4C/zTBrEIb7nNtJmdaI+s7s97/uJF1Szam4S
 +cDrcX6UOb2Z9+yzXNsYoYc0HZ39S9oeO/86yBaPO3H/z0QmgoeL5Sj9Jzdu0m54Gq5FKuxRu
 V6UEfxxtnoLtbY77Wj43NbuHarhOYfexekWSjcFZSfSHXhWHDV1M9xRgDEs6KuVA+1y7tfEoC
 CjmlF4PmoamnA9DPRHfIiAaGaGFgnF1K1veVITIApIr8/9fyVT/ZCTcjpx9RaynCKsoPCVyNn
 Sot2eD77G9KZ+BT65jiPvB4hPhyzIplzF0cbtmb4FgU9ZqftKMpZ1Ln9yRhywQjKL0PsXtbCe
 ZsbOKx9Zdm1vw9bT5Hy/l2po25BsT/jKCerUrqJGuJrG8k/Cn7MTOuXzpnuFQAIB5+Fw7jd6R
 P1wViN1FvlgiW/IhuiwBe+fk7Cj+zJzIfRlN2PIqqNusIoRLPnyDyZUk5n2C9zE9gb/q7oqRQ
 Tu7h9PLAK6O+7F7ASjBtThscwPW5hO9I73jo1Dw7dJan6TZQtiJTOIRy3RS9W9Sva1zMFFKzu
 SZMhL7ztsbFt6NplozwQftQOyis7NKcxLAFjt363jyzAVi1TOfEZFvwYvNSQGZ8IKy/kMjBg8
 xsya7ezvir9XAJkrcf6PN88GlnGlYDDJ09ovsJaQDxgAoNoKMQVEB94t/LO0kXL5f+1n3s9vU
 z1DBafGxXCTkBdoKAQQmnNRMkOzMPk05cDtg3n466J+11prbwr8mFulvuMYMHzAoZlPjPooMH
 cBblfItjtz+flCZaRD7pGbmVLIc8Nf9giaYJWli0fJibmBW6IAyExJ+LFjnWzV1YslS95TW2j
 GQubhRe1Gmrdp//wX4vy94ikJ3pu8SBaWBsLZI393UznGNPwuJIuQ/K2Ajb4gg8UP80AC4Vr9
 GzeP0ijJZummfiupyYTiCwhRHpCOrd8nxdFakn0kUeOlnXH7jkKl7uAONdDFUIJl2E8uuiCyI
 22wiY4a/wTbSA0SRtCH1C4AgvDjMZyNri6sKRf17vfEVaQ+2o/zo8zeQzLhC33cnSjUn2mjNc
 a8SrfKph8S0C2rbu8tXRggKlrb0tj0ioOaGb7wJPByeXMqiEyq9JAl62lOesulIt1Kz5mJeM3
 dwDk9KGhDGDEPrkMlLUc0dPrCtwPtXt2j2RS1OLnnFLE9cbadvqtnijSk9cVkV+RcjaHYgGM6
 P7kbG/y9MLfIpJoF/AB5I68cSU3C67EL55kLBUvxlfODXWLvFAu985577ee8VliT7g+gyjqzj
 hoVIjQnplfFqK7nKBYdRlXPy3GjgSncSoXCEyHgw+gq+4i+zmvWQyYxc5e1wxnqodAwfQbdU/
 4qjxDCs5yRbxcPfA/UPI1hW20doQz3/PsyayNz3PZy6f3HjklYONCAlW3xPi55FvFrO9yRoQ/
 MP/OGXAt3szszS26wacibSTDj/EnNVQj5bF9lEch5Xjm11ExmTvZ/A1lWQMtcnuEFMGCcEfVA
 AwIVKAyhr5APMtMUEhkhrF8MGi+9pLnB0ZWygAMQQ+zO6xgPdAYbDbVQR/Rgv48H8WPJiaO92
 hjbFAsQTsi1P7KDgTaGSsaJC74NnI6bJd5sz7JphovcZ05UqAY5ZvKbe3HA8BL9MhavD5ddEY
 p6JZvGY2F2OOkrWt2WEEYbcsCeKLuMIbpe0dKBul/rCRntKpUruy6VOgleAxgrQS5EsbuZUKm
 xAcFietXAJVJTjpBuBGwhQxcJrNYFpPiTnJCid+af2Ow/eA+oLBzmaNRoUWoHISyDrrHSaf5Z
 EGMTtvfGC+ZRObwLofPpZCgw1lkIQbcs7J1ImeRu39VNKd36SivTxDkgXMEm10M1GwmGBDDhz
 4y2KniLfq2qCJbL6puEGnNuicOLjK1ycuGBoHD0nt5THs+Ey2H3nudOI9BDN8y/4mCdg035Ly
 WyCzivTcU1LTKI/p6Gp+W+iGwyNKDbk3rxxMXxSxKijX4OK7tgGb3a1aBqz52pjvMCTsVbzqE
 OYB5mJAANlqBXlEkT8EKLGBnRe2d+zaawDlYXZ0ehDKI2LPHRfT1X+r7YD6vKWDroIlA/x7PW
 UTz+WVQuSVLYm/3xQr3XALSo/jmDxVieu6sveqRU3eom17Qw3xVrhYT30LDFvp1Vr5ijJsttZ
 fw5/PgSkIc22t9OWT3quFQSqg3NJQCBIbwB3FdeMxQcRhcWW8xHHi2Vt+ybu3MwOU2acyz2fU
 QxhUAjCi3bbvXMFBOVmKz6BCk4s5HvVaSchV/WlhcGSgmsDXrYVlS+C0qTMmkvJVKXWN2Fdm8
 VasSg87vSxYBaDLU2+nFoFSqquzPYwdbi1ThAKE/vIAiMnxNrUxe3f31mcN7TLTy6v80fxNRR
 L1AoqWhYDXNUgvwdRo7bDWhAaK/IasQAUrCS71pRXcCk4qY113xZDntCBbqCeEmWRhmBVkvoy
 zgBHnmphk3JZecnL53qr9VzhARnSyaag0TppezE7/11MLM+zE0X8NwQQWolMuW0CLlgr/CFC3
 0GBVyoy/UzbX2d/Yfhbd1tnOMYg3aG2lhp2rLuiruBRGArKfiXShvvhvI7r+EH2ytjpI2ycVw
 7/GTCt8zvk6P7hLmpBIBzsXAIE4NofpwYmlakfjMPbjTYEwujOzoltfrVnP5+e5SovgiGza8D
 QnkZEvInM7R4hytrdwfgXTZWOFsURBYARtOY/LQN0Ao3LEJkVPD1oadU57i37cPwKJP+7cOXI
 N9iHFUYM/Ho416T5DQDGmyAaZbMv47bKktJAHxJ2UxrDAaMC6N1re+hUbQXjHgwO68zRZsBN0
 lkWjLWbsq0PqivDHBgSTVje6Ofd7Are7vZoSLYZQB6lnvQn1wEk2zmtARUXiSk5TX7keJHlLa
 V7oxO+qSZI1MeT32wHfvixvpc90lWFBcXWH2Sx5K7S0hMzl/+X6zJQWQRs0cKEGHDRM05YhxG
 ixpjk8FjWnwtSD1VRGF2S32kJ2yrz1naomTvyvsvkNlyu2WcCs31M+7JX1cbSOaGw8skOS3cV
 xLqUmw10azoKF149AT8TUwU2HNXapph7ZsS8+RWc2D9/SruZtxNUeOZ1lLc911IRyJq9d5A4g
 MpyJY4GTUDSiD0mPY5sclQgLxrpvPU6RQM+gPyXzY84qb7P/ha9IvaljHeN3DienW3xE8/jXj
 +7Q9QrpNgl3sjq95Q==

The receive byte count comes from device-controlled status registers, but
the packet splitter unconditionally consumes a four-byte delimiter. A coun=
t
of one to three bytes therefore makes bytes_remaining negative. If the
reused receive buffer contains a valid delimiter, the negative value is
passed to memcpy() and converted to a near-SIZE_MAX length, corrupting
kernel memory.

YAPS streams are word aligned, so reject byte counts that cannot contain
complete delimiters. Also reject delimiter sizes which do not leave any
packet data after removing the reserved metadata page.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Suggested-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Assisted-by: Codex:gpt-5
Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>
=2D--
Changes in v2:
- Use YAPS_DELIM_GET_PKT_SIZE() for payload validation while retaining the
  encoded-size upper bound, as suggested by Lachlan Hodges.

 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c b/drivers/net=
/wireless/morsemicro/mm81x/yaps_hw.c
index 3d641d23c35b..c4bf79d3a0c1 100644
=2D-- a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
@@ -401,16 +401,17 @@ static int mm81x_yaps_hw_write_pkts(struct mm81x_yap=
s *yaps,
 static bool mm81x_read_pkts_h_is_valid_delim(u32 delim)
 {
 	u8 calc_crc =3D mm81x_yaps_hw_crc(delim);
-	int pkt_size =3D YAPS_DELIM_GET_PHANDLE_SIZE(delim);
+	int pkt_size =3D YAPS_DELIM_GET_PKT_SIZE(delim);
 	int padding =3D YAPS_DELIM_GET_PADDING(delim);
=20
 	if (calc_crc !=3D YAPS_DELIM_GET_CRC(delim))
 		return false;
=20
-	if (pkt_size =3D=3D 0)
+	if (pkt_size <=3D 0)
 		return false;
=20
-	if ((pkt_size + padding) > YAPS_MAX_PKT_SIZE_BYTES)
+	if ((pkt_size + YAPS_RESERVED_PAGE_SIZE + padding) >
+	    YAPS_MAX_PKT_SIZE_BYTES)
 		return false;
=20
 	/* Pkt length + padding should not require more padding */
@@ -455,6 +456,10 @@ static int mm81x_yaps_hw_read_pkts(struct mm81x_yaps =
*yaps,
 		return 0;
 	if (bytes_remaining < 0)
 		return bytes_remaining;
+	if (!IS_ALIGNED(bytes_remaining, sizeof(u32))) {
+		dev_warn(yaps->mors->dev, "yaps truncated delimiter");
+		return -EIO;
+	}
=20
 	if (bytes_remaining > YAPS_HW_WINDOW_SIZE_BYTES) {
 		bytes_remaining =3D YAPS_HW_WINDOW_SIZE_BYTES;
=2D-=20
2.43.0
