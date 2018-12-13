Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5D2C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8096B2086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:53:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="HK6vgmni"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8096B2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=ti.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbeLMOx0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:53:26 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:32944 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbeLMOx0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:53:26 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id wBDErLG0113688;
        Thu, 13 Dec 2018 08:53:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1544712801;
        bh=f7VY4Z3gGV6eB6Le+1j72Q80oURNRIsisO+q/KSJm+A=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=HK6vgmni6v/EcgYtU8LvimvsdzIz0I/1OpuNQiyHZ+0HqEqb7UYJc2rlBcepX2i1h
         sd42oL9cIMPfSweRoMefPfZ69Hhd2ap2R0xRvru1Df226i4kC5fufAppDWg8gL5b1/
         AoPccKItTU8HhKDNqnosg6RMKaaVwHkF31lvig3o=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id wBDErKMw035318
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Dec 2018 08:53:20 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 13
 Dec 2018 08:53:20 -0600
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.1591.008; Thu, 13 Dec 2018 08:53:20 -0600
From:   "Reizer, Eyal" <eyalr@ti.com>
To:     Tony Lindgren <tony@atomide.com>,
        Ricardo Salveti <rsalveti@rsalveti.net>
CC:     John Stultz <john.stultz@linaro.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "anders.roxell@linaro.org" <anders.roxell@linaro.org>
Subject: RE: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime PM
 autosuspend support change
Thread-Topic: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime
 PM autosuspend support change
Thread-Index: AQHUkbxvUowIl7JGdE2qw59YlHGbqKV6synggAEfrwCAAA7kAIAAaVEwgADMRACAAA6+AP//nPHg
Date:   Thu, 13 Dec 2018 14:53:20 +0000
Message-ID: <12a609f677aa48f8b2aadba69edf342a@ti.com>
References: <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com>
 <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com>
 <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
 <20181212183116.GH39861@atomide.com>
 <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
 <9060b4655e064665a1812d9fae00f1ec@ti.com>
 <CAHYQr0r4eQNSqZEr-vbCiVN6G_O1CXxX9cxemANSRY-jqDMZ=A@mail.gmail.com>
 <20181213144522.GO39861@atomide.com>
In-Reply-To: <20181213144522.GO39861@atomide.com>
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

> > I tried just increasing WL1271_PRE_POWER_ON_SLEEP from 20ms to
> 50ms
> > (which gets used before calling wl12xx_sdio_power_on), and that was
> > already enough to fix my issues on both hikey and beaglebone black
> > wireless.
>=20
> OK good to hear that helps :)
>=20
> > Should we define another pre power on sleep specifically for the sdio
> > case (and use directly in wl12xx_sdio_power_on)?
>=20
> I'd probably prefer to just increase WL1271_PRE_POWER_ON_SLEEP,
> chances are the same delay is needed in all cases.
>=20
> Up to Eyeal to decide though as far as I'm concerned.
>=20

I tend to agree with Tony. Probably better to just increase the value.

Best Regards,
Eyal
