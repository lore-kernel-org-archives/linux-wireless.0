Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host250-57-static.36-88-b.business.telecomitalia.it ([88.36.57.250]:57622
	"EHLO MONSTER.residential.fw" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030427AbXDJHCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 03:02:15 -0400
Received: from MONSTER.residential.fw (localhost [127.0.0.1])
	by MONSTER.residential.fw (8.13.8/8.13.8) with ESMTP id l3A6cdVn003475
	for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2007 08:38:39 +0200
Received: (from root@localhost)
	by MONSTER.residential.fw (8.13.8/8.13.8/Submit) id l3A6ccqC003474
	for linux-wireless@vger.kernel.org; Tue, 10 Apr 2007 08:38:38 +0200
Subject: intel 3945 testing the drivers on slack
From: Gallo Renato <renatogallo@katamail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 10 Apr 2007 08:38:38 +0200
Message-Id: <1176187118.2201.8.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

got this expencive new acer and trying to manage it with slackware. My
first try with the kernel 2.6.20.4 was with the ipw3945.ko driver and
its daemon 

(ipw3945# ls
ipw3945-1.2.0/  ipw3945-1.2.0.tgz  ipw3945-ucode-1.14.2.tgz
ipw3945d-1.7.22/  ipw3945d-1.7.22.tgz
)


but since sometimes it gives me this trouble:

ipw3945: Microcode SW error detected.  Restarting.
ipw3945: request scan called when driver not ready.
ipw3945: Error sending ADD_STA: time out after 500ms.
general protection fault: e290 [#1]
SMP
Modules linked in: snd_rtctimer cisco_ipsec(P) snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
video1394 raw1394 dv1394
eth1394 irtty_sir sir_dev irlan ircomm_tty ircomm mmc_block hci_uart
ipw3945 ieee80211 ieee80211_crypt sco rfcomm hidp bnep l2cap
lirc_mceusb2 lirc_dev nvidia(P) gspca
pcmcia snd_hda_intel snd_hda_codec videodev ohci1394 snd_pcm sdhci
v4l2_common ieee1394 v4l1_compat mmc_core yenta_socket snd_timer sky2
hci_usb 8250_pnp
rsrc_nonstatic snd irda bluetooth pcmcia_core 8250 serial_core
snd_page_alloc crc_ccitt
CPU:    0
EIP:    0060:[<f90a375e>]    Tainted: P      VLI
EFLAGS: 00010286   (2.6.20.4 #7)
EIP is at ipw_disassociate+0x6e/0xb0 [ipw3945]
eax: 00000018   ebx: f5b74ac4   ecx: 00000018   edx: 00000246
esi: f5b74ac4   edi: f580c840   ebp: 00000246   esp: f6219f2c
ds: 007b   es: 007b   ss: 0068
Process ipw3945/0 (pid: 1375, ti=f6218000 task=c2161a70
task.ti=f6218000)
Stack: f5b74c10 f90a37d8 f5b760ec f5b760e8 c0137c7c 00000000 c200c380
c2161b7c
       00000073 f580c860 f580c84c f90a37a0 f580c840 f580c854 f580c84c
f6219f98
       c0137ea7 ffffffff ffffffff 00000001 00000000 c01215c0 00010000
00000000
Call Trace:
 [<f90a37d8>] ipw_bg_disassociate+0x38/0x50 [ipw3945]
 [<c0137c7c>] run_workqueue+0x7c/0x150
 [<f90a37a0>] ipw_bg_disassociate+0x0/0x50 [ipw3945]
 [<c0137ea7>] worker_thread+0x157/0x180
 [<c01215c0>] default_wake_function+0x0/0x10
 [<c01215c0>] default_wake_function+0x0/0x10
 [<c0137d50>] worker_thread+0x0/0x180
 [<c013b774>] kthread+0xa4/0xe0
 [<c013b6d0>] kthread+0x0/0xe0
 [<c0103d87>] kernel_thread_helper+0x7/0x10
 =======================
Code: 8b 88 a0 06 00 00 85 c9 75 29 83 b8 f8 05 00 00 02 74 43 8d 83 cc
03 00 00 e8 2f ca 08 c7 89 d8 31 c9 ba f0 45 0c f9 e8 91 81 ff <ff> 5b
b8 01 00 00 00 c3 8b 80
a4 06 00 00 e8 5f 75 0d c7 8b 03
EIP: [<f90a375e>] ipw_disassociate+0x6e/0xb0 [ipw3945] SS:ESP
0068:f6219f2c
 azx_pcm_prepare: bufsize=0x10000, fragsize=0x1000, format=0x11

on the dmesg and disconnects losing the wireless extentions I decided to
try the new kernel 2.6.20.6 with the drivers
iwlwifi-0.0.11/  iwlwifi-0.0.11.tgz  iwlwifi-ucode-2.14.1/
iwlwifi-ucode-2.14.1.tgz  mac80211-6.0.0/  mac80211-6.0.0.tgz


but got troubles compiling since after the patching phase it gives me 

CC      drivers/net/wireless/mac80211/iwlwifi/base.o
drivers/net/wireless/mac80211/iwlwifi/base.c: In function
`ipw_rate_scale_rate_init':
drivers/net/wireless/mac80211/iwlwifi/base.c:11695: error: structure has
no member named `num_curr_rates'
drivers/net/wireless/mac80211/iwlwifi/base.c:11697: error: structure has
no member named `curr_rates'
drivers/net/wireless/mac80211/iwlwifi/base.c: In function
`ipw_get_lowest_rate':
drivers/net/wireless/mac80211/iwlwifi/base.c:11862: error: structure has
no member named `num_curr_rates'
drivers/net/wireless/mac80211/iwlwifi/base.c:11863: error: structure has
no member named `curr_rates'
drivers/net/wireless/mac80211/iwlwifi/base.c:11869: error: structure has
no member named `curr_rates'
make[5]: *** [drivers/net/wireless/mac80211/iwlwifi/base.o] Error 1
make[4]: *** [drivers/net/wireless/mac80211/iwlwifi] Error 2
make[3]: *** [drivers/net/wireless/mac80211] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

during the compile phase....


since I think I am missing something I would really appreciate if you
could find the time to guide my ideas on the right path (it is the first
time I face this kind of new hw). 


thanks in advance for the advices....


Gallo Renato
 
