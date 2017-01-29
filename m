Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdA2N41 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jan 2017 08:56:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: linuxwifi@intel.com
Subject: [regression] iwlwifi: crash in iwl_parse_tlv_firmware()
Date: Sun, 29 Jan 2017 15:56:20 +0200
Message-ID: <87inoyt1ff.fsf@kamboji.qca.qualcomm.com> (sfid-20170129_145636_157794_3672B13D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

updated the kernel on my test laptop and noticed that now iwlwifi
crashes every time during boot. This is with tag ath-201701271935
ath.git master branch, which essentially is wt-2017-01-27 from
wireless-testing plus latest ath patches.

I tried v4.10-rc5 and iwlwifi didn't crash so my guess is that this is a
regression in the latest iwlwifi pull. Below is the crash log and the
location in source. This is all I got via netconsole.

[   39.296218] Intel(R) Wireless WiFi driver for Linux
[   39.296219] Copyright(c) 2003- 2015 Intel Corporation
[   39.299373] iwlwifi 0000:44:00.0: can't disable ASPM; OS doesn't have ASPM control
[   39.677192] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[   39.677212] IP: iwl_parse_tlv_firmware.isra.5+0x9a0/0xd60 [iwlwifi]
[   39.677213] *pdpt = 000000002f5bd001 *pde = 0000000000000000 
[   39.677215] 
[   39.677217] Oops: 0002 [#1] SMP
[   39.677219] Modules linked in: btrtl(+) snd_seq_midi_event btbcm rfcomm(+) iwlwifi snd_rawmidi btintel bnep joydev input_leds coretemp cfg80211 bluetooth snd_seq snd_timer serio_raw snd_seq_device wmi snd video mac_hid soundcore lpc_ich shpchp parport_pc ppdev lp parport psmouse firewire_ohc
[   39.677244] CPU: 3 PID: 35 Comm: kworker/3:1 Not tainted 4.10.0-rc5-wt-ath+ #173
[   39.677245] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010
[   39.677252] Workqueue: events request_firmware_work_func
[   39.677254] task: f387bac0 task.stack: f3916000
[   39.677263] EIP: iwl_parse_tlv_firmware.isra.5+0x9a0/0xd60 [iwlwifi]
[   39.677264] EFLAGS: 00010293 CPU: 3
[   39.677266] EAX: 00000000 EBX: 0001ec18 ECX: f8fc2060 EDX: 000339f8
[   39.677267] ESI: f8fc2058 EDI: f8fe0c78 EBP: f3917e54 ESP: f3917df8
[   39.677268]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   39.677270] CR0: 80050033 CR2: 0000000c CR3: 3033cd20 CR4: 000006f0
[   39.677271] Call Trace:

gdb drivers/net/wireless/intel/iwlwifi/iwlwifi.ko
(gdb) l *(iwl_parse_tlv_firmware+0x9a0)
0x2170 is in iwl_parse_tlv_firmware (drivers/net/wireless/intel/iwlwifi/iwl-drv.c:299).
294     static void set_sec_data(struct iwl_firmware_pieces *pieces,
295                              enum iwl_ucode_type type,
296                              int sec,
297                              const void *data)
298     {
299             pieces->img[type].sec[sec].data = data;
300     }
301
302     static void set_sec_size(struct iwl_firmware_pieces *pieces,
303                              enum iwl_ucode_type type,
(gdb) 

-- 
Kalle Valo
