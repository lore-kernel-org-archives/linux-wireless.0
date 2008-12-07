Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:37336 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYLGP0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 10:26:05 -0500
Received: by ti-out-0910.google.com with SMTP id b6so511294tic.23
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 07:26:03 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18747.60039.401701.441103@localhost.localdomain> (sfid-20081207_162621_167891_B6BF7390)
Date: Sun, 7 Dec 2008 20:53:51 +0530
To: Mats Johannesson <spamcan1@abrasax.se>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as
 root
In-Reply-To: <20081207150420.0f688772@loke.fish.not>
References: <20081206113406.734f1d94@loke.fish.not>
	<18746.37273.989918.333164@localhost.localdomain>
	<20081206180537.717d1791@loke.fish.not>
	<18746.48068.593834.660064@localhost.localdomain>
	<20081206202237.578b3783@loke.fish.not>
	<18747.15541.811292.500184@localhost.localdomain>
	<20081207150420.0f688772@loke.fish.not>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mats Johannesson wrote:
> I've seen you asking this from other users, and like them I don't know
> about that HT-prefix. All i can give you is the configuration of my AP:
> 
> _D-Link DIR-655 Access Point_
> Security Mode: WPA-Personal
> WPA Mode: WPA2 Only
> Cipher Type: AES
> 802.11 Mode : 802.11n only
> Wireless Channel : 2.412 GHz - CH 1
> Transmission Rate: Best (automatic)
> Channel Width: Auto 20/40 MHz
> 
> So if it's the channel width you're asking about, then I have no user
> control of the 40 MHz. I can only choose 20 MHz or this Auto 20/40 MHz.
> The AP calls the shots here...
> 

Right, and from the log below, it does choose HT40.

> The max throughput is not good, as you do know. 25 Mbits/sec on a sunny
> day with a good driver, 4.7 metres (15.4 feet) from the AP. And yes, I
> do have:
> 
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel"
> 

This shouldn't matter since ath9k doesn't use minstrel.

> Booted machine at 13:24:23. Pinged local and external machines around
> 13:25:10. Another ping session at 13:29:00 just to make sure the net
> still was ok. "iwlist ath0 scan" around 13:31:00. Tried ping
> unsuccessfully after that. Waited another five minutes, but nothing
> else showed up in the logs.
> 

Yep, ping won't work after that. :)

> 13:24:30 : ath0: authenticate with AP 00:1b:11:60:7a:3d
> 13:24:30 : ath0: authenticated
> 13:24:30 : ath0: associate with AP 00:1b:11:60:7a:3d
> 13:24:30 : ath0: RX AssocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
> 13:24:30 : ath0: associated
> 13:24:30 : ath9k: Choosing rate table for mode: 10
> 13:24:30 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
> 13:24:30 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
> 13:24:30 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 7, cw_max: 15, txop: 94
> 13:24:30 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 3, cw_max: 7, txop: 47
> 13:24:30 : ath9k: tx chmask: 5, rx chmask: 5
> 13:24:30 : ath9k: BSS Changed PREAMBLE 1
> 13:24:30 : ath9k: BSS Changed HT, chanwidth: 1
> 13:24:30 : ath9k: BSS Changed ASSOC 1
> 13:24:30 : ath9k: Bss Info ASSOC 4
> 13:24:30 : ath9k: tx chmask: 5, rx chmask: 5
> 13:24:30 : ath9k: bssid 00:1b:11:60:7a:3d aid 0x4
> 13:24:30 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 1

This indicates that HT40 has been chosen.

The problem is this:

After association, ath9k has to set the appropriate channel width on doing
a scan and mac80211 comes back to the home channel. Currently there is no
such means to do that, and this why pinging fails.

We'll work on a solution, but until then you would have to choose HT20 in your AP.

Sujith
