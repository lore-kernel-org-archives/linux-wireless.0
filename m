Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04CAC282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 958E320870
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:38:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="jXTBqI9w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfDHHiG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 03:38:06 -0400
Received: from mout.web.de ([212.227.17.12]:44991 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfDHHiF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 03:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1554709050;
        bh=VShkqZmICf6eV4rGT0El95C9oUWz6IpqeQsQewAXvVk=;
        h=X-UI-Sender-Class:Subject:Cc:References:From:To:Date:In-Reply-To;
        b=jXTBqI9wk/pz7WWgBTyw+KU2wSJjcuqD91frJBVr6bdYCxhCfXo4/Hh1CHao7z5hz
         nmptQthFrCFoCvfqXDx34+HbgBkPPR+qUH3nhkQQccTN74S9N9lNFWAMdqwbDh+v1c
         lTDDHI82Pr/0W0Izmi56p5URs8pR+0NsXW5XmM9M=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.184.114]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M3T1Y-1gvayf42SG-00qyXg; Mon, 08
 Apr 2019 09:37:30 +0200
Subject: Re: [PATCH 3/5] mt76: fix a leaked reference by adding a
 missingof_node_put
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
        Felix Fietkau <nbd@nbd.name>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        John Linn <John.Linn@xilinx.com>,
        Yi Wang <wang.yi59@zte.com.cn>, linux-kernel@vger.kernel.org
References: <201904081455561126540@zte.com.cn>
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Wen Yang <wen.yang99@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <63a3b39a-0b01-f224-3c1c-d142519b7dd7@web.de>
Date:   Mon, 8 Apr 2019 09:37:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <201904081455561126540@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:W0XYYVf3gKwX03vcM0gWkGN9VYz76Fkk+FNo1QKMKG8IJVLJZsc
 ggG2T0c2pkq/2cpMT1rAavHYyUsYziuPs3btezM9kA3BOH4h01wIU04qN+iYAjV0MLJIaJi
 dob7arOCikkGiJI0KrrverD9lRjJJhPa0bmawVFCPglVKfWawk7NE3Ogzgq/6IhUeJzKADB
 eHkOElg3ekhY8rSg3xaRA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:IgzGU5NqPGc=:AYLypjgo0qIstYg1rzhUl0
 rJp235hUqmDs7Hc9EqOuYgdplG4rZ9Nb3vOD1k2Chqv+/GlMc6tM68uLYdD0twmuhVsIUynik
 PeMBL7JhLQj0OZKYN9KWmywoVt1z4zuZGIo++UaToQIZneG8X0AH3ccGI/xETqL1M8GYQUYc1
 9f8zX0MLaIf5voeWQpeaNhswzsheUhz6YsRNkakn3UxgGWAu6r0mzPvZZqFymYAwqn3UAPU/d
 Cs90OTLWhZAXTScZuv3ECqxVl+xKqKBUD2Yp2I0fH9VPgS1tIZAew9qf1ECtbdSL0CHTxgL5D
 VnUIHOomXpEg13LTgiuL+dqnDuRVvXcP2Zvv0FbK9BP9wXw5IbOTK0EaEq+n2fZm70jwxN6CQ
 Ag1gxph7oo8IgY9zmE2QC7BTkByRKONHj8xQRdYmCSDUSupqQbgbQBoV2aqIUJDteuxFfMkcf
 7Wlh+QRvdYZ7GMoGc94D2dztDlvhN+vK//l+WyyjCK8/COc90GZ0J6tsHmvXXpgHmBNzgWLdv
 if/2XuuQHrR7fZ61xGWMf5VNy00JkPiqg2pfKJNKAJb0asV7O0lcJO384iXImY+rp4CKRwNS5
 nkSN1jrUp+UjUHaJ9BqvDmg7UwL+I22CTRpUNKuN6z1jLbTQC2+EuQuO2gVKFdIR/YYgK8pcH
 oFl5shn4ZtBLIjssaLPdI+MLHu/V2z0oTFs4Tq/ZuKRRHvcVUDBr+brdKrCLD1siqWcdJ+z8P
 gb9Ae9n2v/9Jdfz3forQYeOV9Z5QTylcOyZxaHhX/jpIax4C0DkhEdJ0wMzs3rCgEQZTTRS8I
 qLvYKvTb2IvMd1Dy89szv6/cJ2xnUVkVJWnLyr01q0+LaI1HPXIK/Y/ZNaVl0twkvVORG0jGi
 xZdgS3mYP9VGqXqEQJ4l//HPjh8we0r/2FkjSy3auNgBw1tax4t4E9FG72u1K++HRP6CaMVJW
 Rbiktak+cfQ==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>>> @@ -54,22 +54,30 @@  mt76_get_of_eeprom(struct mt76_dev *dev, int len)
>>>          part =3D np->name;
>>>
>>>      mtd =3D get_mtd_device_nm(part);
>> =E2=80=A6
>>> +    if (retlen < len) {
>>> +        ret =3D -EINVAL;
>>> +        goto out_put_node;
>>
>> I find a jump to an immediately following source code place unnecessary=
.
>> Would you like to delete it?
>>
>>
>>> +    }
>>>
>>> -    return 0;
>>> +out_put_node:
>>> +    of_node_put(np);
>>> +    return ret;
>>>  #else
>>
>> Can another bit of fine-tuning matter here?
>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tre=
e/drivers/net/wireless/mediatek/mt76/eeprom.c?id=3D34e022d8b780a03902d82fb=
3997ba7c7b1f40c81#n73
=E2=80=A6
> We may have some different opinions here.

Obviously, yes for this implementation detail.


> Deleting the goto statement may not be good.

I find such an adjustment helpful here.


> If the code further up is changed it's easy enough to miss
> that a goto statement needs to be added here.

There are the usual consequences to consider for every change.


> Better to set ret to zero explicitly, this is the success path after all=
.

I disagree to this information because the variable was set to
the return value from a call of the function =E2=80=9Cmtd_read=E2=80=9D al=
ready.

Regards,
Markus
