Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55123 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab1EXUrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 16:47:15 -0400
Message-ID: <4DDC194F.9080801@candelatech.com> (sfid-20110524_224719_407179_13B89C43)
Date: Tue, 24 May 2011 13:47:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [ath5k] kernel panic while using compat-wireless-2.6.38.2-2
References: <4DCA672E.2080906@googlemail.com> <4DDA89A4.5040101@googlemail.com> <4DDA8CCA.3050703@candelatech.com> <4DDC0F1F.3050301@googlemail.com>
In-Reply-To: <4DDC0F1F.3050301@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2011 01:03 PM, Dennis Borgmann wrote:
> Dear linux-wireless list,
>
> sorry, I did answer too early, problem still exists. I am now using
> compat-wireless-2.6.39-1. I hope, this is new enough (it seems to be
> from last night anyway...)
>
> I now even exchanged the wireless card, now I am using a Gigabyte
> GN-WI01HT (AR5414 chip), the problem seems to be the same. I attached
> some dmesg info. Could this be a hardware error of the mainboard?
> Actually, I only have one hardware to test on and I somehow don't really
> trust it. Just a thought of mine...
>
> What are your suggestions, or could this really be a bug?

I use the wireless-testing tree, not any compat stuff.  We are
testing ath5k and ath9k currently, and no troubles.

If you can reproduce it using wireless-testing, I'll look
at it closer.  Otherwise, it might be some problem with
the backport.

Thanks,
Ben

>
> Best regards,
> Dennis
>
>
> [ 7.525432] Compat-wireless backport release: compat-wireless-v2.6.39-1
> [ 7.532737] Backport based on linux-2.6-allstable.git v2.6.39
> [ 7.576502] cfg80211: Calling CRDA to update world regulatory domain
> [ 7.640147] cfg80211: World regulatory domain updated:
> [ 7.645908] cfg80211: (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 7.656157] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [ 7.664483] cfg80211: (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [ 7.672754] cfg80211: (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [ 7.674546] ath5k 0000:11:07.0: PCI->APIC IRQ transform: INT A -> IRQ 19
> [ 7.688710] cfg80211: (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [ 7.697046] cfg80211: (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [ 7.705453] ath5k 0000:11:07.0: registered as 'phy0'
> [ 8.351679] ath: EEPROM regdomain: 0x0
> [ 8.351685] ath: EEPROM indicates default country code should be used
> [ 8.351690] ath: doing EEPROM country->regdmn map search
> [ 8.351695] ath: country maps to regdmn code: 0x3a
> [ 8.351699] ath: Country alpha2 being used: US
> [ 8.351703] ath: Regpair used: 0x3a
> [ 8.360800] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [ 8.362487] cfg80211: Calling CRDA for country: US
> [ 8.362536] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> [ 8.363657] modprobe used greatest stack depth: 5860 bytes left
> [ 8.388493] cfg80211: Regulatory domain changed to country: US
> [ 8.394937] cfg80211: (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 8.403724] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
> 2700 mBm)
> [ 8.412246] cfg80211: (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
> 1700 mBm)
> [ 8.421561] cfg80211: (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [ 8.430451] cfg80211: (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [ 8.438853] cfg80211: (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [ 8.447623] cfg80211: (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
> 3000 mBm)
> [ 8.496322] scsi 4:0:0:0: Direct-Access Generic Storage Device 0.00 PQ:
> 0 ANSI: 2
> [ 8.505354] sd 4:0:0:0: Attached scsi generic sg1 type 0
> [ 8.511989] sd 4:0:0:0: [sdb] Attached SCSI removable disk
> [ 8.796704] chown used greatest stack depth: 5824 bytes left
> [ 27.909475] cfg80211: Calling CRDA for country: DE
> [ 27.920079] cfg80211: Regulatory domain changed to country: DE
> [ 27.927544] cfg80211: (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 27.937610] cfg80211: (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A,
> 2000 mBm)
> [ 27.945562] cfg80211: (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A,
> 2000 mBm)
> [ 27.953475] cfg80211: (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A,
> 2000 mBm)
> [ 27.961475] cfg80211: (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A,
> 2698 mBm)
> [ 28.014622] hostapd used greatest stack depth: 5748 bytes left
> [ 33.195098] ------------[ cut here ]------------
> [ 33.201175] WARNING: at
> /mnt/entw/compat-wireless-2.6.39-1/net/mac80211/rx.c:2882
> ieee80211_rx+0x39/0x660 [mac80211]()
> [ 33.213802] Hardware name: Luna Pier CRB
> [ 33.219331] Modules linked in: ath5k ath mac80211 cfg80211 compat [last
> unloaded: scsi_wait_scan]
> [ 33.226899] Pid: 24, comm: sirq-tasklet/1 Not tainted
> 2.6.33.7.2-rt30-atom-ssb #1
> [ 33.236137] Call Trace:
> [ 33.240118] [<c1030666>] warn_slowpath_common+0x60/0x90
> [ 33.247071] [<c10306a3>] warn_slowpath_null+0xd/0x10
> [ 33.253762] [<dff60edd>] ieee80211_rx+0x39/0x660 [mac80211]
> [ 33.261111] [<e031064c>] ath5k_tasklet_rx+0x540/0x5aa [ath5k]
> [ 33.268566] [<c102b281>] ? set_next_entity+0x1e/0x89
> [ 33.273935] [<c135941d>] ? __schedule+0x76f/0x7a4
> [ 33.280319] [<c10356b4>] __tasklet_action+0x77/0xd7
> [ 33.285564] [<c10357d2>] tasklet_action+0x5c/0x62
> [ 33.291956] [<c1035c19>] run_ksoftirqd+0x131/0x247
> [ 33.297091] [<c1035ae8>] ? run_ksoftirqd+0x0/0x247
> [ 33.303589] [<c1046ab6>] kthread+0x61/0x66
> [ 33.308029] [<c1046a55>] ? kthread+0x0/0x66
> [ 33.313884] [<c1002db6>] kernel_thread_helper+0x6/0x10
> [ 33.319430] ---[ end trace 95aeede189daca6f ]---
>
>
> Am 23.05.2011 18:35, schrieb Ben Greear:
>> On 05/23/2011 09:21 AM, Dennis Borgmann wrote:
>>> Hello linux-wireless list!
>>>
>>> Is there really no one with an idea? Is there no one among the
>>> developers, who is interested in this bug, if it is a bug?
>>>
>>> I'm starting to lose my hope...
>>
>> Can you reproduce this in the wireless-testing tree?
>>
>> Ben
>>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

