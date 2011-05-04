Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tdb.com ([216.99.214.4]:54667 "HELO mail.tdb.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754432Ab1EDTzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 15:55:53 -0400
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] kernel panic on MIPS + ath5k + Wistron CM9 radio
References: <861v0igqhn.fsf@coulee.tdb.com>
	<BANLkTi=mK9dh5AAQtqKVWvTjXfLS-y=7Ng@mail.gmail.com>
	<4DC05536.4010303@openwrt.org>
From: Russell Senior <seniorr@aracnet.com>
Date: Wed, 04 May 2011 12:55:41 -0700
In-Reply-To: <4DC05536.4010303@openwrt.org> (Felix Fietkau's message of "Tue\, 03 May 2011 21\:19\:18 +0200")
Message-ID: <861v0e8cle.fsf@coulee.tdb.com> (sfid-20110504_215557_182394_3D715D8F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>> "Felix" == Felix Fietkau <nbd@openwrt.org> writes:

>> Well, I see the same on FreeBSD/MIPS whenever an Atheros device is
>> fondled incorrectly. Either because the chip isn't yet fully awake
>> or the register plainly doesn't exist.
>> 
>> See if you can add some debugging in ath5k_hw_reset_tx_queue() to
>> see which register is being read/written before the PCI bus error
>> occurs.

Felix> If I read the trace correctly, the accessed register is 0x111c,
Felix> which is AR5K_QUEUE_DFS_MISC(7). If I remember correctly, queue
Felix> 7 is the beacon queue. Access to this register should never
Felix> fail unless the hardware is in sleep mode, or there is some
Felix> other PCI related issue. Unfortunately, this issue might be
Felix> caused by something entirely different that is not visible in
Felix> the stack trace. I have observed that messing up the internal
Felix> state of a PCI card can trigger an error that only shows up
Felix> much later and thus can only be found by doing a thorough code
Felix> review or by analyzing PCI traces.

I wonder what is special about MIPS (relative to x86, where I don't
see the panics).


-- 
Russell Senior         ``I have nine fingers; you have ten.''
seniorr@aracnet.com
