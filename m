Return-Path: <SRS0=iJrv=PA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAF0C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 07:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F22BB21905
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 07:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="H3zWHR6q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbeLWHiW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 23 Dec 2018 02:38:22 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:52586 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbeLWHiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Dec 2018 02:38:22 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id wBN7cGc8036836;
        Sun, 23 Dec 2018 01:38:16 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1545550696;
        bh=BPsnA3gxkNT7gFqy/4Tl4vDQJHpJ5APlv/s+RVamWz0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=H3zWHR6q1Nc80Sl3ABopsUH2c+jAicaLWG9AgAnLdu71OVeOAonpxQZCvOqGrOoWk
         BYrKvP1Snn/QL4WdS73mm1emnwoMkUiCbQN44eSv5rIA5yS3rPIeFVx0rCMnGaa60K
         OJ0Si5pAy008jNeOVt8DqdjP4V9XQ8sEc2Z4+I2o=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id wBN7cGIH101064
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 23 Dec 2018 01:38:16 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Sun, 23
 Dec 2018 01:38:15 -0600
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.1591.008; Sun, 23 Dec 2018 01:38:15 -0600
From:   "Reizer, Eyal" <eyalr@ti.com>
To:     Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
Subject: RE: [EXTERNAL] Re: [PATCH] wlcore: Fix bringing up wlan0 again if
 powered down briefly
Thread-Topic: [EXTERNAL] Re: [PATCH] wlcore: Fix bringing up wlan0 again if
 powered down briefly
Thread-Index: AQHUls4N7t5ZtH4jYkq05gZUoQOmDqWFCu+AgALFvoCAANmugIADScZg
Date:   Sun, 23 Dec 2018 07:38:15 +0000
Message-ID: <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
References: <20181217164207.20081-1-tony@atomide.com>
 <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com>
 <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
 <20181220231401.GG6707@atomide.com>
In-Reply-To: <20181220231401.GG6707@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.25.139]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > > > Instead, it looks like what you need, is a way to keep track of
> > > > whether the SDIO card, became power cycled or if it stayed powered
> on,
> > > > when "ifconfig wlan0 up" is done. In case of a power cycle, you nee=
d
> > > > to re-program the firmware, right?
> > >
> > > Yeah mostly. But we also need to ensure things do get powered down
> > > properly after ifconfig wlan0 down :) IMO after ifconfig wlan0 down
> > > returns, there should be no waiting needed.
> > >
> > > > Would it be possible to re-program the firmware, even if the SDIO c=
ard
> > > > stayed powered-on?
> > >
> > > That might help for some cases, but the problem of how to ensure the
> > > card is powered down after ifconfig wlan0 down returns still exists.
> >
> > Well, does the SDIO card really have to be powered down before
> > "ifconfig wlan0 down" returns? If so, why?
>=20
> Good question. Eyal, any comments what should happen here from
> the wlcore hardware point of view?
>=20

You are ok as long as the wlan_enable pin Does go down for a sufficient amo=
unt of time=20
turning the wl18xx device off.
The firmware can only be downloaded once after power on.
In between down/up you have to make sure the wlan_enable is fully going thr=
ough on->off->on=20
and the wl18xx device is fully reset.=20
On power on the firmware is loaded by the driver and this will fail in case=
 the reset didn't happen
.
> > An option would be to call pm_runtime_get_sync() at "ifconfig wlan0
> > up" (I assume you already do that) and then re-program the firmware,
> > even if the card hasn't been power cycled. Wouldn't that work?
>=20
No, this wouldn't work in case the wlan_enable pin didn't reset the chip as=
 part of the=20
"ifconfig wlan0 down" Command.

> Ricardo, care to test and see if the problem comes back if you
> keep PM runtime enabled?
>=20
> > Or perhaps this is the problem you are encountering, that the FW can't
> > be reprogrammed, unless the card has been power cycled? You can easily
> > test that, by simply bumping the runtime usage count for the card
> > device via sysfs, before doing the "ifconfig wlan0 up/down" thingy.
>=20

Correct. The firmware can't be reprogrammed , unless the card has been powe=
r cycled.

> Ricardo, care to play with this too?
>=20
Best Regards,
Eyal
