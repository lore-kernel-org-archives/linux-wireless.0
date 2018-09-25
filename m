Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92627C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 18:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 368382064D
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 18:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=uni-rostock.de header.i=@uni-rostock.de header.b="aHdzaHnz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 368382064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=uni-rostock.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbeIZAN7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 20:13:59 -0400
Received: from mx1.uni-rostock.de ([139.30.22.71]:56464 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbeIZAN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 20:13:59 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2018 20:13:57 EDT
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmz; 
 t=1537898416; bh=+hFpNotepCVjjpVck11uWe2MMi09hTjUVfoo9rOBWho=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=rsa-sha256; b=
 aHdzaHnzxpftBM+SNnbtN8IxP1c0Zmb8AXzonc+IGMcYiWQxzjxVg3FDo5p0s2O1YpfMWxn9dRki2oirYgAr/KCOFwHysHjeYrlWsuM1MgOJ4PLFKDnOOHFp8/aeIadF4J3CO0xtqAXMMRKbJrsz6Y7hWTthBREV9zawzM275tU=
Received: from [139.30.201.127] (139.30.201.127) by email1.uni-rostock.de
 (139.30.22.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.1466.3; Tue, 25 Sep
 2018 20:00:16 +0200
Subject: Re: [PATCH 0/3] mac80211_hwsim: radio destruction fixes
To:     Martin Willi <martin@strongswan.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20180925074115.18169-1-martin@strongswan.org>
From:   Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Benjamin.Beichler@uni-rostock.de; prefer-encrypt=mutual;
 keydata=
 xsFNBFXeyfMBEADDFF0gXTteSbIai1true3Hyt2kP/78NNeE4gqDY+HhUX3TpHdMgqP8VcQa
 M0EeyK2gTT5xWi3Gg87S/VhE/TbXfBP7CigjwgM/3kxpSLJVzHhS10mRwhoXxEpeV0JOHhk2
 nmdH3NGPnHmauPP5H16oP9CM9oZxiFn0QgfV11AesPeRDiZFA8zGLtpUUk1IDMXGJfor68tK
 r7c1AoEiw8WKXZK9SzNtVzwWmQhF4nVFNCNhXX6pN8Zxu04ubgEqWxNQQeRtdwSb9oHDYgHT
 vYRkaiwAUSVWpkpCuNyPcK1RXwpwZ/FneeHGpRseqqtoy6jyr3cZsFQ3EcQqqxKLf1Wmwtle
 4vb/9unFTTMnTLVvrrwSjCj0nRKN+cOw9pY5lmEWPsz+ikEaKijQk1bIUlE5htejpGj7S+/j
 w3APge8xmCrgSsl42pnBZZE7njr8aO1olEXarHAKI02lxcVlPLnvAKFE6XWGbbPJVVeJNnoU
 R3fsl3zmCafMxrSSYLEHkb0/b2rNh2Cb0A+Vx1iT3aZkMWq5gtMeagQlbyW/l3/23RI982LG
 wQgILYlOt+jqWQE30AE/evtJ+blJij94FvwxY3v2w4gBgvDb9F2MDra3tMn+L3lqyOIDjcEb
 4+Pcfl79gCOBujjJSHQSK71lSEViUcxyJdVglkixnSomgUZ9YwARAQABzSVCZW5qYW1pbiBC
 ZWljaGxlciA8Qi5CZWljaGxlckBnbXguZGU+wsFiBBMBAgAMBQJZb2R2BQkJNDT8AAoJEBWb
 feAC1ejUDoIQAJ18QYbWXjh2l4N6TH5trhJgawqgRjCTsiscc2dR4ZmJ1m9p3YT1x/BXg5Ew
 u5/k9sPnxJtbXaRoC9SOqql6hD+GiBJJITWXhmSuZTm3fuW9ss55ekW8O/zoVugZCp758l/D
 UPnPWtlZSD5ctkMdXw3a3bYKqwaIZ8PLzGz7G12m+y2601Td98w0gzp3WDE7GcWohyM9Kk9S
 8xpqmFuF/sv1GMb6TdeflhLcsBYOXhu5RAZUfTE8xpFR4u/shLDPyKH0ckZfY+PbVx320nFS
 JOPCvBfxT8jSS1g2oKxfo+1x6l0afkoq4MvJQqy960Hd1EJhGPLmgPTEw8QjgaMHJYlOesAH
 8ZRwCCuzMJDzmI+fnt7EEwgDD/ZcYQ0k31P1Zn3hzFor5/NM0PhzSMdmq4nxGAtQ+BdG88YT
 QaGq9TNWF4Akd3ttrFXYcrKbjMtD2XisQAzt2JEyVDgQpBxTSq9btfOieQzQS8S13CHSqzDk
 8Rtj/9lBag04JuaFhsDHb6+rc4cpBh8onOmrj8qfR63EW3q0g9c18vCOrmSHMia1vvMuBtTT
 OH4novUykpyFPW9ZUvzPEwjHFR+5n90qZs4Mv/DEjl3Y6+gizyCe4OgMtUqSV2Z60rAC+q+Y
 L2rA7X1qJkF+m5sgYMZBSGwNWVrYx+jcXyYDTFkmb1SXzCjgzsFNBFXeyf8BEADGqyYWGDbp
 /jgjRVuvn8auaibwZCN+3Hg8+Ld1GPkbHquLrf4XpgcXyXegF1FaXuiM5YhcmmLyATdUvv+A
 e1S3vr5ZvXmXXD0MWPoNNtk9aJWG9aN/KGbfe9Zms/BCsz56GC2vjLrhOLdMu1bDyxjdUGQU
 NNkgotXOICDTCJ4yrjMByaL3B0uYmAo3eU7rkynWSA/OnSnTaS6DUZ27m77v9VsrzvygL5tN
 cULHR77NS7V84Hrjgn9imARz6i502VQVw4ROuJCUI0Z6+OhLE+YZxWPZ9DZqu12mfifQ0eMy
 DgkXtIdKDant0iVPdJCcwWg10GajaKeB9p0SDaOP3PnbnZ4mKuGVR57CaFFedHK2nhhVF1PS
 XQ74sJgGQzTZKAyQzvxmZCdwPYmnLjhYZrKQDCuhF/9q5O9tYVejq/u4vcCPz9Rr1+P7ah6Y
 gOIldiHdvyINgIZQH4BSUcVFPJlzYXrXYNyUrCOGeB+ZzhE3JNkpSUgXl2QJmsmIe/dW6xzI
 krQv2YlI3Lf4iwhXLgzczpDmhhcNeYinbl/5g3cQWceJzSGikc5/fF43KmRsthVcOg1D5j7u
 W1JWEqD7bTK+glTFWhIrkO2zA4J+jgMT5BPt09GMUcbT2oE5QagAlOvKCW/Dyft80qW2Iv17
 9MjPOeNyOJtD6b/RyNww4Z8DzwARAQABwsFlBBgBAgAPAhsMBQJZb2R2BQkJNDT3AAoJEBWb
 feAC1ejU5MgP/1IHReX162O6fgLd5yq1JrjmBg5aoclDQ5uurwykdH56e0mYHmoTnOH6CK05
 yUaG3+Exgd5a2qm2NOIG31bTtCExX+46v4kZh05sh8nZhTNByxQU1g8sVL/6kKW24JDf4Cdh
 82tbSqYta5wd8cb7W4Czm2Nqi2pjFl7AMBa6NIQEZcjW5TlajqRTRD2OzHqoktKCxQa1pvf7
 dJJvKOtla9dYb0MQKa3xaJG9BeuLlYQHd9X+sQfRkkQlvaXUxteEpX+mRKEKYrMO1ltABC4d
 bW2gBS+pUyni4+pH4VUdZ1fZgmRpKjJLWOyQG3JN5mm9NxKwP3AhdTDY9dsxc8YAqKD6gKKR
 KPowBBzu64wxyR7+p+t3RDSH1cANV47ODsBKaK11NZxj9edJodxKyaNKOwGaxuYIlGksgfAN
 pH5j92+oEejjOwRYTa/1L2JrU0EI2LVQ/f1BJO1sVfjiDfHL8tCvXA9fQPR11cPeYQRD+9Ss
 d2qGftS+aC/w1wpXjlP+QPLPl+k4VV+dUByhMuTxg8ykXwuhLiyikDSoK8uPsaoR1UaNVDiS
 0HdGZKNjfgZ+3dCjjsTE+ZIfgykWIyOE2SkuaDZxdsbi9eyE9rOBnakQLLeWnrdVkuLx1FI4
 92t+O5pYgt6BNqwuaQAzTKBZfI9WSj/lxYqONGqhBk4E8uT8
Organization: =?UTF-8?Q?Universit=c3=a4t_Rostock?=
Message-ID: <40ca1cb3-f608-d1bc-b084-d688d0eeea04@uni-rostock.de>
Date:   Tue, 25 Sep 2018 20:00:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180925074115.18169-1-martin@strongswan.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: de-DE
X-Originating-IP: [139.30.201.127]
X-ClientProxiedBy: email3.uni-rostock.de (139.30.22.83) To
 email1.uni-rostock.de (139.30.22.81)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 25.09.2018 um 09:41 schrieb Martin Willi:
> This small series fixes two issues for cleaning up hwsim radios. The
> first one is rather easy to hit when terminating namespaces with many
> hwsim radios. The second one affects destroy-on-close users only.
>
> Given that the use of a work-queue for deferred cleanup with namespaces
> has been and still is tricky to get right, this series switches these
> users to a synchronous cleanup in hwsim; The removal of that work-queue
> is in a dedicated commit in case we want to skip that in backports.

Indeed, this is a much better solution. I wasn't that happy with the
workqueue thing, but I didn't know a better solution :-)

I see no errors at review, but I currently cannot test it quickly.

> Martin Willi (3):
>   mac80211=5Fhwsim: fix locking when iterating radios during ns exit
>   mac80211=5Fhwsim: fix race in radio destruction from netlink notifier
>   mac80211=5Fhwsim: drop now unused work-queue from hwsim
>
>  drivers/net/wireless/mac80211=5Fhwsim.c | 44 +++++++++++----------------
>  1 file changed, 17 insertions(+), 27 deletions(-)
>
kind regards

Benjamin

-- 
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrotechnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
