Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77758C282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 07:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 412972184C
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 07:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="WlF8/SST"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfAXHyn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 02:54:43 -0500
Received: from mout.web.de ([212.227.15.14]:52863 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbfAXHym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 02:54:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1548316461;
        bh=Dv4ZwO8L8U1FGc4j1RQ51QfvFFkYO8rw6uipT9+UUAA=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=WlF8/SSTGsZQUwSCow9pjsv9HqWE4A68uGPb/3MdESou62jRxDS3QbJzdg2eeyv7x
         n2sPeAksRttJNbLKSXMQV0F5QgBG0BALKt0QCqSCPyKeFe7x6/jkw6+Elopd0Scgxy
         F4hYrLFY2iemAvJSb9eLynBm0akNk95/yKbHUbQU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.57.47]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M3Spk-1h4FHY3GN6-00qwiz; Thu, 24
 Jan 2019 08:54:20 +0100
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH] arm64: dts: zcu100-revC: Give wifi some time after power-on
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Wei Xu <xuwei5@hisilicon.com>
Cc:     Ryan Grachek <ryan@edited.us>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Michal Simek <michal.simek@xilinx.com>
Message-ID: <5eace97d-1b6f-60eb-98da-588a485fce18@web.de>
Date:   Thu, 24 Jan 2019 08:54:18 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uacCtbOIByhj7998d9jrhut9SYPLXGRUtoBT+E0E5J0t/eZHAvY
 Mx3uwBtvNe4hLLV/PQaE5JvLaZhpyDAtmTWEtGWDJuqqomN1n7sF/5azKUDypIp5V3FmplB
 7DNk4+GTiOA9sL6BBCOG+lOtdNIfaJ9OCXep4hGBVYA2OkvZRCk0TLEcTcUiDj48nnOAqoU
 4aNO8yrzaGvZntugYByMQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:u55lFuGdA5E=:JHN/ujzzN3qIoqmtSGoWH1
 0kTCntwqpfKB0zIeXmab0H/Fs9ztUlwXXNmp9VKP3vUtlPf6TCE0h6YVOK386gbPO4wZeU1JE
 mg6gMNbHDatL1X+71MhCDBV2f/Q3o6pUjYeDrgqQfqIKRxPMCcb+4jOZS3LnGuYRP8Zs3hKwT
 ZgZqJe5sEaVLYtqAEqZOGerGzUcV10eIYZVk+rgD/UgkplaLFF4HpwZQ06+GciVYW0K/wWrfO
 9SVxuW1t+zONW7OFdCFhzVp0mDSCDbYlGKSWRcJ7xHocKZb1nnItYPfqRqI6oFrxqlLIvMVKg
 7txlt0iDR6/kTq4x4VvqqNkqTMmuGBOoDNJdnOZKSlczZqEJkMH7gTR3C7ySC3fhaiw2JgRYO
 QMp6wkWpykNUUKxptJ2D7OSa9kDAabyBaZ9S2SC1DkeNVd3+CMYJQYHG4mH4k7ncq4Xj18igf
 RfRAtWCkEfbxOOpoTvNhNFAfk4uMJbG92MZu1G2whVmOMsSQCA4ulnoD76nNokYj3HiRK35LO
 al6KfbzmXcRzT3fsRxK5F3cRQryf8tn4G3s20bx0nlMkezo9QqgIT3HMjbXmcn8w0KVuzrytv
 FEEkK9bbXurFZeIHnUh4Uo71pP5eai5TFsy67BLKh8QOHuwWMXWkDwFM6zMi20HPdn5DisOSS
 uz6QwSjHM/psZqz4Z0Faw4dRBcAMlNei59OFflZKXsbCuHbpu9P8FsUS+N2tforFrlPtuebWj
 ttKpyLhsZEqKCdMoylLeSTlem8sRpVyhmYNAv04IiznXp5BA7UyCftcYvedXcz+/yvQf3K2ID
 aOt8LoAKo8W/+k4F52LM6ZH4M7iZoG4FpZ1biSiZ9XgZaKqOKN9M72P6T4Oymi2qFTClDAP6Q
 FmwjaPLLBCdoOMU+22Pw5+vYWiXECRqBN8nKg1FPqLqA7AdqY2SdQkTuLoLHrCv2lGEshCSdv
 LSkdQXf3o/w==
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
stable again. In contrast to those other users which define 200 ms,
Ultra96 is already happy with 10 ms.

Fixes: ea452678734e ("arm64: dts: hikey: Fix WiFi support")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
=2D--
 arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts b/arch/arm6=
4/boot/dts/xilinx/zynqmp-zcu100-revC.dts
index 13a0a028df98..e5699d0d91e4 100644
=2D-- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
@@ -101,6 +101,7 @@
 	sdio_pwrseq: sdio-pwrseq {
 		compatible =3D "mmc-pwrseq-simple";
 		reset-gpios =3D <&gpio 7 GPIO_ACTIVE_LOW>; /* WIFI_EN */
+		post-power-on-delay-ms =3D <10>;
 	};
 };

=2D-
2.16.4
