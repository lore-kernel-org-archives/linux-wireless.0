Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43814 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3JVWXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 18:23:00 -0400
Message-ID: <5266FAAD.3010800@candelatech.com> (sfid-20131023_002304_111253_9D6467EC)
Date: Tue, 22 Oct 2013 15:22:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k hits warning in sta_info.c:839.
References: <5266C321.7000103@candelatech.com>
In-Reply-To: <5266C321.7000103@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2013 11:25 AM, Ben Greear wrote:
> Kernel is stock 'ath' tree, with small printk to debug an ath10k
> crash.
> 
> This is FYI for now...will be looking at other ath10k crash bugs
> before digging into this tone.
> 
> Setup is 2 stations trying to associate to same AP, which causes
> endless failures and firmware crashes.  Good for chasing bugs :)
> 
> 
> DMAR:[fault reason 05] PTE Write access is not set
> dmar: DRHD: handling fault status reg 3
> dmar: DMAR:[DMA Write] Request device [05:00.0] fault addr ffd52000
> DMAR:[fault reason 05] PTE Write access is not set
> dmar: DRHD: handling fault status reg 3
> dmar: DMAR:[DMA Write] Request device [05:00.0] fault addr ffd52000
> DMAR:[fault reason 05] PTE Write access is not set
> 
> sta300: authentication with 00:03:83:3d:30:aa timed out
> [root@ct523-9292 ~]# ath10k: Failed to delete peer: 00:03:83:3d:30:aa for VDEV: 1
> ath10k: WMI vdev stop failed: ret -108

> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 6 at /mnt/sda/home/greearb/git/ath/net/mac80211/sta_info.c:839 __sta_info_destroy+0x12)
> Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan pktgen lockd f71882fg coretemp hw]

I think this may be a result of whatever bug or limitation
caused the firmware to error and/or crash when adding a second
station VIF and trying to associate it to the same AP.

Probably not a problem with the rest of the wifi stacks.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

