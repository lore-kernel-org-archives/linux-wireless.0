Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6EBC2D0E4
	for <linux-wireless@archiver.kernel.org>; Sun, 15 Nov 2020 21:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC932242E
	for <linux-wireless@archiver.kernel.org>; Sun, 15 Nov 2020 21:58:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="TDax/LkB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgKOV6A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 15 Nov 2020 16:58:00 -0500
Received: from mail-02.mail-europe.com ([51.89.119.103]:39962 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKOV57 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Nov 2020 16:57:59 -0500
Date:   Sun, 15 Nov 2020 21:57:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1605477442;
        bh=SvYv26W00qWMnNNZZ5RiYQ0LhVC2NO0HCG1IYkSAsBE=;
        h=Date:To:From:Reply-To:Subject:From;
        b=TDax/LkBP4+EAyfupjlPUEC+VAqrp2HBYow381qd1KLE4wWTl338Hr+ZJwADCZPzM
         nWaP7tiAEFLRs2BALrKZg47ChoXYt8hme7TUtQIO28SRws/Qt0Zbhkk6t0erNO3X46
         yaF1usBjVpyvSeNeiJwiqSUHBZ7B0rTCdKJxDjtE=
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   cristian_ci <cristian_ci@protonmail.com>
Reply-To: cristian_ci <cristian_ci@protonmail.com>
Subject: mediatek: mt7601u: driver fails
Message-ID: <7ZXTz4VMY76wIhNnRJtybPhyH_bQKtHuyH_v1n8hpRMmoeid8dFjHii1hOmEcib1q5KH2o8SlUAT6XZyTX1PKh15zT5-feZdNdaIeHgC5K8=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When I connect usb wireless adapter:


Bus 002 Device 111: ID 148f:7601 Ralink Technology, Corp. MT7601U Wireless =
Adapter


I notice continuos spamming messages to dmesg output:


mt7601u 2-1.3:1.0: rx urb failed: -71
mt7601u 2-1.3:1.0: Error: MCU resp urb failed:-71
mt7601u 2-1.3:1.0: Error: MCU resp evt:0 seq:5-4!


and:


mt7601u 2-1.3:1.0: Error: mt7601u_mcu_wait_resp timed out
mt7601u 2-1.3:1.0: Vendor request req:07 off:0080 failed:-71
mt7601u 2-1.3:1.0: Vendor request req:02 off:0080 failed:-71
mt7601u 2-1.3:1.0: Vendor request req:02 off:0080 failed:-71
mt7601u: probe of 2-1.3:1.0 failed with error -110


and then device is reset,, disconnecting and reconnecting itself in a loop,=
 making mt7601 module to fail probing.


This failure happens just only with linux but not with 3.0.x kernel series.=
 Just newer kernel versions are affected.


If I make the following changes to drivers/net/wireless/mediatek/mt7601u/ph=
y.c source code, mt7601 module is successfully probed, instead.


In order to do that, in mt7601u_init_cal function you have to comment these=
 lines:


ret =3D mt7601u_mcu_calibrate(dev, MCU_CAL_RXIQ, 0);
if (ret)
  return ret;
ret =3D mt7601u_mcu_calibrate(dev, MCU_CAL_DPD, dev->dpd_temp);
if (ret)
  return ret;


In mt7601u_phy_recalibrate_after_assoc function you have to comment this li=
ne:


mt7601u_mcu_calibrate(dev, MCU_CAL_DPD, dev->curr_temp);


Waiting for an answer, thanks in advance,


Cristian.


Sent with ProtonMail Secure Email.


