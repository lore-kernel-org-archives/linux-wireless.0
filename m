Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35505 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbcDAGlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 02:41:19 -0400
Received: by mail-wm0-f47.google.com with SMTP id 191so8794230wmq.0
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2016 23:41:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FD9D3F.5060009@candelatech.com>
References: <56FD96EB.1090208@candelatech.com>
	<56FD9D3F.5060009@candelatech.com>
Date: Fri, 1 Apr 2016 08:41:18 +0200
Message-ID: <CA+BoTQkzmnEkCRvWZPLefOAuXC5bVuAMUSgga+yN40w-H+AksA@mail.gmail.com> (sfid-20160401_084125_370351_CD31CE61)
Subject: Re: Ath10k seems to be using stale mac80211 txq references.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2016 at 23:57, Ben Greear <greearb@candelatech.com> wrote:
> On 03/31/2016 02:30 PM, Ben Greear wrote:
>>
>> hacked 4.4.6 (with most of linux.ath ath10k patches backported), hacked
>> 10.4.3 firmware.
>>
>> I enabled kasan to help track down various bugs.  This one has me a bit
>> perplexed.  It seems ath10k is referencing some logic in mac80211 that has
>> already been deleted.
>>
>> Possibly this is because ath10k_flush doesn't actually drop all
>> skb references immediately?
>>
>> [root@ath10k ~]# wlan3: Failed to send nullfunc to AP 04:f0:21:f6:85:1c
>> after 1000ms, disconnecting
>> ath10k_pci 0000:05:00.0: firmware crashed! (uuid
>> 288562f1-b7e8-4810-ba0a-c154927476ae)
>> ath10k_pci 0000:05:00.0: firmware register dump:
>> ath10k_pci 0000:05:00.0: [00]: 0x00000009 0x000015B3 0x0099E4B6 0x00955B31
>> ath10k_pci 0000:05:00.0: [04]: 0x0099E4B6 0x00060130 0x00000005 0x00000016
>> ath10k_pci 0000:05:00.0: [08]: 0x00455030 0x00440C70 0x004060F0 0x00000044
>> ath10k_pci 0000:05:00.0: [12]: 0x00000009 0x00000000 0x009533D0 0x009533DF
>> ath10k_pci 0000:05:00.0: [16]: 0x00953438 0x009C17A2 0x00940E1C 0x00000000
>> ath10k_pci 0000:05:00.0: [20]: 0x4099E4B6 0x00405FEC 0x000000BE 0x00955A00
>> ath10k_pci 0000:05:00.0: [24]: 0x8099E680 0x0040604C 0x00000000 0xC099E4B6
>> ath10k_pci 0000:05:00.0: [28]: 0x80986D5F 0x004060AC 0x00423A14 0x004060F0
>> ath10k_pci 0000:05:00.0: [32]: 0x80984E51 0x004060CC 0x00423A14 0x004060F0
>> ath10k_pci 0000:05:00.0: [36]: 0x80985CBF 0x004060EC 0x00424B04 0x00440C70
>> ath10k_pci 0000:05:00.0: [40]: 0x809CC91A 0x0040615C 0x00440C70 0x00424B04
>> ath10k_pci 0000:05:00.0: [44]: 0x80984EBC 0x0040618C 0x00440C70 0x0040623C
>> ath10k_pci 0000:05:00.0: [48]: 0x809C63AC 0x0040623C 0x00440C70 0x00411988
>> ath10k_pci 0000:05:00.0: [52]: 0x80984DE0 0x0040626C 0x00424B04 0x00440C70
>> ath10k_pci 0000:05:00.0: [56]: 0x809CD08C 0x0040635C 0x00424B04 0x00422F34
>> ath10k_pci 0000:05:00.0: ath10k_pci ATH10K_DBG_BUFFER:
>> ath10k: [0000]: 0001581E 17FC4C01 0F00851C 0000000A 06003007 0000FFAA
>> FFFFFFFF 0001581E
>> ath10k: [0008]: 17FC4C01 71108880 00000000 00C400BF 00000000 00000FF0
>> 0001581E 17FC4C01
>> ath10k: [0016]: 71108880 00010000 00C400BF 00000000 FFFFFFFF 0001581E
>> 17FC4C01 71108880
>> ath10k: [0024]: 00020000 00C400BF 00000000 FFFFFFFF 0001581E 17FC4C01
>> 71108880 00030000
>> ath10k: [0032]: 00C400BF 000000FF FFFFFFFF 0001581E 17FC4C01 71108880
>> 00040000 00C400BF
>> ath10k: [0040]: 000000FF FFFFFFFF 0001581E 17FC4C01 71108880 00050000
>> 00C400BF 000000FF
>> ath10k: [0048]: FBFFFFFF 0001582D 0058581D 0001582D 0858581B 0000851C
>> 00000000 0001582D
>> ath10k: [0056]: 0058581D 00015841 07FC4C02 00000004 00015846 0058581D
>> 00015846 17FC4C01
>> ath10k: [0064]: 0F00851C 0000000A 06003007 0000FFAA FFFFFFFF 00015846
>> 17FC4C01 71108880
>> ath10k: [0072]: 00000000 00C400BF 00000000 00000FF0 00015846 17FC4C01
>> 71108880 00010000
>> ath10k: [0080]: 00C400BF 00000000 FFFFFFFF 00015846 17FC4C01 71108880
>> 00020000 00C400BF
>> ath10k: [0088]: 00000000 FFFFFFFF 00015846 17FC4C01 71108880 00030000
>> 00C400BF 000000FF
>> ath10k: [0096]: FFFFFFFF 00015846 17FC4C01 71108880 00040000 00C400BF
>> 000000FF FFFFFFFF
>> ath10k: [0104]: 00015846 17FC4C01 71108880 00050000 00C400BF 000000FF
>> FBFFFFFF 0001584D
>> ath10k: [0112]: 14585853 51100001 000F118C 00000400 00000049 00440D40
>> 0001584D 0058581D
>> ath10k: [0120]: 0001584D 0458581C 00000002 0001584D 0058581D 00015850
>> 07FC4C02 00000004
>> ath10k: [0128]: 00015854 0058581D 00015854 17FC4C01 0F00851C 0000000A
>> 06003007 0000FFAA
>> ath10k: [0136]: FFFFFFFF 00015855 17FC4C01 71108880 00000000 00C400BF
>> 00000000 00000FF0
>> ath10k: [0144]: 00015855 17FC4C01 71108880 00010000 00C400BF 00000000
>> FFFFFFFF 00015855
>> ath10k: [0152]: 17FC4C01 71108880 00020000 00C400BF 00000000 FFFFFFFF
>> 00015855 17FC4C01
>> ath10k: [0160]: 71108880 00030000 00C400BF 000000FF FFFFFFFF 00015855
>> 17FC4C01 71108880
>> ath10k: [0168]: 00040000 00C400BF 000000FF FFFFFFFF 00015855 17FC4C01
>> 71108880 00050000
>> ath10k: [0176]: 00C400BF 000000FF FBFFFFFF 00015861 07FC4C02 00000001
>> 00015864 07FC4C02
>> ath10k: [0184]: 00000001 00015868 085C3812 000F4CCC 00424B04 00015868
>> 105C3809 0000143C
>> ath10k: [0192]: 00000001 00000000 00000000 0001586E 145C5853 51100001
>> 000F1144 000003FC
>> ath10k: [0200]: 0000004A 00440C70 0001586E 145C5853 51100001 000F10FC
>> 000003FE 0000004B
>> ath10k: [0208]: 00440C70 0001586E 07FC5830 00000008 0001586E 145C5854
>> 51100002 000F10FC
>> ath10k: [0216]: 00000061 0000004A 00440C70 0001586E 145C5851 91107001
>> 00424B04 00440C70
>> ath10k: [0224]: 00000008 00000006 0001586E 17FC5855 91108001 00000000
>> 00000000 00000044
>> ath10k: [0232]: 000000BE 0001586E 0FFC5855 91108002 00440C70 00000010
>> 0001586E 17FC0001
>> ath10k: [0240]: 0099E4B6 000015B3 000015B3 00405EDC 00000009
>> ath10k_pci 0000:05:00.0: ATH10K_END
>> sta22: drv-set-bitrate-mask had error return: -108
>> rdev-set-bitrate-mask failed: -108
>> sta21: Failed to send nullfunc to AP 04:f0:21:f6:85:1c after 1000ms,
>> disconnecting
>> sta5: Failed to send nullfunc to AP 04:f0:21:f6:85:1c after 1000ms,
>> disconnecting
>> sta7: Failed to send nullfunc to AP 04:f0:21:f6:85:1c after 1000ms,
>> disconnecting
>> ath10k_pci 0000:05:00.0: Looped 2000 times in tx_push_pending, bailing
>> out.
>> ath10k_pci 0000:05:00.0: Looped 2000 times in tx_push_pending, bailing
>> out.
>> ath10k_pci 0000:05:00.0: Looped 2000 times in tx_push_pending, bailing
>> out.
>> ath10k_pci 0000:05:00.0: Looped 2000 times in tx_push_pending, bailing
>> out.
>> ath10k_pci 0000:05:00.0: Looped 2000 times in tx_push_pending, bailing
>> out.
>> wlan3: Failed to send nullfunc to AP 04:f0:21:f6:85:1c after 1000ms,
>> disconnecting
>> sta1: Failed to send nullfunc to AP 04:f0:21:f6:85:1c after 1000ms,
>> disconnecting
>> sta2: Failed to send nullfunc to AP 04:f0:21:f6:85:1c after 1000ms,
>> disconnecting
>> ==================================================================
>> BUG: KASAN: use-after-free in ath10k_mac_tx_push_txq+0x3e/0x17d
>> [ath10k_core] at addr ffff8801bd136810
>>
>> (gdb) l *(ath10k_mac_tx_push_txq+0x3e)
>> 0x10aa9 is in ath10k_mac_tx_push_txq
>> (/home/greearb/git/linux-4.4.dev.y/drivers/net/wireless/ath/ath10k/mac.c:4241).
>> 4236    {
>> 4237        struct ath10k *ar = hw->priv;
>> 4238        struct ath10k_htt *htt = &ar->htt;
>> 4239        struct ath10k_txq *artxq = (void *)txq->drv_priv;
>> 4240        struct ieee80211_vif *vif = txq->vif;
>> 4241        struct ieee80211_sta *sta = txq->sta;
>> 4242        enum ath10k_hw_txrx_mode txmode;
>> 4243        enum ath10k_mac_tx_path txpath;
>> 4244        struct sk_buff *skb;
>> 4245        size_t skb_len;
>> (gdb) quit
>>
>>
>> Read of size 8 by task ksoftirqd/0/3
>>
>> =============================================================================
>> BUG kmalloc-4096 (Tainted: G        W  O   ): kasan: bad access detected
>>
>> -----------------------------------------------------------------------------
>>
>> INFO: Allocated in sta_info_alloc+0x42f/0x6d1 [mac80211] age=21463 cpu=2
>> pid=3409
>>      ___slab_alloc+0x2b7/0x44e
>>      __slab_alloc.isra.64+0x44/0x74
>>      __kmalloc+0xae/0x13d
>>      sta_info_alloc+0x42f/0x6d1 [mac80211]
>>      ieee80211_prep_connection+0x16a/0xc55 [mac80211]
>>      ieee80211_mgd_auth+0x49f/0x5cc [mac80211]
>>      ieee80211_auth+0x13/0x15 [mac80211]
>>      cfg80211_mlme_auth+0x2c8/0x3b0 [cfg80211]
>>      nl80211_authenticate+0x4ba/0x513 [cfg80211]
>>      genl_family_rcv_msg+0x497/0x543
>>      genl_rcv_msg+0x59/0x7d
>>      netlink_rcv_skb+0x8d/0xeb
>>      genl_rcv+0x23/0x32
>>      netlink_unicast+0x1b4/0x264
>>      netlink_sendmsg+0x80a/0x842
>>      sock_sendmsg+0x66/0x80
>> INFO: Freed in sta_info_free+0xbb/0x104 [mac80211] age=223 cpu=0 pid=574
>>      __slab_free+0x4f/0x2a8
>>      kfree+0x17e/0x203
>>      sta_info_free+0xbb/0x104 [mac80211]
>>      __sta_info_destroy_part2+0x2fe/0x32f [mac80211]
>>      __sta_info_flush+0x27e/0x2d4 [mac80211]
>>      ieee80211_set_disassoc+0x1c9/0x44c [mac80211]
>>      ieee80211_sta_connection_lost+0x8b/0xcf [mac80211]
>>      ieee80211_sta_work+0xb17/0x18ba [mac80211]
>>      ieee80211_iface_work+0x43e/0x457 [mac80211]
>>      process_one_work+0x3ed/0x77c
>>      worker_thread+0x2ba/0x3c2
>>      kthread+0x162/0x171
>>      ret_from_fork+0x3f/0x70
>> INFO: Slab 0xffffea0006f44c00 objects=7 used=4 fp=0xffff8801bd1333d8
>> flags=0x5fff8000004080
>> INFO: Object 0xffff8801bd1367b0 @offset=26544 fp=0xffff8801bd135668
>>
>> Thanks,
>> Ben
>>
>
> After some more poking around, I've just more questions.
>
> What cleans up this txq_data memory in mac80211/sta_info.c so that it is not
> leaked?
>
>
>         if (local->ops->wake_tx_queue) {
>                 void *txq_data;
>                 int size = sizeof(struct txq_info) +
>                            ALIGN(hw->txq_data_size, sizeof(void *));
>
>                 txq_data = kcalloc(ARRAY_SIZE(sta->sta.txq), size, gfp);
>                 if (!txq_data)
>                         goto free;
>
>                 for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
>                         struct txq_info *txq = txq_data + i * size;
>
>                         ieee80211_init_tx_queue(sdata, sta, txq, i);
>                 }
>         }
>
>
> Maybe the sta_info destroy logic needs to go clean out the txq references
> to sta so that ath10k cannot try to access it?

This shouldn't be necessary.

ath10k unlinks txqs from ar->txqs when station is removed via
sta_state. It needs to get a hold of ar->txqs_lock which is also held
during entire push_pendning() call. This means that, unless you get
wake_tx_queue() interleaving these two, you shouldn't have dangling
references.

But apparently we *are* missing something..


Michał
