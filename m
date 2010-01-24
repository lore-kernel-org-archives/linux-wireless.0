Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:50673 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab0AXIPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 03:15:09 -0500
Message-ID: <4B5C0173.9080100@redfish-solutions.com>
Date: Sun, 24 Jan 2010 00:14:43 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>,
	Markus Baier <markus_baier@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Starting hostapd causes kernel panic
References: <loom.20100122T205326-794@post.gmane.org>	<1264193623.2593.17.camel@johannes.local> <1264196526.3040.3.camel@mj>	<3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>	<1264197963.9056.0.camel@mj> <1264251576.2593.30.camel@johannes.local>	<4B5B6FCA.2070900@redfish-solutions.com> <87aaw4oxh0.fsf@purkki.valot.fi>
In-Reply-To: <87aaw4oxh0.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2010 09:58 PM, Kalle Valo wrote:
> "Philip A. Prindeville" <philipp_subx@redfish-solutions.com> writes:
> 
>>>> Whatever you prefer.  Either way, the panic is fixed now!
>>>>     
>>> Great, and sorry about that! I'll send a patch to insert the else too.
>>>
>>> johannes
>>>   
>>
>> Did you send that patch? I'd like to apply it. Please copy me when
>> you send it out.
> 
> Johannes was busy and I sent the patch instead. It's here:
> 
> http://marc.info/?l=linux-wireless&m=126427124317427&w=2
> 

I just applied it to compat-wireless-2010-01-20 and ran it on an AR5413 but it still panics:


BUG: unable to handle kernel NULL pointer dereference at 0000019f
IP: [<e0993e7f>] :mac80211:invoke_tx_handlers+0x5be/0xe6a
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: aes_i586 aes_generic pc87360 hwmon_vid hwmon bridge stp llc dummy ath5k mac80211 ath cfg80211 rfkill_backport compat dahdi_dummy dahdi sha512_generic sha256_generic deflate zlib_deflate arc4 ecb sha1_generic blowfish des_generic cbc cryptosoft cryptodev(P) ocf(P) geodewdt geode_rng geode_aes crypto_blkcipher via_rhine rtc cs5535_gpio

Pid: 1652, comm: hostapd Tainted: P          (2.6.27.42-astlinux #1)
EIP: 0060:[<e0993e7f>] EFLAGS: 00010246 CPU: 0
EIP is at invoke_tx_handlers+0x5be/0xe6a [mac80211]
EAX: 00000000 EBX: df0b7cac ECX: 00000000 EDX: df0b7cac
ESI: df22dce0 EDI: df22dcc0 EBP: df22dce0 ESP: df0b7c10
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process hostapd (pid: 1652, ti=df0b6000 task=dfa43be0 task.ti=df0b6000)
Stack: df032920 00000000 dfa43be0 df0b7cac df22dcc0 df22dce0 df5658dc dfa75640
       dfaa5b60 df22dce0 df0b7cac e099362e df0b7cac df0b7c5c df27a45e df204260
       dfa43be0 c0112426 00100100 df27a450 0000000e 0000000f df27a45c 00000012
Call Trace:
 [<e099362e>] ieee80211_tx_prepare+0x2ed/0x327 [mac80211]
 [<c0112426>] default_wake_function+0x0/0x8
 [<e0994904>] ieee80211_tx+0x94/0x21b [mac80211]
 [<c02511cd>] pskb_expand_head+0xe7/0x14d
 [<e0994bfd>] ieee80211_xmit+0x172/0x196 [mac80211]
 [<e0994f3e>] ieee80211_monitor_start_xmit+0x8e/0xa0 [mac80211]
 [<c02559d0>] dev_hard_start_xmit+0x196/0x1ef
 [<c02611a8>] __qdisc_run+0xa1/0x183
 [<c0257aee>] dev_queue_xmit+0x161/0x283
 [<c0252311>] memcpy_fromiovec+0x28/0x4b
 [<c02a3efc>] packet_sendmsg+0x1ba/0x200
 [<c024c174>] sock_sendmsg+0xb7/0xd0
 [<c0123bde>] autoremove_wake_function+0x0/0x2b
 [<c0123bde>] autoremove_wake_function+0x0/0x2b
 [<c015abe6>] core_sys_select+0x260/0x285
 [<c0252579>] verify_iovec+0x3e/0x6d
 [<c024c31a>] sys_sendmsg+0x18d/0x1f0
 [<c013c232>] mark_page_accessed+0x18/0x27
 [<c013778a>] filemap_fault+0x202/0x364
 [<c01b7abc>] unionfs_fault+0x50/0x58
 [<c0140071>] __do_fault+0x2b7/0x2e9
 [<c01411fb>] handle_mm_fault+0x219/0x4a3
 [<c024d209>] sys_socketcall+0x15b/0x193
 [<c02ad674>] do_page_fault+0x0/0x60d
 [<c01037e6>] syscall_call+0x7/0xb
 [<c02a0000>] unix_dgram_disconnected+0x39/0x4e
 =======================
Code: 00 00 10 74 1f 0f b7 03 a8 0c 0f 84 52 08 00 00 eb 12 0f b7 03 a8 0c 74 0b 8b 4c 24 0c c7 41 10 00 00 00 00 8b 5c 24 0c 8b 43 10 <f6> 80 9f 01 00 00 01 0f 84 2a 08 00 00 05 98 01 00 00 89 45 1c
EIP: [<e0993e7f>] invoke_tx_handlers+0x5be/0xe6a [mac80211] SS:ESP 0068:df0b7c10
Kernel panic - not syncing: Fatal exception in interrupt


Slightly different from Markus's trace.

