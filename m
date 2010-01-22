Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:56299 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825Ab0AVWEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:04:06 -0500
Message-ID: <4B5A20C3.6020304@redfish-solutions.com>
Date: Fri, 22 Jan 2010 14:03:47 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Peter Svensson <petersv@psv.nu>, linux-wireless@vger.kernel.org
Subject: Re: Compat-wireless bleeding-edge daily builds broken since 	2009-12-11
References: <Pine.LNX.4.64.0912261245080.5112@cheetah.psv.nu> 	<20091229020027.GE30201@bombadil.infradead.org> <4B59FC5E.1020802@redfish-solutions.com> <43e72e891001221153w5c4c4bc6g63883b5012d384b7@mail.gmail.com>
In-Reply-To: <43e72e891001221153w5c4c4bc6g63883b5012d384b7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2010 11:53 AM, Luis R. Rodriguez wrote:
> On Fri, Jan 22, 2010 at 11:28 AM, Philip A. Prindeville
> <philipp_subx@redfish-solutions.com> wrote:
>> On 12/28/2009 06:00 PM, Luis R. Rodriguez wrote:
>>> On Sat, Dec 26, 2009 at 12:50:23PM +0100, Peter Svensson wrote:
>>>
>>>> Hi,
>>>>
>>>> The bleeding edge nightly snapshopts in
>>>>   http://wireless.kernel.org/download/compat-wireless-2.6/
>>>> are not updated since the compat-bluetooth were introduced (I think) on
>>>> 2009-12-11.
>>>>
>>>> When built from the git sources the driver works very nicely, and much
>>>> more stable than the last drop on 2009-12-11.
>>>>
>>> This will be fixed soon, just need to re-instate access to the box.
>>>
>>>   Luis
>>>
>>
>>
>> Is this the issue I'm seeing?  Has it been fixed yet?
> 
> Well so I now have access to the box but the box got a face lift and
> during that time I didn't want to clone linux-next on it. While all
> that happened in the background I just started making bleeding edge
> compat-wireless releases on orbit-lab.org along with updating the
> symlink to point to the latest dated release.
> 
> wireless.kernel.org upgrade has now completed but I think I prefer to
> continue doing the bleeding edge compat-wireless updates on
> orbit-lab.org as I have full access there and can soon start doing
> compile tests for each kernel as I have unlimited disk space (or so I
> like to believe). I see it useful to still have the bleeding edge
> tarball on wireless.kernel.org though due to the URL name, etc, but I
> can just scp it over. I haven't gotten to that yet.
> 
> For now use:
> 
> http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
> 
> for bleeding edge
> 
> Seems my cronjobs aren't kicking off yet, will debug that today too.
> 
>   Luis

Just ran against the tarball of 2010-01-20 on linux 2.6.27.42:

br1: port 1(ap0) entering disabled state
br1: topology change detected, propagating
br1: port 1(ap0) entering forwarding state
Starting dnsmasq...
Starting ntpd...
BUG: unable to handle kernel NULL pointer dereference at 0000019f
IP: [<d09cbe50>] :mac80211:invoke_tx_handlers+0x58f/0xe6a
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: aes_i586 aes_generic lm90 hwmon scx200_acb i2c_core bridge stp llc dummy ath9k ath9k_common mac80211 ath9k_hw ath cfg80211 rfkill_backport compat dahdi_dummy dahdi sha512_generic sha256_generic deflate zlib_deflate arc4 ecb sha1_generic blowfish des_generic cbc cryptosoft cryptodev(P) ocf(P) geodewdt geode_rng geode_aes crypto_blkcipher via_rhine rtc leds_alix

Pid: 1721, comm: hostapd Tainted: P          (2.6.27.42-astlinux #1)
EIP: 0060:[<d09cbe50>] EFLAGS: 00010246 CPU: 0
EIP is at invoke_tx_handlers+0x58f/0xe6a [mac80211]
EAX: 00000000 EBX: cdcf825e ECX: 00000000 EDX: cdd27cac
ESI: cdca6f20 EDI: cdca6f00 EBP: cdca6f20 ESP: cdd27c10
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process hostapd (pid: 1721, ti=cdd26000 task=cfa7bbe0 task.ti=cdd26000)
Stack: cf968ac0 00000000 cfa7bbe0 cdd27cac cdca6f00 cdca6f20 cf5878dc cfa02440
       cdc27360 cdca6f20 cdd27cac d09cb62e cdd27cac cdd27c5c cdcf825e cfbe4260
       cfa7bbe0 c0112426 00100100 cdcf8250 0000000e 0000000f cdcf825c 00000012
Call Trace:
 [<d09cb62e>] ieee80211_tx_prepare+0x2ed/0x327 [mac80211]
 [<c0112426>] default_wake_function+0x0/0x8
 [<d09cc904>] ieee80211_tx+0x94/0x21b [mac80211]
 [<c0251b65>] pskb_expand_head+0xe7/0x14d
 [<d09ccbfd>] ieee80211_xmit+0x172/0x196 [mac80211]
 [<d09ccf3e>] ieee80211_monitor_start_xmit+0x8e/0xa0 [mac80211]
 [<c0256368>] dev_hard_start_xmit+0x196/0x1ef
 [<c0261b40>] __qdisc_run+0xa1/0x183
 [<c0258486>] dev_queue_xmit+0x161/0x283
 [<c0252ca9>] memcpy_fromiovec+0x28/0x4b
 [<c02a4894>] packet_sendmsg+0x1ba/0x200
 [<c024cb0c>] sock_sendmsg+0xb7/0xd0
 [<c0123bde>] autoremove_wake_function+0x0/0x2b
 [<c0123bde>] autoremove_wake_function+0x0/0x2b
 [<c015abe6>] core_sys_select+0x260/0x285
 [<c0252f11>] verify_iovec+0x3e/0x6d
 [<c024ccb2>] sys_sendmsg+0x18d/0x1f0
 [<c013c232>] mark_page_accessed+0x18/0x27
 [<c013778a>] filemap_fault+0x202/0x364
 [<c01b7abc>] unionfs_fault+0x50/0x58
 [<c0140071>] __do_fault+0x2b7/0x2e9
 [<c01411fb>] handle_mm_fault+0x219/0x4a3
 [<c024dba1>] sys_socketcall+0x15b/0x193
 [<c02ae00c>] do_page_fault+0x0/0x60d
 [<c01037e6>] syscall_call+0x7/0xb
 [<c02a0000>] xfrm_output+0x66/0x9a
 =======================
Code: 7d 08 00 00 80 e6 40 75 1b 8a 41 18 3c 04 0f 84 6d 08 00 00 3c 07 0f 84 65 08 00 00 3c 7f 0f 84 5d 08 00 00 8b 54 24 0c 8b 42 10 <f6> 80 9f 01 00 00 10 74 1f 0f b7 03 a8 0c 0f 84 52 08 00 00 eb
EIP: [<d09cbe50>] invoke_tx_handlers+0x58f/0xe6a [mac80211] SS:ESP 0068:cdd27c10
Kernel panic - not syncing: Fatal exception in interrupt


