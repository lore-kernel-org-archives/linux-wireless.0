Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:54549 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZGWVyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 17:54:07 -0400
Message-ID: <4A68DBDE.7060504@redfish-solutions.com>
Date: Thu, 23 Jul 2009 14:53:34 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Using compat-wireless w/ 2.6.27.26
References: <4A612514.4050708@redfish-solutions.com>	 <4A635E04.4050204@redfish-solutions.com>	 <20090719203150.GA9972@hash.localnet>	 <4A63DF0B.4010801@redfish-solutions.com>	 <20090720115244.GC9972@hash.localnet>	 <4A64C283.6090205@redfish-solutions.com>	 <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com>	 <4A650331.9020409@redfish-solutions.com>	 <4A6620B9.4@redfish-solutions.com>	 <20090723112428.GC13742@hash.localnet> <b6c5339f0907230459g75cef6eag1ad0caa7b1a631b8@mail.gmail.com> <4A68C821.7060208@redfish-solutions.com>
In-Reply-To: <4A68C821.7060208@redfish-solutions.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip A. Prindeville wrote:
> Bob Copeland wrote:
>   
>> On Thu, Jul 23, 2009 at 7:24 AM, Bob Copeland<me@bobcopeland.com> wrote:
>>     
>>> -       ath5k_tx_processq(sc, sc->txq);
>>> +       for (i=0; i < AR5K_NUM_TX_QUEUES; i++) {
>>> +               if (!sc->txqs[i].setup)
>>> +                       continue;
>>> +               ath5k_tx_processq(sc, sc->txq);
>>>       
>> oops, should be:
>>
>> ath5k_tx_processq(sc, sc->txqs[i]);
>>
>>     
>>> +       }
>>>  }
>>>
>>>       
>
> Getting closer :-)
>
> ath5k_tx_processq(sc, &sc->txqs[i]);
>   

Didn't work with rc4:

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<d0935658>] :ath5k:ath5k_tasklet_tx+0x5e/0x27b
*pde = 00000000 
Oops: 0000 [#1] PREEMPT 
Modules linked in: lm90 hwmon scx200_acb i2c_core bridge stp llc dummy ath5k mac80211 ath cfg80211 rfkill_backport dahdi_dummy dahdi sha512_generic sha256_generic deflate zlib_deflate arc4 ecb sha1_generic blowfish des_generic cbc cryptosoft cryptodev(P) ocf(P) geodewdt geode_rng geode_aes crypto_blkcipher via_rhine rtc

Pid: 1585, comm: hostapd Tainted: P          (2.6.27.26-astlinux #1)
EIP: 0060:[<d0935658>] EFLAGS: 00010202 CPU: 0
EIP is at ath5k_tasklet_tx+0x5e/0x27b [ath5k]
EAX: c5712000 EBX: cf994000 ECX: 00000000 EDX: 00000000
ESI: ffffff8d EDI: c5713d00 EBP: c5488920 ESP: c5713ccc
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process hostapd (pid: 1585, ti=c5712000 task=cf86a0a0 task.ti=c5712000)
Stack: c5713cec c548bf9c c548bfb0 c548bfd0 c011a1d7 00000000 00000028 c548bfb0 
       00000000 00000000 00000000 00000000 00000000 00000000 c039d214 0000000a 
       00000009 c011a3f9 00000001 c011a111 00000046 c03473f4 00000000 c011a161 
Call Trace:
 [<c011a1d7>] _local_bh_enable_ip+0x72/0x7c
 [<c011a3f9>] tasklet_action+0x3c/0x62
 [<c011a111>] __do_softirq+0x30/0x5e
 [<c011a161>] do_softirq+0x22/0x26
 [<c011a4fa>] irq_exit+0x25/0x33
 [<c0104a14>] do_IRQ+0x4d/0x5d
 [<c0103a1b>] common_interrupt+0x23/0x28
 [<c02445ec>] __sock_sendmsg+0x20/0x24
 [<c0245331>] sock_sendmsg+0x95/0xad
 [<c0125714>] autoremove_wake_function+0x0/0x2b
 [<c0125714>] autoremove_wake_function+0x0/0x2b
 [<c013aca6>] get_pageblock_flags_group+0xf/0x50
 [<c024b551>] verify_iovec+0x3e/0x6d
 [<c02454d6>] sys_sendmsg+0x18d/0x1ed
 [<c0245d72>] sys_recvmsg+0x144/0x1c6
 [<c0245de0>] sys_recvmsg+0x1b2/0x1c6
 [<c0113a7b>] __wake_up+0x1d/0x45
 [<c0113a93>] __wake_up+0x35/0x45
 [<c024dc8e>] dev_name_hash+0x13/0x42
 [<c024dc8e>] dev_name_hash+0x13/0x42
 [<c024dcec>] __dev_get_by_name+0x2f/0x39
 [<c011a1d7>] _local_bh_enable_ip+0x72/0x7c
 [<c0246dd0>] lock_sock_nested+0xb1/0xb8
 [<c011a1d7>] _local_bh_enable_ip+0x72/0x7c
 [<c0246377>] sys_socketcall+0x15b/0x193
 [<c0152703>] sys_close+0x75/0xc5
 [<c01038b6>] syscall_call+0x7/0xb
 =======================
Code: 00 03 85 b0 36 00 00 8b 3c 24 fc 89 44 24 0c 31 c0 ab ab ab ab ab 89 e0 25 00 e0 ff ff ff 40 14 8b 54 24 0c 8b 52 08 89 54 24 14 <8b> 02 8b 54 24 0c 83 c2 08 89 44 24 1c 89 54 24 08 e9 96 01 00 
EIP: [<d0935658>] ath5k_tasklet_tx+0x5e/0x27b [ath5k] SS:ESP 0068:c5713ccc
Kernel panic - not syncing: Fatal exception in interrupt


