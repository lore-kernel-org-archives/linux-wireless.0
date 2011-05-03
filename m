Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50739 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1ECTTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 15:19:30 -0400
Message-ID: <4DC05536.4010303@openwrt.org> (sfid-20110503_211933_746963_F66C1604)
Date: Tue, 03 May 2011 21:19:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Russell Senior <seniorr@aracnet.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] kernel panic on MIPS + ath5k + Wistron CM9 radio
References: <861v0igqhn.fsf@coulee.tdb.com> <BANLkTi=mK9dh5AAQtqKVWvTjXfLS-y=7Ng@mail.gmail.com>
In-Reply-To: <BANLkTi=mK9dh5AAQtqKVWvTjXfLS-y=7Ng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-03 8:18 AM, Adrian Chadd wrote:
> Well, I see the same on FreeBSD/MIPS whenever an Atheros device is
> fondled incorrectly. Either because the chip isn't yet fully awake or
> the register plainly doesn't exist.
>
> See if you can add some debugging in ath5k_hw_reset_tx_queue() to see
> which register is being read/written before the PCI bus error occurs.
If I read the trace correctly, the accessed register is 0x111c, which is
AR5K_QUEUE_DFS_MISC(7). If I remember correctly, queue 7 is the beacon 
queue. Access to this register should never fail unless the hardware is 
in sleep mode, or there is some other PCI related issue. Unfortunately, 
this issue might be caused by something entirely different that is not 
visible in the stack trace. I have observed that messing up the internal 
state of a PCI card can trigger an error that only shows up much later 
and thus can only be found by doing a thorough code review or by 
analyzing PCI traces.

- Felix
