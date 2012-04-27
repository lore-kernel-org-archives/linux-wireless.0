Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:60195 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366Ab2D0PxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 11:53:04 -0400
Message-ID: <4F9AC0DC.9030304@etit.tu-chemnitz.de> (sfid-20120427_175309_193390_6D4A7C4E)
Date: Fri, 27 Apr 2012 17:53:00 +0200
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] mesh powersave hardware sleep + wakeup
References: <4F630AEA.10703@etit.tu-chemnitz.de> <20120316204547.GG18861@tux> <4F63BA31.1080608@etit.tu-chemnitz.de> <4F856449.3000804@etit.tu-chemnitz.de>
In-Reply-To: <4F856449.3000804@etit.tu-chemnitz.de>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/12 13:00, Marco Porsch wrote:
> On 03/16/12 23:09, Marco Porsch wrote:
>>> On Fri, Mar 16, 2012 at 10:42:02AM +0100, Marco Porsch wrote:
>>>> I am trying to implement the IEEE 802.11s power save schemes in mac80211.
>
> I did some hacking and can now answer part one of my question:
> yes, beaconing and power save are not mutually exclusive with ath9k.
>
> Second question: what about power save doze and waking up for _multiple_
> neighbors' beacons?

I've again done some hacking: now waking up for multiple neighbor 
beacons in mesh mode seems to work experimentally [1].

Next step is the mesh awake window i.e. just keep awake for a specified 
time after beacon TX.
Is it possible to configure the hardware accordingly?


There are some settings concerning ad-hoc's ATIM window in 
ath9k_hw_beaconinit that look like it should be possible to use hardware 
timers for that. Unfortunately, I had no success on these. Maybe it 
requires ATIM frames (-> AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY)?

Regards,
Marco


[1]
I maintain a list of wakeup events stored as ath9k_beacon_state. When 
doing ath9k_ps_restore, I re-configure the hardware with a slightly 
modified version of ath9k_hw_set_sta_beacon_timers to expect the next 
wakeup event.
Actually seems to work.
