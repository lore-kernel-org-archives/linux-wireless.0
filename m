Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f221.google.com ([209.85.219.221]:51403 "EHLO
	mail-ew0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0CYWbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 18:31:44 -0400
Received: by ewy21 with SMTP id 21so1942828ewy.25
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 15:31:41 -0700 (PDT)
Date: Thu, 25 Mar 2010 23:24:00 +0100
From: nanok <rnanok@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: nanok <nanokk@gmx.net>, linux-wireless@vger.kernel.org
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
Message-ID: <20100325222400.GA7547@spartakus>
Reply-To: nanokk@gmx.net
References: <4B5CD1FF.4090209@twilightblue.net>
 <loom.20100321T212710-762@post.gmane.org>
 <b6c5339f1003251402sa2faff0m42e1a7fef7356e13@mail.gmail.com>
 <b6c5339f1003251404p624d7f15mae54813453821b33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f1003251404p624d7f15mae54813453821b33@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 05:04:02PM -0400, Bob Copeland wrote:
> On Thu, Mar 25, 2010 at 5:02 PM, Bob Copeland <me@bobcopeland.com> wrote:
> 
> > As you are using debian I have to ask: have you installed
> > crda? ?Since 2.6.30 ath5k gained regulatory support which
> > may cause certain channels to be disabled.
> 
> By "since 2.6.30" I meant post-2.6.30, sorry for any
> confusion.
> 
> -- 
> Bob Copeland %% www.bobcopeland.com
> 

hi Bob,

no confusion, it's perfectly clear either way you state it.
unfortunately, it's 2.6.3
0 that "works" (not pre-2.6.30), or did you mean since 2.6.30, excluding
2.6.30?

anyway, not sure why the crda would affect only wep operation, but
here's a snip of o
ne of my /var/log/messages, see if it helps (not sure i got where you
are aiming, so forgive me if this isn't what you need to know)

Mar 16 16:50:51 spartakus kernel: [14842.518127] cfg80211: Using static regulatory domain info
Mar 16 16:50:51 spartakus kernel: [14842.518130] cfg80211: Regulatory domain: US
Mar 16 16:50:51 spartakus kernel: [14842.518133]        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 16 16:50:51 spartakus kernel: [14842.518137]        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
Mar 16 16:50:51 spartakus kernel: [14842.518141]        (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Mar 16 16:50:51 spartakus kernel: [14842.518145]        (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Mar 16 16:50:51 spartakus kernel: [14842.518148]        (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Mar 16 16:50:51 spartakus kernel: [14842.518152]        (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Mar 16 16:50:51 spartakus kernel: [14842.518156]        (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
Mar 16 16:50:51 spartakus kernel: [14842.518395] cfg80211: Calling CRDA for country: US
Mar 16 16:50:51 spartakus kernel: [14842.551365] ath5k 0000:02:04.0: PCI INT A -> Link[C0C7] -> GSI 11 (level, low) -> IRQ 11
Mar 16 16:50:51 spartakus kernel: [14842.551412] ath5k 0000:02:04.0: registered as 'phy0'
Mar 16 16:50:51 spartakus kernel: [14842.798956] Registered led device: ath5k-phy0::rx
Mar 16 16:50:51 spartakus kernel: [14842.800364] Registered led device: ath5k-phy0::tx
Mar 16 16:50:51 spartakus kernel: [14842.800370] ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
Mar 16 16:50:51 spartakus kernel: [14842.800373] ath5k phy0: RF5111 5GHz radio found (0x17)
Mar 16 16:50:51 spartakus kernel: [14842.800376] ath5k phy0: RF2111 2GHz radio found (0x23)
Mar 16 16:50:57 spartakus kernel: [14849.209305] ADDRCONF(NETDEV_UP): wlan0: link is not ready

Linux version 2.6.32-3-686 (Debian 2.6.32-9) (maks
@debian.org) (gcc version 4.3.4 (Debian 4.3.4-8) ) #1 SMP Thu Feb 25
06:14:20 UTC 2010


note: the above is not from a particular working/non working session, it
just illustrates (somehting to do with) crda. to obtain logs from a
particular scenario, i would need ot test specifically, to be sure what
happened when (however, as far as i remember, there's nothing
"interesting" in the logs when it won't work, in most cases it looks the
same)

-- 
nanok
