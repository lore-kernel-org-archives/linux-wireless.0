Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netsys.kaist.ac.kr ([143.248.239.50]:45149 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZKNHNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 02:13:42 -0500
From: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>
To: "'Luis R. Rodriguez'" <mcgrof@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
References: <02a401ca6370$51fa0ff0$f5ee2fd0$@kaist.ac.kr> <43e72e890911120732m74dbe2d4m14dd146cd0fb3016@mail.gmail.com> <43e72e890911131226i1a58560haeddca42c76bc1a9@mail.gmail.com>
In-Reply-To: <43e72e890911131226i1a58560haeddca42c76bc1a9@mail.gmail.com>
Subject: RE: ath9k: Unknown symbol
Date: Sat, 14 Nov 2009 16:13:24 +0900
Message-ID: <032b01ca64f9$f520c400$df624c00$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Luis,

I've compiled successfully with compat-wireless-2009-11-13 version.
Also, modprobe command has been passed successfully.
But, when configuring with "ifconfig", it shows the following kernel message and then totally shut down, resulting in reboot.

==========================================
...

<7>[  181.995318] ath: tx chmask: 1, rx chmask: 1
<7>[  181.995328] ath: BSS Changed PREAMBLE 0
<7>[  181.995335] ath: BSS Changed CTS PROT 0
<1>[  181.998952] BUG: unable to handle kernel NULL pointer dereference at 00000004
<1>[  181.999118] IP: [<c0435401>] skb_dequeue+0x41/0x70
<4>[  181.999231] *pde = 00000000
<0>[  181.999326] Oops: 0002 [#1] SMP
<0>[  181.999456] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.2/0000:03:00.0/net/wlan1/type
<4>[  181.999548] Modules linked in: ath9k ath9k_common mac80211 ath9k_hw ath cfg80211 rfkill_backport led_class lp parport snd_hda_codec_realtek arc4 ecb snd_hda_intel nls_cp437 snd_hda_codec cifs snd_hwdep iTCO_wdt iTCO_vendor_support uvcvideo snd_pcm snd_timer snd soundcore intel_agp video videodev v4l1_compat pcspkr snd_page_alloc agpgart output r8169 mii [last unloaded: led_class]
<4>[  182.001009]
<4>[  182.001070] Pid: 2745, comm: phy1 Not tainted (2.6.30-02063009-generic #02063009) M1022E
<4>[  182.001161] EIP: 0060:[<c0435401>] EFLAGS: 00010046 CPU: 0
<4>[  182.001231] EIP is at skb_dequeue+0x41/0x70
<4>[  182.001296] EAX: f5ed73c0 EBX: f5ed73c0 ECX: 00000296 EDX: 00000000
<4>[  182.001366] ESI: f6438624 EDI: f6438630 EBP: f5ed5e54 ESP: f5ed5e48
<4>[  182.001436]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<0>[  182.001506] Process phy1 (pid: 2745, ti=f5ed4000 task=f6b5d710 task.ti=f5ed4000)
<0>[  182.001592] Stack:
<4>[  182.001649]  00000078 f5ed73c0 00000000 f5ed5f70 f89a9906 f5ed73e0 f5ed5ed4 00000001
<0>[  182.001958]  f5ed5f0c f5ed5ed8 c180a018 000007fb f6438614 f6438624 f6438380 f5ed73c0
<0>[  182.002352]  f5ed73e0 f694a020 f6438646 f6438640 00000039 f6b5d710 5fbf5b76 0000002a
<0>[  182.002793] Call Trace:
<0>[  182.002825]  [<f89a9906>] ? ieee80211_ibss_work+0xc6/0xbc0 [mac80211]
<0>[  182.002825]  [<c013239b>] ? update_curr+0xeb/0x160
<0>[  182.002825]  [<c014c528>] ? run_workqueue+0x68/0x120
<0>[  182.002825]  [<f89a9840>] ? ieee80211_ibss_work+0x0/0xbc0 [mac80211]
<0>[  182.002825]  [<c014cb98>] ? worker_thread+0x88/0xe0
<0>[  182.002825]  [<c0150190>] ? autoremove_wake_function+0x0/0x40
<0>[  182.002825]  [<c014cb10>] ? worker_thread+0x0/0xe0
<0>[  182.002825]  [<c014fe0c>] ? kthread+0x4c/0x80
<0>[  182.002825]  [<c014fdc0>] ? kthread+0x0/0x80
<0>[  182.002825]  [<c01039e7>] ? kernel_thread_helper+0x7/0x10
<0>[  182.002825] Code: 1c 24 e8 e3 ba 0d 00 8b 1e 39 de 89 c1 74 3b 85 db 74 1b 83 6e 08 01 8b 13 8b 43 04 c7 03 00 00 00 00 c7 43 04 00 00 00 00 89 10 <89> 42 04 89 f8 89 ca e8 b3 bc 0d 00 89 d8 8b 1c 24 8b 74 24 04
<0>[  182.002825] EIP: [<c0435401>] skb_dequeue+0x41/0x70 SS:ESP 0068:f5ed5e48
<0>[  182.002825] CR2: 0000000000000004
<4>[  182.002825] ---[ end trace 166af52a3b602faa ]---


--
Regards,
Jinsung Lee
--


-----Original Message-----
From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] 
Sent: Saturday, November 14, 2009 5:26 AM
To: Jinsung Lee
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k: Unknown symbol

On Thu, Nov 12, 2009 at 7:32 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Nov 12, 2009 at 12:15 AM, Jinsung Lee <ljs@netsys.kaist.ac.kr> wrote:
>> Hi, all.
>>
>> I installed compat-wireless-2009-11-12 and compiled successfully.
>> But when inputting the command "modprobe ath9k", I saw the following
>> message:
>>
>> FATAL: Error inserting ath9k
>> (/lib/modules/2.6.32-020632rc6-generic/updates/drivers/net/wireless/ath/ath9
>> k/ath9k.ko): Unknown symbol in module, or unknown parameter (see dmesg)
>>
>> And dmesg shows the following:
>>
>> [582122.800191] ath9k: Unknown symbol ath9k_cmn_rx_skb_preprocess
>> [582122.803675] ath9k: Unknown symbol ath9k_cmn_rx_skb_postprocess
>>
>> Actually, I haven't seen this kind of message before.
>> Is there any workaround solution for this?
>
> compat-wireless just needs to be updated, I'll take care of this.

Ok try the new tarball release.

git-describe for wireless-testing.git says: v2.6.32-rc6-41741-ga601a39
This is a bleeding edge compat-wireless release based on: master-2009-11-11
This is compat-release: master-2009-11-11

  Luis

