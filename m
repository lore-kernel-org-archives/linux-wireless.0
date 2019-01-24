Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB288C282C6
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 07:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAF64218A3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 07:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="kTSyNkSC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfAXHxP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 02:53:15 -0500
Received: from mout.web.de ([212.227.15.14]:36515 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbfAXHxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 02:53:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1548316356;
        bh=0C21Px0xhO2cGTCG5vcSul9J7C/dR+7Ye8nZmkgibig=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=kTSyNkSC+rEPKzlFE4T/Uzed9AxCHpDD+NkMWqCAZwQVqQ2zgjoncsjxtlJFm4rrr
         GMx3Fi/GRg8m+KwrMT1oSBYzVk0du0WSs559LBMsrtQc8aAA7Nvpg1+8VW5t9iMuyE
         mMnXHf1E7V9CmjUvy15anfel6xBnRmwMKl11tpyA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.57.47]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LqlRS-1hQsNi1o7W-00eP7w; Thu, 24
 Jan 2019 08:52:36 +0100
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH v2] arm64: dts: hikey: Give wifi some time after power-on
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Wei Xu <xuwei5@hisilicon.com>
Cc:     Ryan Grachek <ryan@edited.us>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>
Message-ID: <e944650d-514f-3727-2e68-b318aab9ee7f@web.de>
Date:   Thu, 24 Jan 2019 08:52:33 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:E2H/xh7CJnHSKb0B4o6Q6pkAHqkZhOJMLpP6LghUaS5BIzd+nzA
 C6SwVXJ6/++jJlJfe6X2LlzxvVOpKQagdItdmQa+PwI1rP3B3k+K8jZk5CUoTlRgeGDUfHc
 8FzqFX7wOMlEHIOJBD7Ye4Qu7mBR7RhCA+9tLlnzjVi1VSA5ZOPYNm0Gcr3wglOuyjppCyk
 NRFFLVdqRv/JRKfxmX9pw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YICEqmHhATs=:yuiHNaZsJHXLq1GAdWDuvG
 yQfWKaVaISC0nesuiAO+Yz5uI6ri2KusxFc5psdlHoLWTJ6KQWeAaxcCdPTP1sfnLvO4QMjl4
 PopC8DzNWYkphwod42Z97UZJ6PHO1kg4qwia29h4nXdOp2Xc4XB4GJaKBybjeuJNr9okruqcd
 Ym5X+aFPIcNEb4GeWKGmRjHhXdZNpmFMGcxsH1JT2ivWkg4Y9uX+Kpy+bW5R+qsB0RnmHpcQ6
 eXcLdoAfyzMoXchs2yiXS7jxcWtHtSUV4B1GHFa2DvfxaKClqN1rUDL+01Dhp36+vTRefJWBl
 ZsObgYpo5gESGx9OrT1sqzGBKmCTDYZ18Ko2f9S9UUK4oofUT376OC7ACVWCYI8V0L8BdWvRN
 xJikMbebW9FPm1nji8RUwnTexpoGv+iGA34BGWaos5kgM/wi5p4S+0aHczrAwdKXNz71/eFJj
 9K8VYVRZiOcLBP9tmqM7Nc2HHXstXlGFOCZe5w4znwnsKcj8q1VXhKCKG8e1Ujty5vaKpOx2R
 b+vzCjHvkw8EHVr7Y7xFg6qzv04MnI1fFm4eDmVv0zKIbfx+Ib2zdU9Q9NNoBilsg3NZULUhZ
 JMMNMC/GSvFjxwDk49SOXXBELh1M6d7WE0ZwpoBhIqZBLhYbRZchmf6HJW7F5lpyflQePzvz+
 A8cnzz+zI7v5fOnLUpqwrhaCi045InIkuz6q/EdTVd5JluuvIwYhjlZDMaHWX1UfG54t0rApf
 k0zJd/iDN/ntdLdQR+Yln1HwXmCGFyZsKmPxcZvdJhRVuenkKyCCaO4GwtgqwdWsQAxp/mQ6g
 XvqbKur0Ta47PGjF0eIQ4/StmEbf0sjfNT58oJd1Bqp+mTDnlbgy69aJdwdRLWTHAV4CD8yjp
 D2lO9D/AlwJ3/acjYvgxKgvJ4OrafO5f1vpE4lxA+QTrxtr24uY4FiaykmdWnBsdy03eWambR
 f1yFtc+VcBg==
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
hikey would already be happy with 1 ms. Still, we use the safer 10 ms,
like on the Ultra96.

Fixes: ea452678734e ("arm64: dts: hikey: Fix WiFi support")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
=2D--

Changes in v2:
 - set delay to 10 ms
 - updated changelog

Who will take care of updating also the Hikey firmware dts with this
change?

 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts b/arch/arm64/b=
oot/dts/hisilicon/hi6220-hikey.dts
index 610235028cc7..ba946543dd0a 100644
=2D-- a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
@@ -118,6 +118,7 @@
 		reset-gpios =3D <&gpio0 5 GPIO_ACTIVE_LOW>;
 		clocks =3D <&pmic>;
 		clock-names =3D "ext_clock";
+		post-power-on-delay-ms =3D <10>;
 		power-off-delay-us =3D <10>;
 	};

=2D-
2.16.4
