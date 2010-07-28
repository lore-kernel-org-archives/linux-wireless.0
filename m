Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:34747 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751439Ab0G1CDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 22:03:38 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0715682614
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 11:03:36 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
Date: Wed, 28 Jul 2010 11:03:44 +0900
References: <20100727094732.27186.30900.stgit@tt-desk> <20100727094759.27186.79639.stgit@tt-desk> <1280225142.19098.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1280225142.19098.10.camel@jlt3.sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007281103.44963.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue July 27 2010 19:05:42 you wrote:
> I'm still not convinced that this is the best approach. Can you discuss
> this a bit?

well... i am mainly concerned about what you call "legacy" hardware at the 
moment, but i am trying to make the API useful for 802.11n devices as well. 

first, thinking only about legacy devices with 2 antennas, the three most 
common settings are "fixed antenna 1", "fixed antenna 2" and "antenna 
diversity". luis suggested to use a simple value and constants for this, but i 
believe that this covers only 90% of the cases, the others being antenna 
setups i have described (in the commit message and per email before), which 
use a different antenna for TX than for RX, or diversity for RX and a single 
fixed antenna for TX. also, while not hugely popular or common, there *is* 
"legacy" hardware out there which has more than two antennas (e.g.: "pre-11n 
RangeMax" and "large phased array switch" which were based on ath5k chipsets) 
and at least the atheros eeprom supports more antennas. i'm not sure about 
other hardware, but i think it's good to have the flexibility to support more 
than two antennas in the API, also since this matches with what we need for 
802.11n. that's why a bitmask makes sense.

honestly, i don't know too much about 802.11n, so i need the help of people 
who work with 802.11n to see if this is useful for them and possibly extend 
it, or update the documentation to make the API more clear. but i believe that 
if you think 'chainmask' instead of 'antenna' it should be o.k...
in the end we are just talking about antennas :) for most of the users the 
antenna settings will just be default, but sometimes, especially in outdoor 
installations less antennas are present, or special setups can be desired and 
this API can be used to inform the HW about available antennas, wether it's 
802.11n or not. 

bruno
