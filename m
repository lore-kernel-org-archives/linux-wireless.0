Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:60840 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYKZP3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 10:29:35 -0500
Received: by yx-out-2324.google.com with SMTP id 8so251757yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 07:29:33 -0800 (PST)
Message-ID: <40f31dec0811260729o4a239826m9f72238beed7a497@mail.gmail.com> (sfid-20081126_162939_951737_EAC29013)
Date: Wed, 26 Nov 2008 17:29:33 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>
Subject: Re: ath5k: mesh mode broken by commit "ath5k: Update PCU code"
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <45e8e6c40811251754q4b08be7dn96308f3ae9f10123@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <45e8e6c40811251754q4b08be7dn96308f3ae9f10123@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/26 Andrey Yurovsky <andrey@cozybit.com>:
> Hello.  I noticed that commit dc300b5c5291d779a53d83af960fdf9388bf0544
> "ath5k: Update PCU code"  by Nick Kossifidis breaks Mesh Point
> operation, which had been working right up to that patch.  As I am not
> familiar with the antenna-related code that this is touching, can
> someone please assist with resolving this problem?  Thanks,
>
>  -Andrey
>

ath5k_beacon_setup can be an issue, right now it assumes you have 2
antennas and it changes the antenna on tx descriptor every 4 beacons,
before this patch we instructed hw to use the default antenna for rts
(instead of the antenna we set on tx descriptor), now we don't. We
should not handle antenna switching on sw imho since hw already has
automatic controls for it (we just have to configure them -now we use
the default settings-), as a first step i'd suggest always using 0 for
antenna mode on tx descriptor, in other words comment out this...

1955                 /*
1956                  * Switch antenna every 4 beacons if txantenna is not set
1957                  * XXX assumes two antennas
1958                  */
1959                 if (antenna == 0)
1960                         antenna = sc->bsent & 4 ? 2 : 1;

Some more infos on antenna switching...

We have 5 controls for antenna selection:

a) The default antenna register AR5K_DEFAULT_ANTENNA (you can write it
using ath5k_hw_set_def_antenna) which sets the default antenna during
Rx and if AR5K_STA_ID1_DEFAULT_ANTENNA is set on AR5K_STA_ID1 it also
controls tx antenna if antenna mode is set to 0 on tx descriptor (see
below). By default, it's value is 1 (antenna A -main) but some setups
might have misconnected the antennas (eg. connected the only antenna
available to aux port -antenna B/C/D/.., so there is no antenna
connected on main port) so we have to keep some stats based on rxed
frames and choose the default antenna (maybe after a scan). Also
default antenna is expected to be an omni-directional antenna.

b) Settings on AR5K_STA_ID1 register:
AR5K_STA_ID1_DEFAULT_ANTENNA if antenna mode is set to 0 on tx
descriptor and this bit is set to 1, then hw uses default antenna
setting from default antenna register to transmit. If it's set to 0 it
uses the cached tx antenna (based on successful txed frames -we get
CTS and ACKs). Cached antenna goes on keycache (to support multiple
stations eg. on AP mode) if AR5K_STA_ID1_DESC_ANTENNA is set to 0 or
on default antenna register if it's set to 1 (see below).

AR5K_STA_ID1_DESC_ANTENNA if set to 1, hw updates default antenna
register according to the antenna set on tx descriptor. This is used
for STA modes when we are sure that we are locked on one AP so we
cache the tx antenna on default antenna register (making it also the
default antenna for Rx).

AR5K_STA_ID1_RTS_DEF_ANTENNA if set to 1, hw always uses the default
antenna to send RTS and not the one set by descriptor.

AR5K_STA_ID1_SELFGEN_DEF_ANT if set to 1, hw sends self-generated
frames from default antenna (have to verify which MAC
versions/revisions support this)

Default settings for all modes:
AR5K_STA_ID1_DEFAULT_ANTENNA: 1 (or maybe 2 for misconnected antennas)
AR5K_STA_ID1_DEFAULT_ANTENNA: 0
AR5K_STA_ID1_DESC_ANTENNA: 0
AR5K_STA_ID1_RTS_DEF_ANTENNA: 0
Anenna mode on tx descriptor: 0

If we have multiple sector antennas on our aux ports (antennas
B/C/D...) then we can use antenna mode setting on tx descriptor for
choosing the antenna to transmit BUT we have to send RTS from our omni
antenna (default antenna) by setting AR5K_STA_ID1_RTS_DEF_ANTENNA.

If we see that default settings don't work ok for all (which is weird
because 99% use single or dual omnis), we can introduce a
ath5k_hw_set_antenna_mode function to do that and provide a
module/configfs option to switch antenna modes. Right now
ath5k_hw_set_def_antenna is all we need.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
