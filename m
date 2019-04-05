Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC00C10F0F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 13:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F6B721850
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 13:16:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="YHAZHitV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfDENQ3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 09:16:29 -0400
Received: from mout.web.de ([212.227.17.11]:48507 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfDENQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 09:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1554470156;
        bh=atzy0QwMzt39s7C/7C5fNGtYD6lVMssAQ9/ipVXo3mU=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=YHAZHitVXJ+HaRGB1q0nXxM3cXp9UIk/j/z4sdgcu5vUWES4OKE8fdrRpBWpreujw
         MTZZa/Rx+0Airi60cMxfjnET9LhMyWrrsQoY6lNtK+4j2NL8taWt9jYNJEFtWt+2ng
         HgPYcax4B2xKZBI1b+G2FsGWa7FOneGIsL54Cwxw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.156.119]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MCZlG-1h35J32pl4-009N5c; Fri, 05
 Apr 2019 15:15:55 +0200
Cc:     UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Felix Fietkau <nbd@nbd.name>, vivien.didelot@gmail.com,
        John Linn <John.Linn@xilinx.com>,
        Yi Wang <wang.yi59@zte.com.cn>, linux-kernel@vger.kernel.org
References: <1550819742-32155-3-git-send-email-wen.yang99@zte.com.cn>
Subject: Re: [PATCH 3/5] mt76: fix a leaked reference by adding a missing
 of_node_put
To:     Wen Yang <wen.yang99@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 mQINBFg2+xABEADBJW2hoUoFXVFWTeKbqqif8VjszdMkriilx90WB5c0ddWQX14h6w5bT/A8
 +v43YoGpDNyhgA0w9CEhuwfZrE91GocMtjLO67TAc2i2nxMc/FJRDI0OemO4VJ9RwID6ltwt
 mpVJgXGKkNJ1ey+QOXouzlErVvE2fRh+KXXN1Q7fSmTJlAW9XJYHS3BDHb0uRpymRSX3O+E2
 lA87C7R8qAigPDZi6Z7UmwIA83ZMKXQ5stA0lhPyYgQcM7fh7V4ZYhnR0I5/qkUoxKpqaYLp
 YHBczVP+Zx/zHOM0KQphOMbU7X3c1pmMruoe6ti9uZzqZSLsF+NKXFEPBS665tQr66HJvZvY
 GMDlntZFAZ6xQvCC1r3MGoxEC1tuEa24vPCC9RZ9wk2sY5Csbva0WwYv3WKRZZBv8eIhGMxs
 rcpeGShRFyZ/0BYO53wZAPV1pEhGLLxd8eLN/nEWjJE0ejakPC1H/mt5F+yQBJAzz9JzbToU
 5jKLu0SugNI18MspJut8AiA1M44CIWrNHXvWsQ+nnBKHDHHYZu7MoXlOmB32ndsfPthR3GSv
 jN7YD4Ad724H8fhRijmC1+RpuSce7w2JLj5cYj4MlccmNb8YUxsE8brY2WkXQYS8Ivse39MX
 BE66MQN0r5DQ6oqgoJ4gHIVBUv/ZwgcmUNS5gQkNCFA0dWXznQARAQABtCZNYXJrdXMgRWxm
 cmluZyA8TWFya3VzLkVsZnJpbmdAd2ViLmRlPokCVAQTAQgAPhYhBHDP0hzibeXjwQ/ITuU9
 Figxg9azBQJYNvsQAhsjBQkJZgGABQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEOU9Figx
 g9azcyMP/iVihZkZ4VyH3/wlV3nRiXvSreqg+pGPI3c8J6DjP9zvz7QHN35zWM++1yNek7Ar
 OVXwuKBo18ASlYzZPTFJZwQQdkZSV+atwIzG3US50ZZ4p7VyUuDuQQVVqFlaf6qZOkwHSnk+
 CeGxlDz1POSHY17VbJG2CzPuqMfgBtqIU1dODFLpFq4oIAwEOG6fxRa59qbsTLXxyw+PzRaR
 LIjVOit28raM83Efk07JKow8URb4u1n7k9RGAcnsM5/WMLRbDYjWTx0lJ2WO9zYwPgRykhn2
 sOyJVXk9xVESGTwEPbTtfHM+4x0n0gC6GzfTMvwvZ9G6xoM0S4/+lgbaaa9t5tT/PrsvJiob
 kfqDrPbmSwr2G5mHnSM9M7B+w8odjmQFOwAjfcxoVIHxC4Cl/GAAKsX3KNKTspCHR0Yag78w
 i8duH/eEd4tB8twcqCi3aCgWoIrhjNS0myusmuA89kAWFFW5z26qNCOefovCx8drdMXQfMYv
 g5lRk821ZCNBosfRUvcMXoY6lTwHLIDrEfkJQtjxfdTlWQdwr0mM5ye7vd83AManSQwutgpI
 q+wE8CNY2VN9xAlE7OhcmWXlnAw3MJLW863SXdGlnkA3N+U4BoKQSIToGuXARQ14IMNvfeKX
 NphLPpUUnUNdfxAHu/S3tPTc/E/oePbHo794dnEm57LuuQINBFg2+xABEADZg/T+4o5qj4cw
 nd0G5pFy7ACxk28mSrLuva9tyzqPgRZ2bdPiwNXJUvBg1es2u81urekeUvGvnERB/TKekp25
 4wU3I2lEhIXj5NVdLc6eU5czZQs4YEZbu1U5iqhhZmKhlLrhLlZv2whLOXRlLwi4jAzXIZAu
 76mT813jbczl2dwxFxcT8XRzk9+dwzNTdOg75683uinMgskiiul+dzd6sumdOhRZR7YBT+xC
 wzfykOgBKnzfFscMwKR0iuHNB+VdEnZw80XGZi4N1ku81DHxmo2HG3icg7CwO1ih2jx8ik0r
 riIyMhJrTXgR1hF6kQnX7p2mXe6K0s8tQFK0ZZmYpZuGYYsV05OvU8yqrRVL/GYvy4Xgplm3
 DuMuC7/A9/BfmxZVEPAS1gW6QQ8vSO4zf60zREKoSNYeiv+tURM2KOEj8tCMZN3k3sNASfoG
 fMvTvOjT0yzMbJsI1jwLwy5uA2JVdSLoWzBD8awZ2X/eCU9YDZeGuWmxzIHvkuMj8FfX8cK/
 2m437UA877eqmcgiEy/3B7XeHUipOL83gjfq4ETzVmxVswkVvZvR6j2blQVr+MhCZPq83Ota
 xNB7QptPxJuNRZ49gtT6uQkyGI+2daXqkj/Mot5tKxNKtM1Vbr/3b+AEMA7qLz7QjhgGJcie
 qp4b0gELjY1Oe9dBAXMiDwARAQABiQI8BBgBCAAmFiEEcM/SHOJt5ePBD8hO5T0WKDGD1rMF
 Alg2+xACGwwFCQlmAYAACgkQ5T0WKDGD1rOYSw/+P6fYSZjTJDAl9XNfXRjRRyJSfaw6N1pA
 Ahuu0MIa3djFRuFCrAHUaaFZf5V2iW5xhGnrhDwE1Ksf7tlstSne/G0a+Ef7vhUyeTn6U/0m
 +/BrsCsBUXhqeNuraGUtaleatQijXfuemUwgB+mE3B0SobE601XLo6MYIhPh8MG32MKO5kOY
 hB5jzyor7WoN3ETVNQoGgMzPVWIRElwpcXr+yGoTLAOpG7nkAUBBj9n9TPpSdt/npfok9ZfL
 /Q+ranrxb2Cy4tvOPxeVfR58XveX85ICrW9VHPVq9sJf/a24bMm6+qEg1V/G7u/AM3fM8U2m
 tdrTqOrfxklZ7beppGKzC1/WLrcr072vrdiN0icyOHQlfWmaPv0pUnW3AwtiMYngT96BevfA
 qlwaymjPTvH+cTXScnbydfOQW8220JQwykUe+sHRZfAF5TS2YCkQvsyf7vIpSqo/ttDk4+xc
 Z/wsLiWTgKlih2QYULvW61XU+mWsK8+ZlYUrRMpkauN4CJ5yTpvp+Orcz5KixHQmc5tbkLWf
 x0n1QFc1xxJhbzN+r9djSGGN/5IBDfUqSANC8cWzHpWaHmSuU3JSAMB/N+yQjIad2ztTckZY
 pwT6oxng29LzZspTYUEzMz3wK2jQHw+U66qBFk8whA7B2uAU1QdGyPgahLYSOa4XAEGb6wbI FEE=
Message-ID: <799adbb0-23a6-bf20-f22d-4af68e9d0012@web.de>
Date:   Fri, 5 Apr 2019 15:15:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1550819742-32155-3-git-send-email-wen.yang99@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:W3kNYrBc8AKtykL9Dq230dWPIhCj6tv19ySScl31XMbF3+hwfdH
 hSvglv2gF6UTpIFPKuj/QQOUVyqwpUwW6lkSJ1kuqvE4cC6jONjaOAl5hlCOFPIzer2ZhTT
 Ld5ZMGHglvvkcoCRUQupzxQD6zmA8GFFgeaUqGBT59DE6etVMz9Jil+jqloSRBqba24VqXx
 jqI4InF6M4L5NzA+YTrdg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:V1W+fUJIsSc=:E4Q22nIKsPrJezUzeF6XKj
 m6DeObn2im2InV4mtkGZvXSOOVj5rDsw973keuVM2v7lSXjB7hf2LUuzjm1iCTb9CPWD8f/qi
 5sBb4jgEC1E2RRsSKZX/RigVRGII/JEZGvTqkap/PF1q1KVNXdSJKsO+Bih7ZJhp6kyGLyHpr
 hs0MdADFy7ZA/7kVa/o7ZCzqIWuIh4O02dtpIWYHI8+k1rwZ1zGXCyYLxbMuVIGT2jw08DNpD
 XnP3sK0Jy0OYB0tLXVMgFYX3LwIVgY8bkdGCjqwzWe/L6fAsyLgY1ApFaiBLhm4t/SviZ3rL8
 eGDpF/Upf8RJiTsB5pvpzRmlDJUvp1g0jY/VMXCqyqY7O/HKsDTRLRwlmlBkGXYyPN4pA5HtT
 YO5W8gSYf4fyyMLqfbmhguYn/67sbmw0wNxDB5WN20RbHs39oVmJTcJNDB4caGlqZ8j0lqHWU
 m+WWINvK2Wlpooi2iEboXk8DgmnUYTJ7hezzRpSd+YscVmcR0kW2wrPQ0rN0NEvy916g3XCGa
 Lyzl9cDvY8/1XUEcIwmTRkCNw5aTcbNph2BZhrRGPneDCi8NamJVmwchDndy6Ew/b8Mue9t/9
 /ipqHaYJPNfAv5Z/pyANv4/X7/WUD4z6xLhDHkXbGfV9KI2HDrJbM8QMhLpgN9h6ZqUcjJDaT
 e1WZY/JXOxZmYMW7Qchgr9raa+vCmLDg5+Kn80Daufq3T4weKwyHrJrdJE6pbGQZmJPGTriFK
 WOR5sJVDYABFUMvHaXGQVeaGE9BGSwOfJdqYKBeZXiNFOf2AaWBD2Acw8sApSUbEF3J5vEQ88
 Sm297Gm18uN3zxPb8GRAcKEeROnleBzjRXtQTZfDYTzupXdLG7+Wp9hHWNNwwPjBzrPeYu8VK
 RqoWfl7Okd0iasB2gVMAmfyAOOFEotJutndLOuvnIdiOPtMIwJy4G7biCCbUBgP3kzU5FY+Zv
 EMyKg724/jw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> @@ -54,22 +54,30 @@  mt76_get_of_eeprom(struct mt76_dev *dev, int len)
>  		part =3D np->name;
>
>  	mtd =3D get_mtd_device_nm(part);
=E2=80=A6
> +	if (retlen < len) {
> +		ret =3D -EINVAL;
> +		goto out_put_node;

I find a jump to an immediately following source code place unnecessary.
Would you like to delete it?


> +	}
>
> -	return 0;
> +out_put_node:
> +	of_node_put(np);
> +	return ret;
>  #else

Can another bit of fine-tuning matter here?
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/d=
rivers/net/wireless/mediatek/mt76/eeprom.c?id=3D34e022d8b780a03902d82fb399=
7ba7c7b1f40c81#n73

Regards,
Markus
