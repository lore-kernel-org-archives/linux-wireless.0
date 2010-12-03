Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34312 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab0LCIO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 03:14:28 -0500
Message-ID: <4CF8A6DE.4020804@candelatech.com>
Date: Fri, 03 Dec 2010 00:14:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
References: <4CF44543.9070605@candelatech.com> <20101130004424.GC1901@tux> <4CF6D8C8.2000308@candelatech.com>
In-Reply-To: <4CF6D8C8.2000308@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2010 03:22 PM, Ben Greear wrote:
> On 11/29/2010 04:44 PM, Luis R. Rodriguez wrote:
>> On Mon, Nov 29, 2010 at 04:28:51PM -0800, Ben Greear wrote:
>
>>> BUG: unable to handle kernel NULL pointer dereference at 00000040
>>> IP: [<f933470a>] ath_tx_start+0x461/0x5ef [ath9k]
>>> *pde = 00000000
>>> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
>>> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/irq
>>> Modules linked in: aes_i586 aes_generic fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw mi]
>>>
>>> Pid: 38, comm: kworker/u:1 Tainted: G        W   2.6.37-rc3-wl+ #53 PDSBM/PDSBM
>>> EIP: 0060:[<f933470a>] EFLAGS: 00010246 CPU: 1
>>> EIP is at ath_tx_start+0x461/0x5ef [ath9k]
>>
>> Please use
>>
>> gdb drivers/net/wireless/ath/ath9k/
>> l *(ath_tx_start+0x461)
>>
>>     Luis
>
> I managed to hit that ath_tx_start crash again, and this time there were no obvious
> DMA or irq errors immediately preceding it.  So, it might be a real bug
> after all.  I'll add some extra checks to see if tid->ac is NULL.

I've made some small progress on this general issue.

First, I added all sorts of debugging to try to figure out ath_tx_start crash.
As best as I can tell, 'tid' is not NULL, but also is not a valid pointer,
and probably something close to 0x0.  I've added yet more debugging, but haven't
hit the problem again.

I also tried stopping DMA in a loop up to 5 times if it failed to stop
previously in the loop.  This did not appear to help at all.

I also managed to make both the ath_tx_start crash and the DMA errors very hard to reproduce
(I dare not say fixed, yet).

It appears that this small patch (and possibly, the fact that I set debugging to 0x600
instead of 0x400) makes the problems go away.  This makes me wonder if a root cause is
something to do with repeatedly resetting the hardware too fast, as setting channels rapidly
would tend to do that, and channels are set on association by supplicant, it appears.

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f026a03..46b1791 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1605,6 +1605,16 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
                 else
                         sc->sc_flags &= ~SC_OP_OFFCHANNEL;

+               /* If channels & HT are the same, then don't actually do anything.
+                */
+               if ((sc->sc_ah->curchan == &sc->sc_ah->channels[pos]) &&
+                   (aphy->chan_is_ht == conf_is_ht(conf))) {
+                       ath_print(common, ATH_DBG_CONFIG,
+                                 "Skip Set channel: %d MHz, already there.\n",
+                                 curchan->center_freq);
+                       goto skip_chan_change;
+               }
+
                 if (aphy->state == ATH_WIPHY_SCAN ||
                     aphy->state == ATH_WIPHY_ACTIVE)
                         ath9k_wiphy_pause_all_forced(sc, aphy);

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
