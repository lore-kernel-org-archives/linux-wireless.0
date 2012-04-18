Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34831 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2DRO4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:56:54 -0400
Received: by obbta14 with SMTP id ta14so6696443obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 07:56:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334714536.3725.33.camel@jlt3.sipsolutions.net>
References: <4F630AEA.10703@etit.tu-chemnitz.de> <20120316204547.GG18861@tux>
 <4F63BA31.1080608@etit.tu-chemnitz.de> <4F856449.3000804@etit.tu-chemnitz.de>
 <1334203508.3788.12.camel@jlt3.sipsolutions.net> <4F868732.1030401@etit.tu-chemnitz.de>
 <1334714536.3725.33.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 18 Apr 2012 07:56:28 -0700
Message-ID: <CAPjQAd99vzQDO0PzC-0jq1j8h4ekQAP_dRE=g5f=w=6EwcXrDw@mail.gmail.com> (sfid-20120418_165657_664375_B7AF5297)
Subject: Re: [Greenmesh] [ath9k] mesh powersave hardware sleep + wakeup
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2012 at 7:02 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> (...)
> Keep in mind that TSF == start of TSF field, while rx_status->timestamp
> == start of first symbol, which I didn't even remember when you guys did
> all the Toffset things, I'm guessing they're all wrong :-)

I think you guessed wrong :)

http://www.mail-archive.com/devel@lists.open80211s.org/msg01552.html

+       if (rx_status->flag & RX_FLAG_MACTIME_MPDU && rx_status->mactime) {
+               /*
+                * The mactime is defined as the time the first data symbol
+                * of the frame hits the PHY, and the timestamp of the beacon
+                * is defined as "the time that the data symbol containing the
+                * first bit of the timestamp is transmitted to the PHY plus
+                * the transmitting STA's delays through its local PHY from the
+                * MAC-PHY interface to its interface with the WM" (802.11
+                * 11.1.2)
+                *
+                * T_r, in 13.13.2.2.2, is just defined as "the frame reception
+                * time" but we unless we interpret that time to be the same
+                * time of the beacon timestamp, the offset calculation will be
+                * off.  Below we adjust t_r to be "the time at which the first
+                * symbol of the timestamp element in the beacon is received".
+                * This correction depends on the rate.
+                *
+                * Based on similar code in ibss.c
+                */
+               int rate;
+
+               if (rx_status->flag & RX_FLAG_HT) {
+                       /* TODO:
+                        * In principle there could be HT-beacons (Dual Beacon
+                        * HT Operation options), but for now ignore them and
+                        * just use the primary (i.e. non-HT) beacons for
+                        * synchronization.
+                        * */
+                       goto no_sync;
+               } else
+                       rate = local->hw.wiphy->bands[rx_status->band]->
+                               bitrates[rx_status->rate_idx].bitrate;
+
+               /* 24 bytes of header * 8 bits/byte *
+                * 10*(100 Kbps)/Mbps / rate (100 Kbps)*/
+               t_r = rx_status->mactime + (24 * 8 * 10 / rate);
+       }


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
