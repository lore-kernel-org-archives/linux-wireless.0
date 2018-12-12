Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AECC04EB8
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 07:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA312084E
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 07:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="URSozzNH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAA312084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=ti.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbeLLH1h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:27:37 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60620 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbeLLH1h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 02:27:37 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id wBC7RTW4026248;
        Wed, 12 Dec 2018 01:27:29 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1544599649;
        bh=3O7PAnnCoxSOdcyzDdk1oe89H/7CyGDydvrkWBctRUs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=URSozzNHgTgu/cEtYO4Jgoo+GjwmzfJPIEPacAyfIybOti0KTskrtS041AYnCgUM3
         05RqAe7YerOQsd6p0gg0qYNALyZWrnXHRr2h+a6ocRmAqlTn+rT6R8p1BbhcToP3vb
         f4SJ3yQCwsJYo0vO/qsjLSwKAZxCkLGgxT8bCQ+w=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id wBC7RSso057268
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Dec 2018 01:27:29 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Wed, 12
 Dec 2018 01:27:28 -0600
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.1591.008; Wed, 12 Dec 2018 01:27:28 -0600
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
Thread-Index: AQHUkbxvUowIl7JGdE2qw59YlHGbqKV6syng
Date:   Wed, 12 Dec 2018 07:27:28 +0000
Message-ID: <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com>
 <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com>
 <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com>
 <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com>
In-Reply-To: <20181212014556.GC39861@atomide.com>
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

>=20
> * Ricardo Salveti <rsalveti@rsalveti.net> [181211 20:45]:
> > On Tue, Dec 11, 2018 at 6:23 PM Ricardo Salveti <rsalveti@rsalveti.net>
> wrote:
> > >
> > > On Tue, Dec 11, 2018 at 6:12 PM Tony Lindgren <tony@atomide.com>
> wrote:
> > > >
> > > > * John Stultz <john.stultz@linaro.org> [181211 19:51]:
> > > > > On Tue, Dec 11, 2018 at 11:25 AM Ricardo Salveti
> <rsalveti@rsalveti.net> wrote:
> > > > > > Then tried to reproduce with a simple 'while true; do ip link s=
et dev
> > > > > > wlan0 down; ip link set dev wlan0 up; done;' and it was already
> enough
> > > > > > to cause the same hang. Adding a simple sleep 1 after down/up i=
s
> > > > > > already enough to make it work, so something might be missing
> during
> > > > > > the down/up process that only happens when they get called righ=
t
> after
> > > > > > the other.
> > > >
> > > > With while true test above, I'm getting:
> > > >
> > > > wlcore: ERROR timeout waiting for the hardware to complete
> initialization
> > > >
> > > > Then after ctrl-c, wlan0 connects to the access point just fine
> > > > for me.
> > > >
> > > > Is that what you're seeing or some oops?
> >
> > Tried the same while true test on my beaglebone black wireless and
> > also got a trace, but without hanging the kernel (sdio write failed
> > instead):
> >
> > root@beaglebone-yocto:~# while true; do ifconfig wlan0 down; ifconfig
> > wlan0 up; done;
> > [   31.467917] wlcore: down
> > [   33.205670] ------------[ cut here ]------------
> > [   33.211048] WARNING: CPU: 0 PID: 407 at
> > drivers/net/wireless/ti/wlcore/sdio.c:145
>=20
> Hmm OK so SDIO write failing. Adding also Eyal to Cc.
>=20

I Just tried on an available am335x-evm using 4.20.0-rc1 which I believe ha=
s all the patches merged already.
I am using the same script  and not seeing any failure yet.
See below:

root@am335x-evm:/usr/share/wl18xx# uname -r
4.20.0-rc1-11287-gf487c00
root@am335x-evm:/usr/share/wl18xx#
root@am335x-evm:/usr/share/wl18xx#
root@am335x-evm:/usr/share/wl18xx#
root@am335x-evm:/usr/share/wl18xx#
root@am335x-evm:/usr/share/wl18xx# while true; do ifconfig wlan0 down; ifco=
nfig wlan0 up; done;
[1378786.491101] wlcore: down
[1378787.093006] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378787.168523] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378787.215897] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378787.279120] wlcore: down
[1378787.852406] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378787.923964] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378787.973034] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378788.036862] wlcore: down
[1378788.613743] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378788.693838] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378788.740383] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378788.804205] wlcore: down
[1378789.392353] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378789.473698] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378789.525618] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378789.589460] wlcore: down
[1378790.193421] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378790.268987] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378790.319464] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378790.385539] wlcore: down
[1378790.959832] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378791.037329] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378791.085311] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378791.149050] wlcore: down
[1378791.728624] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378791.801074] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378791.851683] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378791.914852] wlcore: down
[1378792.481659] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378792.558157] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378792.608917] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378792.671808] wlcore: down
[1378793.257493] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378793.335242] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378793.381733] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378793.445155] wlcore: down
[1378794.022673] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378794.099983] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378794.148400] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378794.211785] wlcore: down
[1378794.793126] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378794.870457] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378794.918269] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378794.980576] wlcore: down
[1378795.567425] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378795.643666] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378795.689798] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378795.753733] wlcore: down
[1378796.321779] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378796.395530] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378796.446662] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378796.509674] wlcore: down
[1378797.082703] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378797.155784] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378797.204702] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378797.272142] wlcore: down
[1378797.852175] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378797.927954] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378797.977066] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378798.040515] wlcore: down
[1378798.629674] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378798.705860] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378798.753307] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378798.817071] wlcore: down
[1378799.383758] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378799.456630] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378799.504191] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378799.567613] wlcore: down
[1378800.149263] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378800.293733] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378800.393680] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378800.458602] wlcore: down
[1378801.038925] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378801.115460] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378801.166596] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378801.243967] wlcore: down
[1378801.819651] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378801.896467] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378801.947433] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378802.009906] wlcore: down
[1378802.591682] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378802.665409] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378802.713678] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378802.777449] wlcore: down
[1378803.359033] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378803.440687] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378803.490562] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378803.554929] wlcore: down
[1378804.133670] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378804.209757] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378804.258120] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378804.328504] wlcore: down
[1378804.901077] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378804.978251] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378805.028641] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378805.092694] wlcore: down
[1378805.673109] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378805.748414] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378805.798805] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378805.862123] wlcore: down
[1378806.442260] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378806.516679] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378806.563867] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378806.628781] wlcore: down
[1378807.190830] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378807.266159] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378807.315008] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378807.379133] wlcore: down
[1378807.948528] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378808.019867] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378808.067142] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378808.130354] wlcore: down
[1378808.691478] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378808.765724] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378808.813940] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378808.877296] wlcore: down
[1378809.463092] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378809.535343] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378809.584844] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378809.648089] wlcore: down
[1378810.221439] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378810.300780] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378810.350360] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378810.473263] wlcore: down
[1378811.090841] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378811.163899] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378811.214713] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378811.278291] wlcore: down
[1378811.859060] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378811.940978] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378811.990527] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378812.055433] wlcore: down
[1378812.632900] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378812.706303] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378812.753410] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378812.816633] wlcore: down
[1378813.391444] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378813.464240] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378813.512363] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378813.577216] wlcore: down
[1378814.160131] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378814.237682] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378814.290315] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378814.354754] wlcore: down
[1378814.920495] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378814.998592] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378815.046547] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378815.109031] wlcore: down
[1378815.689486] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378815.762435] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378815.812226] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378815.875213] wlcore: down
[1378816.441837] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378816.515729] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378816.563795] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378816.657909] wlcore: down
[1378817.248446] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378817.322038] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378817.370687] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378817.434946] wlcore: down
[1378818.018837] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378818.096283] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378818.148273] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378818.210775] wlcore: down
[1378818.799762] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378818.875681] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378818.924567] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378818.988274] wlcore: down
[1378819.561957] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378819.636484] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378819.684097] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378819.747501] wlcore: down
[1378820.321689] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378820.397763] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378820.448642] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378820.512129] wlcore: down
[1378821.088666] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378821.160442] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378821.211085] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378821.273888] wlcore: down
[1378821.839906] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378821.915729] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378821.966909] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378822.031125] wlcore: down
[1378822.615046] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378822.693064] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378822.739599] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378822.803289] wlcore: down
[1378823.380169] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378823.458113] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378823.509566] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378823.572602] wlcore: down
[1378824.159983] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378824.237711] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378824.290808] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378824.353941] wlcore: down
[1378824.931810] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378825.005707] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378825.055433] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378825.118176] wlcore: down
[1378825.692724] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378825.765798] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378825.813798] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378825.878006] wlcore: down
[1378826.442286] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378826.518544] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378826.569183] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378826.633600] wlcore: down
[1378827.213265] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378827.288824] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378827.336628] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378827.399026] wlcore: down
[1378827.971426] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378828.048369] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378828.098243] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378828.160854] wlcore: down
[1378828.744644] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378828.817231] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378828.866908] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378828.929402] wlcore: down
[1378829.493338] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378829.568975] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378829.617434] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378829.679476] wlcore: down
[1378830.264191] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378830.337065] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378830.386654] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378830.449473] wlcore: down
[1378831.076081] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378831.153519] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378831.200456] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378831.266049] wlcore: down
[1378831.853474] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378831.927762] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378831.976934] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378832.045476] wlcore: down
[1378832.612943] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378832.689160] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378832.736919] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378832.799808] wlcore: down
[1378833.382691] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378833.455715] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378833.504109] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378833.567781] wlcore: down
[1378834.133028] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378834.205805] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378834.253361] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378834.318232] wlcore: down
[1378834.892304] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378834.968815] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378835.016491] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378835.079376] wlcore: down
[1378835.642688] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378835.718502] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378835.766202] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378835.829487] wlcore: down
[1378836.419008] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378836.495673] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378836.544773] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378836.607245] wlcore: down
[1378837.181581] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378837.255567] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378837.303845] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378837.367595] wlcore: down
[1378837.949135] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378838.025595] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378838.073999] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378838.137830] wlcore: down
[1378838.712319] wlcore: PHY firmware version: Rev 8.2.0.0.242
[1378838.788453] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378838.836558] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1378838.900204] wlcore: down
[1378839.489400] wlcore: PHY firmware version: Rev 8.2.0.0.242
^C[1378839.568368] wlcore: firmware booted (Rev 8.9.0.1.79)
[1378839.619773] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready

root@am335x-evm:/usr/share/wl18xx#

Best Regards,
Eyal
