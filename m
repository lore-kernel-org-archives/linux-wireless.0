Return-Path: <SRS0=Iw3I=PH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73F2C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 11:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A022B20866
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 11:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="q1BmTV9c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbeL3Liq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Dec 2018 06:38:46 -0500
Received: from mout.web.de ([212.227.15.14]:56771 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbeL3Liq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Dec 2018 06:38:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1546169894;
        bh=KXZfDwshm/FJGxu0rScN7SO1Em2NUsg9uBqnj5WMhyk=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=q1BmTV9cWOxHkdOqhEgsas5LnJppa6rsnWVp8Be6BGogavKbkT8Xy+GPdDd1i/KwK
         ERRJk8mvF5nCR3qWI5bGQKiD4f4O1Ay132Bj3T1oIvm8CRizJjxne58DeS8d8FUwDh
         uYpolZS5gVu9kDI4WjdPxa0TTc09KkMBXqeCqdoM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.57.47]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M09z2-1hTBbV3YQG-00uEu1; Sun, 30
 Dec 2018 12:38:13 +0100
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Wei Xu <xuwei5@hisilicon.com>
Cc:     Ryan Grachek <ryan@edited.us>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH] arm64: dts: hikey: Give wifi some time after power-on
Message-ID: <6ccac7db-3ab7-e396-90be-8681a8ee336b@web.de>
Date:   Sun, 30 Dec 2018 12:38:11 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:un60TQF6vezWeQPfwPpE6ncRDplfXim5XjEifJSImVhG+OOJZWm
 J/drw4EU+b0NwRVG2NKNd8l7VKFnycpQXraoZqJogIDhovZrB0JM5MYxbXfGMc/MIxhXv5b
 UEXhqYGVfngD5dnGVl69rXEpYLHR5lEV3Yv8aKqrzm1iCM78XZzIO01DeEvse0m65i5zyg/
 DLJlDSTX2fosFaqQPsiLw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:l0OLpdLXsoE=:YFuKtvjd2x8LOTB2lDrwRi
 zITKbEjIDlDYgfyOnM1FpIclXjQuY/BwJ0or2pSPCMQUgG1R9rcuoEiIkK4ut+qx/EOpqDB8V
 1uC/nhIrJ5nsqRD5cyuM/R6xl/Lv/J9fhIELlOFjTSpxdyw/VvAlcrtEAesHTQZdIAtneTCqJ
 ln77a1tL4qGEiRwXll7XTQUGa5S6buPLe4+aSoYaZE97NRKsXZlvvon8RKOYk4NrW/JbIwbPR
 iZx7ACW9UjKuoO86LTkFVaArVKyH1I9CDVkXnfyN2Crp8WJZdQrOZ8+zGf46TGTB3WSxnGgXS
 CTIp8GJM5dx1JV1+Iq6A1tn2hOAHWXHRJ9k6hiv6ZbHQdYqmi8AKHYYYqtnGyS96d0RANMTLp
 dqIIByfg9A5g8oUkKgquVJVDsNq4VlR23YQ05SNxVHGe9aHTYKmJoJygfnhyzXamAv0oLk3wF
 sfBhQXulAUHKmp7zngF9hbb0BGCeWlBnkVEMt41dmpgedSw0PPJ27KzpGQBmpK3Ph7IKcmKaQ
 Lke68sCiJrpMxanu07rju7PNhs+9i78I0Rd3/UJ7WoPbpnv3vAKx0y+a4gs+afS2SE2/YTYoZ
 fW+6rk1+WdZGlxE03lDw8BGvCzenQsA/+Sx/8LD7NrUn+19vmvLdjDRgNF54GObPRrnMWU8mz
 kJ1VgQVnqHDg45t9+q2HYhIyUZaAilgRzmi6mITX1xT2q8jF3ZMVcQXzmYQZyzK+N3dFssAgn
 XdD0GKWyCTV/V7IOfX5T+oCeA6JODL5TOVS9+DgrAotFTxs7ojhZYF9ZggprT4el0YyeMeELK
 7p+9Tr0fx02RQ490l+Ntr1GAu3mx6bzYPLp7kbwcqN7XfWmFP0P71lZrnVU2sedsGImEc6LKy
 NUva2KEQ/n6B76pc7tTTOlbAqsc7WJU7TB54/Yze0qQUiwz2iZl0d4U640z3Yz
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Somewhere along recent changes to power control of the wl1835, power-on
became very unreliable on the hikey, failing like this:

wl1271_sdio: probe of mmc2:0001:1 failed with error -16
wl1271_sdio: probe of mmc2:0001:2 failed with error -16

After playing with some dt parameters and comparing to other users of
this chip, it turned out we need some power-on delay to make things
stable again. In contrast to those other users which define 200 ms, the
hikey is already very happy with 1 ms.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---

Tested with 4.19 and linus/master.

  arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts | 1 +
  1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts 
b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
index f4964bee6a1a..1e771bf201b9 100644
--- a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
@@ -118,6 +118,7 @@
  		reset-gpios = <&gpio0 5 GPIO_ACTIVE_LOW>;
  		clocks = <&pmic>;
  		clock-names = "ext_clock";
+		post-power-on-delay-ms = <1>;
  		power-off-delay-us = <10>;
  	};

-- 
2.16.4
