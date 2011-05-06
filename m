Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50256 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1EFB5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 21:57:33 -0400
Received: by pvg12 with SMTP id 12so1226575pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 18:57:32 -0700 (PDT)
Message-ID: <4DC35588.7030300@gmail.com> (sfid-20110506_035737_227478_ECDF0AAC)
Date: Fri, 06 May 2011 11:57:28 +1000
From: Peizhao Hu <peizhao.research@gmail.com>
Reply-To: peizhao.research@gmail.com
MIME-Version: 1.0
To: Russell Senior <seniorr@aracnet.com>
CC: Felix Fietkau <nbd@openwrt.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] kernel panic on MIPS + ath5k + Wistron CM9 radio
References: <861v0igqhn.fsf@coulee.tdb.com>	<BANLkTi=mK9dh5AAQtqKVWvTjXfLS-y=7Ng@mail.gmail.com>	<4DC05536.4010303@openwrt.org> <861v0e8cle.fsf@coulee.tdb.com>
In-Reply-To: <861v0e8cle.fsf@coulee.tdb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, the CPU architecture is different. But this is not really the cause...

As far as I understand the problem, the ath5k driver or the entire 
mac80211 framework is ported to OpenWRT by the team. There are 
differences between the one you use on the Intel sys and on the OpenWRT 
boxes.

The best place to request for fix is the OpenWRT mailing list.

regards;

Peizhao


On 05/05/11 05:55, Russell Senior wrote:
>>>>>> "Felix" == Felix Fietkau<nbd@openwrt.org>  writes:
>>> Well, I see the same on FreeBSD/MIPS whenever an Atheros device is
>>> fondled incorrectly. Either because the chip isn't yet fully awake
>>> or the register plainly doesn't exist.
>>>
>>> See if you can add some debugging in ath5k_hw_reset_tx_queue() to
>>> see which register is being read/written before the PCI bus error
>>> occurs.
> Felix>  If I read the trace correctly, the accessed register is 0x111c,
> Felix>  which is AR5K_QUEUE_DFS_MISC(7). If I remember correctly, queue
> Felix>  7 is the beacon queue. Access to this register should never
> Felix>  fail unless the hardware is in sleep mode, or there is some
> Felix>  other PCI related issue. Unfortunately, this issue might be
> Felix>  caused by something entirely different that is not visible in
> Felix>  the stack trace. I have observed that messing up the internal
> Felix>  state of a PCI card can trigger an error that only shows up
> Felix>  much later and thus can only be found by doing a thorough code
> Felix>  review or by analyzing PCI traces.
>
> I wonder what is special about MIPS (relative to x86, where I don't
> see the panics).
>
>
