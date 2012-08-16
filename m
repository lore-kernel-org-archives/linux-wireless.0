Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:59890 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab2HPNOC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 09:14:02 -0400
Date: Thu, 16 Aug 2012 16:52:51 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Felix Liao <Felix.Liao@watchguard.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: DMA stop failure issues still happen using the stable compat
 wireless driver
In-Reply-To: <1AA9BD91549CF94C901B05C32D2B081101DF32D1@ES02Ch.wgti.net>
Message-ID: <alpine.DEB.2.02.1208161649590.4467@icf.org.ru> (sfid-20120816_151411_870584_7B93CD3F)
References: <1AA9BD91549CF94C901B05C32D2B081101DF32D1@ES02Ch.wgti.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-1312760313-1345121571=:4467"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-1312760313-1345121571=:4467
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-08-16 03:31 -0000, Felix Liao wrote linux-wireless@vger.kernel.org:

Same issues with varyous ar9220 cards, a lots of ath: phy0: Failed to stop TX DMA, queues=0x005!,
mainly seems with pure quality links.

FL>Hi All,
FL>      It's said that the DMA stop failure issues had been fixed on the stable compat wireless driver on the web site (http://linuxwireless.org/en/users/Drivers/ath9k/bugs#DMA_stop_failure_issues),
FL>but it still happen on my Atheros AR9160 mini-pci wireless card, which can be found by vendor on the device list (http://linuxwireless.org/en/users/Devices/PCI)
FL>according to the result of lspci : 00:02.0 Class 0280: 168c:0027.
FL>
FL>the boot messages:
FL>[   80.479541] Compat-wireless backport release: compat-wireless-v3.5-3
FL>[   80.485980] Backport based on linux-stable.git v3.5
FL>[   80.490871] compat.git: linux-stable.git
FL>[   80.904796] cfg80211: Calling CRDA to update world regulatory domain
FL>[   82.446828] PCI: enabling device 0000:00:02.0 (0340 -> 0342)
FL>[   84.011422] ath: EEPROM regdomain: 0x0
FL>[   84.011445] ath: EEPROM indicates default country code should be used
FL>[   84.011461] ath: doing EEPROM country->regdmn map search
FL>[   84.011485] ath: country maps to regdmn code: 0x3a
FL>[   84.011501] ath: Country alpha2 being used: US
FL>[   84.011514] ath: Regpair used: 0x3a
FL>[   84.025103] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
FL>[   84.033637] Registered led device: ath9k-phy0
FL>[   84.033677] ieee80211 phy0: Atheros AR9160 MAC/BB Rev:0 AR5133 RF Rev:b0 mem=0xd2a20000, irq=6
FL>
FL>the kernel version we used:
FL>2.6.35.12
FL>
FL>the kernel crash calltrace:
FL>[  402.462677] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x000267c0
FL>[  402.462722] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
FL>[  402.470324] ath: phy0: Failed to stop TX DMA, queues=0x004!
FL>[  410.082258] Unable to handle kernel paging request at virtual address fc253f0f
FL>[  410.089791] pgd = c8608000
FL>[  410.092596] [fc253f0f] *pgd=00000000
FL>[  410.096182] Internal error: Oops: f3 [#1]
FL>[  410.100185] last sysfs file: /sys/module/xt_session/parameters/account_empty
FL>[  410.102565] CPU: 0    Tainted: P             (2.6.35.12 #1)
FL>[  410.102565] PC is at put_page+0xc/0x14c
FL>[  410.102565] LR is at skb_release_data+0x74/0xc8
FL>[  410.102565] pc : [<c007cbbc>]    lr : [<c021111c>]    psr: 80000013
FL>[  410.102565] sp : ca385ee8  ip : ca385f00  fp : ca385efc
FL>[  410.102565] r10: cf08b788  r9 : c3dc5040  r8 : ca224608
FL>[  410.102565] r7 : ca37cbd4  r6 : 0000000c  r5 : 00000000  r4 : ca283a80
FL>[  410.102565] r3 : 0000fc25  r2 : c3dc5800  r1 : 00000000  r0 : fc253f0f
FL>[  410.102565] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
FL>[  410.102565] Control: 000039ff  Table: 08608000  DAC: 00000017
FL>[  410.102565] Process phy0 (pid: 79, stack limit = 0xca384278)
FL>[  410.102565] Stack: (0xca385ee8 to 0xca386000)
FL>[  410.102565] 5ee0:                   ca283a80 00000000 ca385f1c ca385f00 c021111c c007cbbc
FL>[  410.102565] 5f00: ca283a80 ca283a80 ca37ca60 ca37cbd4 ca385f34 ca385f20 c0210c94 c02110b4
FL>[  410.102565] 5f20: cf08b300 ca283a80 ca385f44 ca385f38 c0210de0 c0210c84 ca385f84 ca385f48
FL>[  410.102565] 5f40: bf777b70 c0210da0 c02d89fc c003bf68 bf82a724 cf08b5d4 ca37e9b0 ca224600
FL>[  410.102565] 5f60: ca384000 bf77791c ca385f8c ca224608 00000000 00000000 ca385fc4 ca385f88
FL>[  410.102565] 5f80: c0050ce0 bf777928 c02d89fc 00000000 cf2fd9e0 c0054790 ca385f98 ca385f98
FL>[  410.102565] 5fa0: cfea5c48 ca385fcc c0050bcc ca224600 00000000 00000000 ca385ff4 ca385fc8
FL>[  410.102565] 5fc0: c005431c c0050bd8 00000000 00000000 ca385fd0 ca385fd0 cfea5c48 c0054298
FL>[  410.102565] 5fe0: c0042514 00000013 00000000 ca385ff8 c0042514 c00542a4 23511200 0e54c68e
FL>[  410.102565] Backtrace: 
FL>[  410.102565] [<c007cbb0>] (put_page+0x0/0x14c) from [<c021111c>] (skb_release_data+0x74/0xc8)
FL>[  410.102565]  r5:00000000 r4:ca283a80
FL>[  410.102565] [<c02110a8>] (skb_release_data+0x0/0xc8) from [<c0210c94>] (__kfree_skb+0x1c/0xcc)
FL>[  410.102565]  r7:ca37cbd4 r6:ca37ca60 r5:ca283a80 r4:ca283a80
FL>[  410.102565] [<c0210c78>] (__kfree_skb+0x0/0xcc) from [<c0210de0>] (kfree_skb+0x4c/0x50)
FL>[  410.102565]  r5:ca283a80 r4:cf08b300
FL>[  410.102565] [<c0210d94>] (kfree_skb+0x0/0x50) from [<bf777b70>] (ieee80211_iface_work+0x254/0x2c8 [mac80211])
FL>[  410.102565] [<bf77791c>] (ieee80211_iface_work+0x0/0x2c8 [mac80211]) from [<c0050ce0>] (worker_thread+0x114/0x19c)
FL>[  410.102565] [<c0050bcc>] (worker_thread+0x0/0x19c) from [<c005431c>] (kthread+0x84/0x8c)
FL>[  410.102565] [<c0054298>] (kthread+0x0/0x8c) from [<c0042514>] (do_exit+0x0/0x60c)
FL>[  410.102565]  r7:00000013 r6:c0042514 r5:c0054298 r4:cfea5c48
FL>[  410.102565] Code: c007cfac e1a0c00d e92dd830 e24cb004 (e5902000) 
FL>[  410.529134] ---[ end trace 183d07baec51de43 ]---
FL>
FL>I trace this issue to find that the root cause is the failure of stopping RX/TX DMA.
FL> 
FL>Tracing the crash calltrace, the skb to free is dequeued from sdata->skb_queue, where the skb was got from the DMA buffer in ath_rx_tasklet and queued tail in ieee80211_rx, 
FL>but the shinfo in some skb has invalid value, which causes kfree_skb to crash the kernel.
FL>skb_shinfo(skb)->nr_frags = 65535 and skb_shinfo(skb)->frags[0].page = fc253f0f
FL>I think we get the invalid skb from the DMA buffer because we fail to stop the RX DMA.
FL>
FL>We debug why ath9k_hw_stopdmarecv() output the error messages "DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006b30", 
FL>we suspect the check of "mac_status == 0x1c0" does not work well on AR9160, then we output the value of mac_status, and we get three numbers: 0x330, 0x7c0, 0x40, but not 0x1c0.
FL>We have no idea what the registers AR_CR, AR_MACMISC and DMADBG_7 stand for on  AR9160.
FL>
FL>And then we debug why ath_drain_all_txq() output the error messages "Failed to stop TX DMA, queues=0x001!", this time we have nothing result.
FL>Can you help us? Thanks!
FL>
FL>Best regards,
FL>
FL>Felix
FL>--
FL>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
FL>the body of a message to majordomo@vger.kernel.org
FL>More majordomo info at  http://vger.kernel.org/majordomo-info.html
FL>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-1312760313-1345121571=:4467--
