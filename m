Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6049C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 22:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A29712186A
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 22:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbfBZWeM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 17:34:12 -0500
Received: from mx2.mailbox.org ([80.241.60.215]:34802 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfBZWeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 17:34:12 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 2122BA11E6;
        Tue, 26 Feb 2019 23:34:10 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id uvMin2hjXpz8; Tue, 26 Feb 2019 23:34:07 +0100 (CET)
Subject: Re: iw 5.0.1 broken when compiled with lto
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, stijn@linux-ipv6.be,
        fercerpav@gmail.com, Mantas Pucka <mantas@8devices.com>
References: <c450c890-a2f6-d598-c81c-8428144cf41a@hauke-m.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hauke@hauke-m.de; keydata=
 mQGiBEWJZUkRBAC48oPYbmaubFVnlVaS9QgBqB3EkR3IDClD3fANBTXRxyrrABvSDkEu1bH7
 ktJJNNt7R0B5Wk6BhQXgo7jyMfI1enhl/95VwCHbTH1vnJhcvP/ObbV4xikVrvXo+QdF59j7
 L6BhxgeR4CKNBVfQNTJxuszX4A1GjL4qf0mTsY8tGwCgiGXnHud8cElGWI3EapvYbA/ewdME
 AKTK8psIv6elKdLDUZZ6UeOgsZiyO0QpAM13dB7+jOeSscDRvxkC30V5VEW/SvqGDQ3hV6J1
 H7KmFplg3wh0z6GBJju2oxiespxGOxhZOuxTD1VZda/0jGyH9HDrHzIj/YeArroZlxzfJqxi
 Rhg2+ebT5NC6YGnPgeMgjxKiijlnA/4+dsko6BsKqfUvQP81D002iYTO4972/MUN0+YtI/7q
 Fbn7/COKpPzCTKt//t6Iv0Bm9PSE6KA0yLZRdS6YzCPVcDT0loHdEl+MjiTE/0IDF77IfS/Q
 eSRXKLPb+OzdDw6E2CLRA17L7JcbiZDMP90ttKoCFGSEUdUtmTWfeMmGvbQhSGF1a2UgTWVo
 cnRlbnMgPGhhdWtlQGhhdWtlLW0uZGU+iGMEExECACMCGyMGCwkIBwMCBBUCCAMEFgIDAQIe
 AQIXgAUCR5ETPQIZAQAKCRCtxfSClcWOe3t2AJ4q2cyjNOcprtTHsdVTMGVTVMDi8ACfVJVC
 8dJByvjJ4tdTbvwjLYKNnZK5BA0ERYlm0RAQALXkYumI0W3rOqepOZJK+UPJf4TnIFoudMja
 hqpZf3mKxiJpEHNk/u1hgIxyNKct+oyxQ5v9OeuMyfH7LyD0hUGUPkusSjVp9i4qk2hPdO42
 C1hhQ1KU6rIUqak8YSEdNNTf71q6X5g2tch7ZrxP4bbQD1/nIq7fAvcR8fhZsmql0HSA+qq4
 JYFTShpw6Te+oIB/tBt9G3BthHHSlqHjhRJNf0Ol31Xai8g9derZoh/elAmbN0JQUNPVMG4d
 nJ9j7TIjVTj/ekclziMC6m8sT0RU+62/LsyXfvEKCvOZ2KlMXETRQB+SyPfWBjOh6IWepwFq
 aI7l3efFZCEyN0ejKtejZO5c8KQUA4Vf2XUMpdFsuORop+PBRYNwsO0Mi3PKoFAgWVnQTAd+
 rx1CcK+LqjUYOdcfloOdNnLT86L5ar7FLKKg63jwyuE8acHAO/9Hwbr40cld+oJiTIQScAeZ
 3mSam9JLETCaEDMpEcTPibJkusBOuaXVvkkd/G3sX0mFCxTcmXv0JRkf+TveFeto4y05gsPK
 V1rIbzew3EF7MhJ6Rs9oaWocPJwZDjByGZpyoKv/PPuNFxSI3fkLPgYWdiVTDWqOK75ZjZ0+
 lB0xGM6zLXOzoyyGH0KeXEkbIQLeQ8jLpuu/th5NUe/YtIO0I/j8lJRynUGdIE0ZkMqohuXX
 AAMFD/sFJEmlTDHVLcSg19evRsQpfjzTXG1eX4EHclcxDA1I4jDCGVkltOT8SGjzWmGlWWxO
 VXqwEdgxSgrDEYqAp9VA6sdI1YXWxPfALBMvU2djTgNPkgGU4t8rN/t1/kas6w7druKUd1hV
 0SkBZWsJIhCQp5TvecijRfOIe3xk8p/KioNh3zl8z19cy7DdSk0s0diCz6lrzZfHcSCgf4A/
 4Pu7M4nflseVjXkc3RM8bRuzSTs+sETAh4O05IYa3YIR6RHOSEKgY5ePYZ97h+igjm1hJhFQ
 QHH7w9C4vrPBi03209yYT8COL3jpaRKgUwgLNCCrDeVIlxpALi58xH/k1SHdqcZEEnDIDIRW
 uKGWLnPaono44IT6LIBPqwQT86Hhc9J8bnUVkoDPvG1asabIQQFGAgN2zsSTzAqcIORcZ5dJ
 K7p/pODyR6O+isCHjeTFo0ruVa1+o+G0zcyDMlC4KNcnlFnq3dbNgOX7uUQ3Y8aUbJ+8QKGS
 8YAXvLuKJz/npYqffgMmo1epNGpRHlaYeYx8vlgRKuuqlFX8nRUrycX8I5DWHtoQrmDMzD5x
 qWL7kfpy1sImDRS3jo+EZDMa5xNh6jzIUE58hwsyOdnoK/b5WIUW3hq0HHw/CwSoJcgb43VT
 66XEJ5k2Wm8LnJDLtNnb5sftukB4TMZLqIWSD6I4uYhJBBgRAgAJAhsMBQJHkRCOAAoJEK3F
 9IKVxY57vWYAnikfqdGCzUlV8LmAB/mPpjsJ8LpxAJ90nQpenuGsA2UrRUH/Adn2HKnITrkC
 DQRHkREMARAAvIwBRsj5RJvQ1iNdejVAKAXPemPF3sz3i1DMgBGnszb9ish8ftE5nhy1blWH
 wN1+FvDyBvLfkyNYJRWIQ3QIWhX4sZ82L5bmfjMX+eXFS37lMQLCDnzlWIxQV6PIRNtxCqPt
 yj2ekjf1mW6AExS3vmd7tCd+Uz4/Zj2f4lKilXRL+w4yQ6Z3q/p8R6dk7xu1k1QJaxekR7fg
 N/VK9Upv+dazTwxaKmPBh+G3Fzp7vsgjqCkHoP//vdofkTCIgDzu/uCKZ9B7B+08C9egregM
 XM09zAae7b5mS3SrBcaBeAMtKj+MlCJ5kTlXLC+dAWDxZ+PZEngyS4fhLSCLYfJNWo/lbpl8
 FoitQu2ehzRFSVZrQr6irGtLIxRX/Y/D/i8R31nUK4OXuHqb8YkKJHPVc72lyNpFsIPN+LUr
 06LAuhDVzssFAWiALsD3oelbKn0u7QL/eLHDFxg29th2Te4pagA3kV5uv5+xy3b3S7reSSeF
 Mp4poeI77LkqArQuNnnTNat09+vOQlavYfL6EF4ijo1jThydxuzYwx8qz4kX7AQNmMxYMscR
 7+K1Wjj+fTbFuIt6a+i7ay2hMPloDUYSTb4xprUvI8hJDhcidw2fsjLh6KLjnexbq0we3r+Y
 QdIT0AU2/DQZJ4NFbbtcdMWXmKoBt4JNcCEUoVGO93OVEm0AEQEAAYhJBBgRAgAJBQJHkREM
 AhsMAAoJEK3F9IKVxY573WEAnjUmvmfjqA0EcKaNGwUfWxbBVHJiAJ96hLpqhlcPtWuR+f7s
 UO8CwXsJwLkCDQRHkREpARAAsSmIKcXmL7ZMbOyV06ZeqlkZK72Xd0Bbms9RV5tYtRXtnuc3
 pQ9RThimjMPj398vuH9iPCHIcEemak4z/Uz60wQO+tc4Jnbe34by40NnJV3xlQ6X+Cb1ZGTW
 h8ZuO8eUnWPC/mrLZgQuXoAuYg1ISaeikJtAQjzbK9grWMuv2+kDtKZnSKFuUcYWqY3Ixlkt
 t7EN26J0cPGhpn8LlvOUTndXbOviF7ujmEiogK0mEwdLqDCdbaZxsAEOeEkbVEOkuC1Nkyeb
 +BIlj3e+/Pyt3D8xfbNiIds+mLjQO985vbvTVK6KwWAK+SkHXJvTxwTepkA+9MJaqvuqvCQZ
 ZOUn3asIyaOfS/gAquK4ES63kBuB1TktCePAfTWvi+LZoUTvsXingw8IVpfJBNLDj6Om1TN2
 aHCQKG4Eft7yADQe5ejl4q2JK7g/sPmDGGWHb4oNKASPARhQrxGDLQVi0RDuQj6GsWZJcVVz
 Ohgc+tlJRx93we4vFhIjCUn320Mw6leaMYUUiZ40A0IvtD84H877d668tI/OnFbkWLFzIB4l
 ReBlrKovEGwrQpRa9BNUkvGZut21KB3Y7cKG7o5G252xtclIcQmEF+nNi7CJtYtbZ6XcXNEL
 hMYihMGxeWxxck4HYyL9fHJGbphp9B/niiegLik2V4FlPj4Zx/ytlbkLhxsAEQEAAYkCaAQY
 EQIACQUCR5ERKgIbAgIpCRCtxfSClcWOe8FdIAQZAQIABgUCR5ERKgAKCRCGdKcfWD0TMnVz
 EACb4+UI8vIvbVIE75/zQ7icQ5jlhe0QidLiLbgtjgUmrKRgw8j/sBIUFQQIEYVKtBpGTZFH
 RhAw/XYzsUGjqK3zg4vRMO5khz6A5oh/fkhUVzijllO1Ewe3s6BGnPrua7pZqubG704eC8PB
 3TRjuFJRW21VuaqkZz8KCFHiPJ8+A5KggrlsYI61IM/yy+SNzFBpBX2zNvTqilcu0jbRqMro
 JNUruBbwy05SvTP1VzYVEVQgeAe31c57bVX7bpegzq45v2MfmoKQSrNDWdvMZq+akrpNgBKw
 bnbaDtGDRn+zYBCGhdQGOgq8htgmipYdCSH309apZyYsh1FkWGNlPpsyi0V+vqxAgFuttHdR
 74LLsiZMrqQRKV9NJw7P8Zh1Ydz+lWYXk8NnEVd9NMwPOc/Ss/K58MjwEzj95OZNqb8Een2G
 YuuattEcuV+QLPScwCp80VDBczfGbnZCrL8a+qOOh4sW6/uSL4CNxYArbHn8dtQ9o5UUpAGT
 vp5E3G1z30kGRvJcKwy8+3wwhkL4ojZplhO8Z69nmh3aA/hBVOi+Q5wZ6nQSOrhhiCKdERFf
 UUL3X7g3uy4nVTupFmZInuG+RPfj73KZPjtZtREDG6087p6kVeZuaxmUIe7Lzv36prdmT1mq
 QGASuDYHfqQUJhBSGTuFilX8Ndng6L0tdJT2CUkMAKCFNXb8L2yO6h0c5erfkcMmFtCUKwCe
 IXp4PqR6piQM6Rfbx1enZzFmXVg=
Message-ID: <b398e5e4-45f7-e680-b43e-ae3440ba568f@hauke-m.de>
Date:   Tue, 26 Feb 2019 23:34:06 +0100
MIME-Version: 1.0
In-Reply-To: <c450c890-a2f6-d598-c81c-8428144cf41a@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/26/19 9:59 PM, Hauke Mehrtens wrote:
> Hi Johannes,
> 
> When I compile iw 5.0.1 with link time optimization for MIPS32r2 big
> endian all commands are removed, it looks like this:
> ------------------------------------------------------------------------
> root@OpenWrt:/# iw
> Usage:  iw [options] command
> Options:
>         --debug         enable netlink debugging
>         --version       show version (5.0.1)
> Commands:
> 
> Commands that use the netdev ('dev') can also be given the
> 'wdev' instead to identify the device.
> 
> You can omit the 'phy' or 'dev' if the identification is unique,
> e.g. "iw wlan0 info" or "iw phy0 info". (Don't when scripting.)
> 
> Do NOT screenscrape this tool, we don't consider its output stable.
> 
> root@OpenWrt:/#
> ------------------------------------------------------------------------
> 
> When I compile it without LTO it works like expected.
> This was seen in OpenWrt in the iw-full version and when I remove all
> the OpenWrt specific patches to iw. The iw-tiny version from OpenWrt
> works like expected. iw 4.14 also works in both versions.
> 
> This was report to OpenWrt here:
> https://github.com/openwrt/openwrt/pull/1865
> http://lists.infradead.org/pipermail/openwrt-devel/2018-October/014220.html
> 
> With GCC 8.2 this also happens with iw 4.14.
> 
> 
> The binary with lto is even bigger and they have the same number of
> functions starting with __cmd:
> 
> $ ls -al iw-full-*
> -rwxr-xr-x 1 hauke hauke 180164 Feb 26 21:55 iw-full-lto
> -rwxr-xr-x 1 hauke hauke 179016 Feb 26 21:57 iw-full-wo-lto
> $ nm iw-full-lto |fgrep __cmd |wc
>      96     288    7259
> $ nm iw-full-wo-lto |fgrep __cmd |wc
>      96     288    7259
> 
> Hauke

Paul Fertser did some further analysis of this problem and we can now
reproduce it also on normal x86 systems when the binary is compiled like
this:
CFLAGS=" -Os -flto" LDFLAGS=" -flto" make

-O3 or -Os and link time optimization is needed to see this problem.

With LTO the compiler randomly reorders the __section_* variables
including __section_set and __section_get and that leads to wrong offset
used to traverse the __cmd section.

Hauke
