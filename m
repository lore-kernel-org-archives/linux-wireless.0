Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40682 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbeB0XcC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:32:02 -0500
Subject: Re: Deadlock debugging help.
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
References: <4720ead5-f465-57e0-b203-49e4cb6ae51d@candelatech.com>
 <2f31c1c8-683a-7be3-693d-617939f042d6@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <bbccc3d4-1aa9-b5f0-3197-08218182fe58@candelatech.com> (sfid-20180228_003242_024663_920851D9)
Date: Tue, 27 Feb 2018 15:31:59 -0800
MIME-Version: 1.0
In-Reply-To: <2f31c1c8-683a-7be3-693d-617939f042d6@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 01:42 PM, Ben Greear wrote:
> On 02/27/2018 12:49 PM, Ben Greear wrote:
>> I notice I can reliably lock up the kernel if I rmmod ath10k while it is under
>> heavy tx/rx traffic.  First, this causes the firmware to crash, and then right
>> after (or possibly during?) the related kernel threads deadlock.
>>
>> This is with my hacked driver and hacked firmware.  In particular, the
>> ath10k_debug_nop_dwork is something I added, though it is pretty trivial,
>> it does take the ar->conf_mutex.  It appears blocked trying to get it.
>>
>> It appears something is holding the ar->conf_mutex, but it is not clear to
>> me from the lockdep output what process actually holds it.
>> Anyone see a clue they could share?
>
> Changing how I start/stop the nop_dwork stuff seems to have made the
> problem go away, so I guess maybe that was the issue.

Ok, so problem still remains.  The 'rmmod' process appears to be the
one that is really not making progress.  Unfortunately, decoding
ath10k_pci_hif_stop+0x6f leads to some bitops.h inline, which doesn't
let me know where it is actually stuck...  Off to do more debugging....


[ 4037.220992] rmmod           D    0 20267   3050 0x00000080
[ 4037.220995] Call Trace:
[ 4037.220997]  __schedule+0x407/0xb70
[ 4037.220999]  ? _raw_spin_unlock_irqrestore+0x4e/0x70
[ 4037.221003]  schedule+0x38/0x90
[ 4037.221005]  schedule_timeout+0x224/0x580
[ 4037.221007]  ? retint_kernel+0x2d/0x2d
[ 4037.221010]  ? call_timer_fn+0x370/0x370
[ 4037.221015]  msleep+0x34/0x40
[ 4037.221017]  ? msleep+0x34/0x40
[ 4037.221021]  ath10k_pci_hif_stop+0x6f/0xd0 [ath10k_pci]
[ 4037.221032]  ath10k_core_stop+0x4d/0x90 [ath10k_core]
[ 4037.221038]  ath10k_halt+0x14b/0x1f0 [ath10k_core]
[ 4037.221044]  ath10k_stop+0x36/0x80 [ath10k_core]
[ 4037.221059]  drv_stop+0x58/0x2d0 [mac80211]
[ 4037.221075]  ieee80211_stop_device+0x3e/0x50 [mac80211]
[ 4037.221088]  ieee80211_do_stop+0x501/0x880 [mac80211]
[ 4037.221092]  ? dev_deactivate_many+0x2b2/0x2f0
[ 4037.221105]  ieee80211_stop+0x15/0x20 [mac80211]
[ 4037.221107]  __dev_close_many+0x93/0xe0
[ 4037.221110]  dev_close_many+0x7d/0x120
[ 4037.221114]  dev_close.part.85+0x36/0x50
[ 4037.221116]  dev_close+0x15/0x20
[ 4037.221155]  cfg80211_shutdown_all_interfaces+0x44/0xc0 [cfg80211]
[ 4037.221168]  ieee80211_remove_interfaces+0x42/0x1c0 [mac80211]
[ 4037.221180]  ieee80211_unregister_hw+0x45/0x130 [mac80211]
[ 4037.221187]  ath10k_mac_unregister+0x14/0x60 [ath10k_core]
[ 4037.221193]  ath10k_core_unregister+0x3a/0xa0 [ath10k_core]
[ 4037.221197]  ath10k_pci_remove+0x2d/0x70 [ath10k_pci]
[ 4037.221200]  pci_device_remove+0x34/0xb0
[ 4037.221203]  device_release_driver_internal+0x158/0x210
[ 4037.221206]  driver_detach+0x3b/0x80
[ 4037.221208]  bus_remove_driver+0x53/0xd0
[ 4037.221210]  driver_unregister+0x27/0x40
[ 4037.221213]  pci_unregister_driver+0x24/0x90
[ 4037.221216]  ath10k_pci_exit+0x10/0x6ee [ath10k_pci]
[ 4037.221218]  SyS_delete_module+0x1e1/0x2a0
[ 4037.221222]  do_syscall_64+0x64/0x140
[ 4037.221225]  entry_SYSCALL64_slow_path+0x25/0x25

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
