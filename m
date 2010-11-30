Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56049 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0K3Awh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 19:52:37 -0500
Message-ID: <4CF44AD3.4020607@candelatech.com>
Date: Mon, 29 Nov 2010 16:52:35 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
References: <4CF44543.9070605@candelatech.com> <20101130004424.GC1901@tux>
In-Reply-To: <20101130004424.GC1901@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2010 04:44 PM, Luis R. Rodriguez wrote:
> On Mon, Nov 29, 2010 at 04:28:51PM -0800, Ben Greear wrote:
>> Here is a script that reliably crashes my ath9k box.
>> A second box with completely different hardware (except
>> for ath9k) experiences similar problems.

>> BUG: unable to handle kernel NULL pointer dereference at 00000040
>> IP: [<f933470a>] ath_tx_start+0x461/0x5ef [ath9k]
>> *pde = 00000000
>> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/irq
>> Modules linked in: aes_i586 aes_generic fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw mi]
>>
>> Pid: 38, comm: kworker/u:1 Tainted: G        W   2.6.37-rc3-wl+ #53 PDSBM/PDSBM
>> EIP: 0060:[<f933470a>] EFLAGS: 00010246 CPU: 1
>> EIP is at ath_tx_start+0x461/0x5ef [ath9k]
>
> Please use
>
> gdb drivers/net/wireless/ath/ath9k/
> l *(ath_tx_start+0x461)

Usually the machine locks pretty hard with irq errors reported from wired NICs
and/or the hard-drive.  I'm not sure that the ath_tx_start
issue is real, or maybe just some un-lucky side-affect of earlier
bugs in this trace.

Reading symbols from /home/greearb/kernel/2.6/wireless-testing-dbg.p4s/drivers/net/wireless/ath/ath9k/ath9k.ko...done.
(gdb) l *(ath_tx_start+0x461)
0x972e is in ath_tx_start (/home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c:1691).
1686		if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && txctl->an) {
1687			tidno = ieee80211_get_qos_ctl(hdr)[0] &
1688				IEEE80211_QOS_CTL_TID_MASK;
1689			tid = ATH_AN_2_TID(txctl->an, tidno);
1690	
1691			WARN_ON(tid->ac->txq != txctl->txq);
1692			/*
1693			 * Try aggregation if it's a unicast data frame
1694			 * and the destination is HT capable.
1695			 */


Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

