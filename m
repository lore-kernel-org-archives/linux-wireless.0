Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D14C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 19:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09C9D204EC
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 19:19:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09C9D204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbeJXDn5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 23:43:57 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:33984 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbeJXDn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 23:43:57 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 310B540A7E2;
        Tue, 23 Oct 2018 12:19:11 -0700 (PDT)
Subject: Re: Should we check netif_running in cfg80211_calculate_bi_data?
To:     Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <8c876445-a065-ddb2-4dcf-e922f22a1b7d@candelatech.com>
 <7ac1d7a5f25ebcd44107c3a19e0d8140f37227c6.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <5e048867-0294-4218-6b2b-bcbcad5be763@candelatech.com>
Date:   Tue, 23 Oct 2018 12:19:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <7ac1d7a5f25ebcd44107c3a19e0d8140f37227c6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/23/2018 02:32 AM, Johannes Berg wrote:
> On Mon, 2018-10-22 at 13:27 -0700, Ben Greear wrote:
>> I was testing on my 4.16 kernel with a bunch of VAPs and I had two configured
>> for 100 beacon interval, and more at 240.  This failed for reasons I figured out
>> (gcd logic), but even once I tried to configure the vaps for 240 interval they
>> could not come up.  I am thinking maybe it was because I could only re-configure
>> admin-up interfaces, and they couldn't come up due the gcd thing?
>>
>> Anyway, while poking, I thought maybe the patch below would be helpful since
>> we shouldn't care about admin-down interfaces in this case?
>>
>> diff --git a/net/wireless/util.c b/net/wireless/util.c
>> index fbc880e..56d7583 100644
>> --- a/net/wireless/util.c
>> +++ b/net/wireless/util.c
>> @@ -1541,6 +1541,9 @@ static void cfg80211_calculate_bi_data(struct wiphy *wiphy, u32 new_beacon_int,
>>                  if (wdev->beacon_interval == *beacon_int_gcd)
>>                          continue;
>>
>> +               if (!netif_running(wdev->netdev))
>> +                       continue;
>> +
>
> I don't think we'd ever get to this check, since those interfaces will
> always have wdev->beacon_interval == 0, checked a few lines before this
> code at the beginning of the loop? At least they should have, but a
> quick check suggests that is true.

Ok, that netif_running thing was just dumb luck that it started working for me.
It doesn't really fix the problem.

Here is how I reproduce:

Create 32 vdevs (I'm quite sure fewer would work).  Have one with beacon-int 100,
have others with beacon int-240.

Try to start all of them.  Assume the 240 ones start first, so they win and start.
The 100 one fails correctly.

Now, reconfigure the 100 one to have 240 and restart its hostapd.  It will fail
to come up like this (I added WARN-ON and other kernel debugging to track down the
failure path):

Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: Assigning beacon-in-gcd to: 240 from wdev: vap39
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: beacon-int-diff, beacon-int-gcd: 240  new-beacon-int: 100
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: WARNING: CPU: 3 PID: 28533 at /home/greearb/git/linux-4.16.dev.y/net/wireless/util.c:1564 
cfg80211_iter_combinations+0x2ff/0x3b0 [cfg80211]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: Modules linked in: nf_conntrack_netlink nfnetlink nf_conntrack_ipv4 iptable_raw xt_CT nf_conntrack bridge 
wanlink(O) mac80211_hwsim ath10k_pci ath10k_core ath5k ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nf_defrag_ipv4 libcrc32c vrf 8021q garp mrp stp llc 
fuse macvlan pktgen rpcsec_gss_krb5 nfsv4 nfs fscache snd_hda_codec_hdmi coretemp intel_rapl x86_pkg_temp_thermal snd_hda_codec_realtek intel_powerclamp 
snd_hda_codec_generic snd_hda_intel snd_hda_codec kvm iTCO_wdt snd_hda_core iTCO_vendor_support snd_hwdep irqbypass snd_seq snd_seq_device hwmon i2c_i801 
snd_pcm snd_timer lpc_ich snd shpchp soundcore nfsd auth_rpcgss nfs_acl lockd grace sunrpc sch_fq_codel serio_raw i915 i2c_algo_bit drm_kms_helper e1000e drm 
i2c_core video ipv6 crc_ccitt [last unloaded: nfnetlink]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: CPU: 3 PID: 28533 Comm: hostapd Tainted: G        W  O     4.16.18+ #50
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: Hardware name: To be filled by O.E.M. To be filled by O.E.M./ChiefRiver, BIOS 4.6.5 06/07/2013
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RIP: 0010:cfg80211_iter_combinations+0x2ff/0x3b0 [cfg80211]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RSP: 0018:ffffc9000327ba90 EFLAGS: 00010286
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RAX: 0000000000000039 RBX: 0000000000000064 RCX: 0000000000000000
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RDX: ffff88021e39ea80 RSI: ffff88021e396698 RDI: ffff88021e396698
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RBP: ffff88020c618700 R08: 0000000000000000 R09: 00000000000089fa
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: R10: ffffc9000327bb88 R11: 0000000000000001 R12: 00000000000000f0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: R13: ffff88020c6186f0 R14: ffffc9000327bb10 R15: ffff88020c6182e0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: FS:  00007f6d8b5db800(0000) GS:ffff88021e380000(0000) knlGS:0000000000000000
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: CR2: 00007fbee7b3e280 CR3: 000000020bf08002 CR4: 00000000001606e0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? cfg80211_netdev_notifier_call+0x65/0x610 [cfg80211]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? skb_queue_tail+0x16/0x40
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? ieee80211_chandef_to_operating_class+0x1d0/0x1d0 [cfg80211]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  cfg80211_check_combinations+0x1e/0x60 [cfg80211]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ieee80211_check_combinations+0x171/0x260 [mac80211]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? netlink_deliver_tap+0x35/0x200
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ieee80211_check_concurrent_iface+0x114/0x210 [mac80211]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ieee80211_open+0x2f/0x50 [mac80211]
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  __dev_open+0xaa/0x130
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  __dev_change_flags+0x154/0x190
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  dev_change_flags+0x1e/0x60
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  devinet_ioctl+0x570/0x690
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  inet_ioctl+0xa5/0x190
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? _copy_to_user+0x22/0x30
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? move_addr_to_user+0xb9/0xd0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? dev_get_by_name_rcu+0x6a/0x90
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? dev_get_by_name_rcu+0x6a/0x90
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? sock_do_ioctl+0x42/0x140
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? _copy_to_user+0x22/0x30
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  sock_do_ioctl+0x42/0x140
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? __generic_file_write_iter+0x191/0x1d0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? sock_ioctl+0x270/0x310
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  sock_ioctl+0x270/0x310
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? __vfs_write+0xce/0x140
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? do_vfs_ioctl+0x86/0x5d0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  do_vfs_ioctl+0x86/0x5d0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb3/0x110
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? syscall_trace_enter+0x1a5/0x2b0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  SyS_ioctl+0x71/0x80
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_exit+0x1e7/0x280
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x67/0x1e0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f6d89f3acc7
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fff46aec078 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000002770e10 RCX: 00007f6d89f3acc7
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RDX: 00007fff46aec090 RSI: 0000000000008914 RDI: 0000000000000009
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: RBP: 00007fff46aec0c0 R08: 0000000002776a40 R09: 0000000000000000
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: R10: 0000000000019570 R11: 0000000000000206 R12: 0000000000409f70
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: R13: 00007fff46aec5b0 R14: 0000000000000000 R15: 0000000000000000
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: Code: e0 48 8b 05 64 d4 08 00 48 85 c0 74 03 8b 58 18 e8 27 b3 7a e0 e9 f7 fd ff ff 89 da 44 89 e6 48 c7 c7 c0 
af a1 a0 e8 e6 f7 79 e0 <0f> 0b 44 89 e7 c6 44 24 0b 01 e9 c0 fd ff ff 8b 14 24 89 ee 48
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: ---[ end trace caf55d545c1bf6a6 ]---
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: iter-comb: !c->beacon_int_min_gcd: 0  && beacon_int_different: 1
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: cfg-comb-check: iter-combinations returned num==0
Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: vap2: check-concurrent-iface:  check-combinations failed: -16


hostap reports:

1540322126.216946: Could not set interface vap2 flags (UP): Device or resource busy
1540322126.216956: nl80211: Could not set interface 'vap2' UP
1540322126.216960: nl80211: deinit ifname=vap2
1540322126.216977: nl80211: Remove monitor interface: refcount=0


Maybe we need to clear beacon-interval back to 0 on admin down of the wifi dev?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

