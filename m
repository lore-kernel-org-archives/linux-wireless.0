Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65356 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZCZCeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 22:34:05 -0400
Received: by fxm2 with SMTP id 2so343204fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 19:34:01 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2 v2] p54spi: fix p54spi_upload_firmware
Date: Thu, 26 Mar 2009 05:26:12 +0300
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <73aaf0dd0903250550x37e6847x38be1f0dcc4b1bb3@mail.gmail.com> <1237985781.4320.160.camel@johannes.local>
In-Reply-To: <1237985781.4320.160.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903260526.12476.jcmvbkbc@gmail.com> (sfid-20090326_033411_629003_FAD930BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > BTW: does p54spi really work now?
> >
> > I haven't tested your patch yet, but with the one that I sent it does
> > work in IBSS mode.
>
> Nice.
Not that nice, actually. It works till first beacon resubmission. After beacon resubmission beaconing continues,
but timestamp in outgoing frames constantly gets reset:

<7>[  280.959311] RX beacon SA=00:1d:6e:9b:ee:6d BSSID=7e:2e:03:09:31:25 TSF=0x23ac519 BCN=0x1c521e2 diff=7709495 @4294959513
<7>[  281.061780] RX beacon SA=00:1d:6e:9b:ee:6d BSSID=7e:2e:03:09:31:25 TSF=0x23c552d BCN=0x1c6b1f6 diff=7709495 @4294959526
<7>[  283.992749] phy0: Removed STA 00:1d:6e:9b:ee:6d
<7>[  284.008374] phy0: Destroyed STA 00:1d:6e:9b:ee:6d
<7>[  284.008435] wlan0: deauthenticating by local choice (reason=3)
<7>[  288.948834] RX beacon SA=00:1d:6e:9b:ee:6d BSSID=7e:2e:03:09:31:25 TSF=0x1c3e1 BCN=0x23f034a diff=-37568361 @4294960536
<7>[  288.948895] wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID 7e:2e:03:09:31:25
<7>[  288.949139] phy0: Adding new IBSS station 00:1d:6e:9b:ee:6d (dev=wlan0)
<7>[  288.949230] phy0: Allocated STA 00:1d:6e:9b:ee:6d
<7>[  288.949322] phy0: Inserted STA 00:1d:6e:9b:ee:6d
<7>[  289.050906] wlan0: updated supp_rates set for 00:1d:6e:9b:ee:6d based on beacon info (0x1 | 0xfff -> 0xfff)
<7>[  289.050997] RX beacon SA=00:1d:6e:9b:ee:6d BSSID=7e:2e:03:09:31:25 TSF=0x3528d BCN=0x24091f6 diff=-37568361 @4294960549
<7>[  289.051058] wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID 7e:2e:03:09:31:25
<7>[  289.051150] phy0: Removed STA 00:1d:6e:9b:ee:6d
<7>[  289.063052] phy0: Destroyed STA 00:1d:6e:9b:ee:6d
<7>[  289.071679] phy0: Adding new IBSS station 00:1d:6e:9b:ee:6d (dev=wlan0)
<7>[  289.071770] phy0: Allocated STA 00:1d:6e:9b:ee:6d
<7>[  289.074486] phy0: Inserted STA 00:1d:6e:9b:ee:6d
<7>[  289.153774] RX beacon SA=00:1d:6e:9b:ee:6d BSSID=7e:2e:03:09:31:25 TSF=0x4e459 BCN=0x24223c2 diff=-37568361 @4294960562
<7>[  289.153835] wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID 7e:2e:03:09:31:25
<7>[  289.153896] phy0: Removed STA 00:1d:6e:9b:ee:6d
<7>[  289.154140] phy0: Adding new IBSS station 00:1d:6e:9b:ee:6d (dev=wlan0)
<7>[  289.154232] phy0: Allocated STA 00:1d:6e:9b:ee:6d
<7>[  289.157107] phy0: Inserted STA 00:1d:6e:9b:ee:6d
<7>[  289.172445] phy0: Destroyed STA 00:1d:6e:9b:ee:6d

Here's what's on the air (tshark -T fields -e wlan.sa -e wlan.seq -e wlan_mgt.fixed.timestamp):

00:1d:6e:9b:ee:6d       179     0x00000000023BE296
00:1d:6e:9b:ee:6d       180     0x00000000023D720A
00:1d:6e:9b:ee:6d       181     0x00000000023F034A
00:1d:6e:9b:ee:6d       182     0x00000000024091F6
00:1d:6e:9b:ee:6c       0       0x00000000000002D5
00:1d:6e:9b:ee:6c       1       0x00000000000003FB
00:1d:6e:9b:ee:6d       183     0x00000000024223C2
00:1d:6e:9b:ee:6c       2       0x0000000000000332
00:1d:6e:9b:ee:6d       184     0x000000000243B296
00:1d:6e:9b:ee:6c       3       0x000000000000054D
00:1d:6e:9b:ee:6c       4       0x0000000000000798

It gets back in sync only after beacon resubmission stops:

<7>[  353.579189] RX beacon SA=00:1d:6e:9b:ee:6d BSSID=7e:2e:03:09:31:25 TSF=0x4aaa81 BCN=0x618f1f6 diff=-97404789 @1513
<7>[  353.579250] wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID 7e:2e:03:09:31:25
<7>[  353.579311] phy0: Removed STA 00:1d:6e:9b:ee:6d
<7>[  353.579555] phy0: Adding new IBSS station 00:1d:6e:9b:ee:6d (dev=wlan0)
<7>[  353.579616] phy0: Allocated STA 00:1d:6e:9b:ee:6d
<7>[  353.582332] phy0: Inserted STA 00:1d:6e:9b:ee:6d
<7>[  353.594254] phy0: Destroyed STA 00:1d:6e:9b:ee:6d
<7>[  353.682026] RX beacon SA=00:1d:6e:9b:ee:6d BSSID=7e:2e:03:09:31:25 TSF=0x4c3c89 BCN=0x61a83fe diff=-97404789 @1526
<7>[  353.682087] wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID 7e:2e:03:09:31:25
<7>[  353.682148] phy0: Removed STA 00:1d:6e:9b:ee:6d
<7>[  353.682392] phy0: Adding new IBSS station 00:1d:6e:9b:ee:6d (dev=wlan0)
<7>[  353.682453] phy0: Allocated STA 00:1d:6e:9b:ee:6d
<7>[  353.685169] phy0: Inserted STA 00:1d:6e:9b:ee:6d
<7>[  353.695728] phy0: Destroyed STA 00:1d:6e:9b:ee:6d

At this point my n810 freezes. Here's what's on the air at the same time:

00:1d:6e:9b:ee:6d       809     0x0000000006176282
00:1d:6e:9b:ee:6c       59      0x000000000000051F
00:1d:6e:9b:ee:6c       60      0x00000000000006F7
00:1d:6e:9b:ee:6d       810     0x000000000618F1F6
00:1d:6e:9b:ee:6c       61      0x000000000000041D
00:1d:6e:9b:ee:6c       62      0x000000000000037B
00:1d:6e:9b:ee:6d       811     0x00000000061A83FE
00:1d:6e:9b:ee:6c       63      0x0000000000000585
00:1d:6e:9b:ee:6c       64      0x00000000000006BF
00:1d:6e:9b:ee:6d       812     0x00000000061C1372
00:1d:6e:9b:ee:6c       65      0x00000000061DA1E3
00:1d:6e:9b:ee:6d       813     0x00000000061F321E
00:1d:6e:9b:ee:6c       66      0x000000000620C2E6
00:1d:6e:9b:ee:6c       67      0x00000000062252BE
00:1d:6e:9b:ee:6c       68      0x000000000623E2E6
00:1d:6e:9b:ee:6d       814     0x000000000625739A

I can conduct additional tests or provide additional logs/pcaps.
Any suggestions?

-- 
Thanks.
-- Max
