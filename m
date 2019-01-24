Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92F8C282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 08:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26542184C
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 08:29:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="VQmW85wD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfAXI3a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:29:30 -0500
Received: from mout.web.de ([212.227.17.11]:60669 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfAXI32 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 03:29:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1548318542;
        bh=1r21Sy62YGvEHyGOIqlYMcXiaQ/0qzp1Z8NCgkKtHJk=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=VQmW85wDyf6plBmW5Z6aUJaNShfyQGtbzrDJ5Fx6vX0CTAeGkC1u2idROMi5ypm43
         ScLkeyFkUIFFt/PFK8VbFO/HmfdS63QGQSxzgqM7VXHwfM1Pna+UwZCSZ9q+1IxkqU
         DT3MDcIftaErLAyj9CppxomF5LwMO0gFb+Pd56Jw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.57.47]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M2Mcy-1h5Lic2jCu-00s9gq; Thu, 24
 Jan 2019 09:29:02 +0100
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH v2] arm64: dts: zcu100-revC: Give wifi some time after
 power-on
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
Message-ID: <efc793c8-da17-e267-851e-f08f097843ee@web.de>
Date:   Thu, 24 Jan 2019 09:28:59 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LfoHBbu6n/J0IfRda96ujoN9PIMATj0xyLxopAnv3qbFor8rakt
 9vjfI8vaktmfwTdZh8EcYNp6mShlEniEss/Kp382n4R+WsTQm8JxCcFpwz/F5LWZ4XKaq2J
 DLV965TikFw8bte5/exjf8qdtM7z2HQeLcouyQGAkKtreplyP4rtBShAx3+TppAyGE47sXZ
 WHNuYgBac6Lciql9GHyaA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:n30gWnQQXn8=:P+Ivq1q1goQsWI9fBrcuia
 8HU5nDHJNcaBWJqPrMQSG/4deGdzgNbdWgk8elpO+4xyIJS0QEqvRSDF2807Y0Bg3Q4yq7Gbc
 Bv6I6SSLvrdbHTP9nRsdvfBtYVFOk7K/uB/TpogdrDaatH5proHG3vnrPaPb9tGncJy6UMDNd
 82KHo5mtP+HhbgyyFFi4GvJs48kaq3EkzQXMQdf6w6UvuluSjEpn54hC9MRuancWmq12YPaRq
 he3hxn9YdLYyarOMaJspbIApTAFfy5X1X+/KczHTj54VUdT/cfKv11+PCaenMDebVgOiV8uXD
 zJkcmTDuj4GpzwelrYO9FrZqRgflpOk1mHQCE5poEklGx1hUqcAcIx6km8x3YXgo4sdXsaaXq
 u9RMtrzvl1yk/cP/W4DFlBhPNTKnjvain1DmazCW1l4jTh+mwhWqBLs6prhOBhm9Rr1ZMF9Hm
 pQppNklLSJ/f/S9S/ny5txE2IBMf0zQDYguAQWnQ1mco/bFO9RwQyCZSF6azevoFsAGUXgL7R
 rpFyQKDbjirnD8SYBAIg+lPfYoseV/UzzrjlA/zLQS+QHrpsOzo/mMG6WAJ8kURyquSKM+Kry
 Dt8GR7cCLjAMlI0xP3jQnzg5PnvaLSXizjXL265yQZ6iY3LndijahpHXnTmQxULJaJjKOIq2D
 Q+qnBmiP1/YaE6yRBVKU+SlNIA6++VuT7/WNfObfa4ATK0LlfEDAjgnusCgZhXrA866YxqQRt
 9pvZARcby/ldJZQtgGSpZ2F4wgqwczgv5NzQOtwEtq5qjlRLl23QAZcwSMHKbzy9VmXB6ga1W
 +/whvrTLiONxyzTs/3xCevhDKQuJN/ARB9DUNdkP41sO3JIyajG6eaGUfnto1drKOdUjP2AYG
 Dr4gwjNlGVY4Xlp3D+ucx8drp8S5kW2gsbtEqh2bu9u7GNropEbl/9fVqjF9NT531rXIb0nYM
 V/0R/+t71wg==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Somewhere along recent changes to power control of the wl1831, power-on
became very unreliable on the Ultra96, failing like this:

wl1271_sdio: probe of mmc2:0001:1 failed with error -16
wl1271_sdio: probe of mmc2:0001:2 failed with error -16

After playing with some dt parameters and comparing to other users of
this chip, it turned out we need some power-on delay to make things
stable again. In contrast to those other users which define 200 ms,
Ultra96 is already happy with 10 ms.

Fixes: 5869ba0653b9 ("arm64: zynqmp: Add support for Xilinx zcu100-revC")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
=2D--

Changes in v2:
 - fix changelog

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
