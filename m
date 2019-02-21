Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEF0C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E7B2083B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfBUQfT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:35:19 -0500
Received: from mail.3eti.com ([65.220.88.139]:36051 "EHLO mail.ultra-3eti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbfBUQfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:35:19 -0500
X-ASG-Debug-ID: 1550766816-0542999e1818f20001-9xRsGE
Received: from webmail.3eti.com ([192.168.200.4]) by mail.ultra-3eti.com with ESMTP id TB0eTjl8aT5jIdqi (version=TLSv1.2 cipher=AES128-SHA256 bits=128 verify=NO); Thu, 21 Feb 2019 11:33:36 -0500 (EST)
X-Barracuda-Envelope-From: Chaoxing.Lin@ultra-3eti.com
Received: from EXCHMBX01.rock.corp ([192.168.200.89]) by RockMX01.rock.corp
 ([fe80::5def:57af:7b19:da5a%14]) with mapi id 14.03.0415.000; Thu, 21 Feb
 2019 11:33:36 -0500
From:   Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG] ath10k firmware crash 100% recreated this way
Thread-Topic: [BUG] ath10k firmware crash 100% recreated this way
X-ASG-Orig-Subj: RE: [BUG] ath10k firmware crash 100% recreated this way
Thread-Index: AdTFRGwzfscbcG0bTrO5HfPvqSOd2QEvheZQ
Date:   Thu, 21 Feb 2019 16:33:35 +0000
Message-ID: <E0249DC1E88AC941A5535F80928B4ADF12464056@EXCHMBX01.rock.corp>
References: <E0249DC1E88AC941A5535F80928B4ADF1246381D@EXCHMBX01.rock.corp>
In-Reply-To: <E0249DC1E88AC941A5535F80928B4ADF1246381D@EXCHMBX01.rock.corp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[192.168.200.4]
X-Barracuda-Start-Time: 1550766816
X-Barracuda-Encrypted: AES128-SHA256
X-Barracuda-URL: https://192.168.200.200:443/cgi-mod/mark.cgi
X-Barracuda-Scan-Msg-Size: 11686
X-Virus-Scanned: by bsmtpd at ultra-3eti.com
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 1.54
X-Barracuda-Spam-Status: No, SCORE=1.54 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_RULE7568M, FS_LARGE_PERCENT2
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.67677
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        1.04 FS_LARGE_PERCENT2      Larger than 100% in subj.
        0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello ath10k firmware maintainers,

What I describe is just a definite way to crash ath10k firmware.
It does NOT mean that the firmware crash only happens in such scenario.
I saw firmware crash once a while.

Is there a plan to fix the firmware crash issue? If not, is it possible to get ath10k firmware source code? We can sign any NDA if needed. We will contribute back if we have a fix for this firmware crash.

Thanks,

Chaoxing

-----Original Message-----
From: Chaoxing Lin 
Sent: Friday, February 15, 2019 10:46 AM
To: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org
Subject: [BUG] ath10k firmware crash 100% recreated this way

Hello ath10k firmware maintainers,

I saw ath10k firmware crash very often (~170 times in 20hours) on our wireless AP/bridge environment below:
 	arm64 board	 
	kernel 4.14.16 
	hostapd-2.6 run in 4-address mode
	Qualcomm Atheros QCA986x/988x 802.11ac Wireless Network Adapter
	ath10k_core.ko in software crypto mode
	running RSTP (Rapid Spanning Tree Protocol)

I also consistently recreated this firmware crash on Linux PC acting as AP as follows. Please take a look.

"must" conditions:

1. ath10k_core.ko MUST be in software crypto mode 
   ("modprobe ath10k_core cryptmode=1")

2. MUST run our proprietary RSTP bridge module 3ebridge.ko 
   (I can provide binary complied for kernel 4.14.16 on X86_64 PC)

3. STP must be on. 
   ("brctl stp brg0 on", by default 3ebridge.ko would turn STP on. Just a note 
    that if STP is turned off, you won't see firmware crash)

4. hostapd-2.6 MUST be configured in 4-address mode 
   (put "wds_sta=1" in hostapd.conf) 

5. Linux PC wireless client must be in 4-address mode. 
   (run "iw wlan0 set 4addr on" before starting wpa_supplicant)
   To 100% recreate this firmware crash RIGHT AWAY, use the following WiFi 
   client.

	root@Dell-D620:~# lspci
		0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
        [Golan] Network Connection (rev 02)
	You can find such radio card in very old (~15 years old) laptop.
         I can send you this radio card if you cannot find it.

ath10k firmware crashes right away when this 4-address client associates with the PC acting as AP.

FYI: What's known special about this wireless client? 
     Our experiments show this client does not really work in 4 address mode. 
     It successfully associates with AP but no traffic is possible in 
	 4-address mode.
     Packets sniffed in the air show that this client (when in 4 address mode) 
     does NOT send ACK packets to AP on receiving from AP packet whose RA is 
     client MAC and DA is multicast MAC (e.g. BPDU)
     NOTE: Don't be distracted by what I saw about this wireless client. 
           It may not be related to the firmware crash. 


The following are DONT-CARE in re-creating the firmware crash.

1. WiFi encryption: 
   The firmare crash happens even in bypass/no-encryption mode, although 
   ath10k_core.ko MUST be put in software crypto mode to see the crash.

2. ath10k firmware version: 
   As long as it supports software crypto mode (i.e. support raw mode), 
   the above procedure can crash it. I tried various firmware versions from 
   the initial version that supports raw mode to the latest 
   firmware-5.bin_10.2.4.70.69 dated 18-Dec-2018. They all crashed.

3. Linux wireless client distribution/OS is a don't care.
   As long as the WiFi adapter is "Intel Corporation PRO/Wireless 3945AB"  
   Tried distributions below. They both make firmare crash right away on 
   PC AP side
		Slackware 14.2 (kernel 4.4.14-smp)
		Ubuntu 18.04.01 live (kernel 4.15.0-29-generic)

4. Radio channel setting is a don't care.
   Tried with/without 11n/11ac/ and different channel width. 
   They all crash firmware.


I can provide all configurations/binary as below.
	hostapd.conf  [see later in this message]
	wpa_supplicant.conf  [see later in this message]
	3ebridge.ko (RSTP bridge binary compiled for 
				 mainline kernel 4.14.16 X86_64. 
                 Please "modprobe -r bridge" before "insmod 3ebridge.ko")


Below is the syslog/messages related to the ath10k firmware crash.
For easier reading, Timestamps are removed. line edited just to wrap around at 80char 


/var/log/messages 
---------------------------------------------------------------------------
ath10k_pci 0000:03:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
ath10k_pci 0000:03:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff 
                         sub 0000:0000
ath10k_pci 0000:03:00.0: kconfig debug 0 debugfs 1 tracing 0 dfs 0 testmode 0
ath10k_pci 0000:03:00.0: firmware ver 10.2.4.70.69 api 5 features no-p2p,
                         raw-mode,mfp,allows-mesh-bcast crc32 edfb196a
ath10k_pci 0000:03:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
ath10k_pci 0000:03:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 
                         raw 1 hwcrypto 0
ath10k_pci 0000:03:00.0 wlan50: renamed from wlan0
ath10k_pci 0000:03:00.0 wlan4: renamed from wlan50
IPv6: ADDRCONF(NETDEV_UP): phy0ap: link is not ready
device phy0ap entered promiscuous mode
IPv6: ADDRCONF(NETDEV_CHANGE): phy0ap: link becomes ready
device phy0ap.sta1 entered promiscuous mode
ath10k_pci 0000:03:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff 
                         sub 0000:0000
ath10k_pci 0000:03:00.0: kconfig debug 0 debugfs 1 tracing 0 dfs 0 testmode 0
ath10k_pci 0000:03:00.0: firmware ver 10.2.4.70.69 api 5 features no-p2p,
                         raw-mode,mfp,allows-mesh-bcast crc32 edfb196a
ath10k_pci 0000:03:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
ath10k_pci 0000:03:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 
                         raw 1 hwcrypto 0
ieee80211 phy0: Hardware restart was requested
ath10k_pci 0000:03:00.0: device successfully recovered


/var/log/syslog
----------------------------------------------------------------------------
ath10k_pci 0000:03:00.0: firmware crashed! 
                         (guid 64627eb3-5b90-491a-8181-6972fc50d317)
ath10k_pci 0000:03:00.0: firmware register dump:
ath10k_pci 0000:03:00.0: [00]: 0x4100016C 0x000015B3 0x0099901F 0x00955B31
ath10k_pci 0000:03:00.0: [04]: 0x0099901F 0x00060130 0x00000020 0x000FFFFF
ath10k_pci 0000:03:00.0: [08]: 0x00427D80 0x00000003 0x00000000 0x00401C3C
ath10k_pci 0000:03:00.0: [12]: 0x00000009 0xFFFFFFFF 0x00958360 0x0095836B
ath10k_pci 0000:03:00.0: [16]: 0x00958080 0x0094085D 0x00000000 0x00000000
ath10k_pci 0000:03:00.0: [20]: 0x4099901F 0x0040AA94 0x00000001 0x00100000
ath10k_pci 0000:03:00.0: [24]: 0x80996254 0x0040AAF4 0x00409418 0xC099901F
ath10k_pci 0000:03:00.0: [28]: 0x8099A4BD 0x0040AB44 0x00427D80 0x00439BC0
ath10k_pci 0000:03:00.0: [32]: 0x8099A62C 0x0040ACE4 0x00000000 0x0042E648
ath10k_pci 0000:03:00.0: [36]: 0x8099A5BC 0x0040AD14 0x00000002 0x0042E648
ath10k_pci 0000:03:00.0: [40]: 0x8099A7AC 0x0040AD44 0x00439BC0 0x0042E648
ath10k_pci 0000:03:00.0: [44]: 0x8099885F 0x0040AD64 0x00439BC0 0x00000002
ath10k_pci 0000:03:00.0: [48]: 0x8099AF6D 0x0040AD84 0x0042066C 0x0042621C
ath10k_pci 0000:03:00.0: [52]: 0x809BF051 0x0040AEE4 0x00424D5C 0x00000002
ath10k_pci 0000:03:00.0: [56]: 0x80940F18 0x0040AF14 0x00000005 0x004039E4
ath10k_pci 0000:03:00.0: Copy Engine register dump:
ath10k_pci 0000:03:00.0: [00]: 0x00057400   1   1   3   3
ath10k_pci 0000:03:00.0: [01]: 0x00057800  14  14 241 242
ath10k_pci 0000:03:00.0: [02]: 0x00057c00  56  56  55  56
ath10k_pci 0000:03:00.0: [03]: 0x00058000  12  12  14  12
ath10k_pci 0000:03:00.0: [04]: 0x00058400  24  24  62  22
ath10k_pci 0000:03:00.0: [05]: 0x00058800   7   7 326 327
ath10k_pci 0000:03:00.0: [06]: 0x00058c00  19  19  19  19
ath10k_pci 0000:03:00.0: [07]: 0x00059000   0   0   0   0

phy0ap.sta1:  Failed check-sdata-in-driver check, flags: 0x0
------------[ cut here ]------------
WARNING: CPU: 1 PID: 30409 at net/mac80211/driver-ops.h:18 
         ieee80211_assign_chanctx.part.16+0x15e/0x170 [mac80211]
Modules linked in: ath10k_pci ath10k_core ath mac80211 cfg80211 3ebridge(O) 
nfnetlink_queue nfnetlink_log nfnetlink bluetooth ecdh_generic rfkill ipv6 
fuse hid_generic usbhid hid i2c_dev dell_wmi dell_smbios sparse_keymap 
gpio_ich wmi_bmof ppdev evdev dcdbas snd_hda_codec_analog snd_hda_codec_generic
coretemp snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm kvm_intel 
kvm snd_timer hwmon psmouse irqbypass serio_raw snd i915 i2c_i801 uhci_hcd 
video drm_kms_helper drm lpc_ich i2c_algo_bit fb_sys_fops syscopyarea 
sysfillrect sysimgblt i2c_core ehci_pci e100 mii tpm_tis tpm_tis_core tpm wmi 
soundcore parport_pc parport ehci_hcd intel_agp intel_gtt button agpgart 
shpchp e1000e acpi_cpufreq loop [last unloaded: cfg80211]
CPU: 1 PID: 30409 Comm: kworker/1:2 Tainted: G        W  O    4.14.16 #2
Hardware name: Dell Inc. OptiPlex 780  /0C27VV, BIOS A05 08/11/2010
Workqueue: events_freezable ieee80211_restart_work [mac80211]
task: ffff8ed6d13b0c80 task.stack: ffffaec64372c000
RIP: 0010:ieee80211_assign_chanctx.part.16+0x15e/0x170 [mac80211]
RSP: 0018:ffffaec64372fdb0 EFLAGS: 00010282
RAX: 000000000000003c RBX: ffff8ed682380780 RCX: 0000000000000000
RDX: ffff8ed6fd85d130 RSI: ffff8ed6fd855518 RDI: ffff8ed6fd855518
RBP: ffff8ed682380780 R08: 0000000000000001 R09: 0000000000000779
R10: ffff8ed682381560 R11: 0000000000000779 R12: ffff8ed6f5b0e8c0
R13: ffff8ed682381198 R14: ffff8ed6f5b92f58 R15: ffff8ed6f5b0e8c0
FS:  0000000000000000(0000) GS:ffff8ed6fd840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe13bcba00a CR3: 000000005d140000 CR4: 00000000000406e0
Call Trace:
 ieee80211_reconfig+0xc7f/0x1300 [mac80211]
 ? try_to_del_timer_sync+0x3d/0x50
 ieee80211_restart_work+0x99/0xc0 [mac80211]
 process_one_work+0x139/0x400
 worker_thread+0x47/0x430
 kthread+0xfc/0x130
 ? process_one_work+0x400/0x400
 ? kthread_create_on_node+0x40/0x40
 ret_from_fork+0x35/0x40
Code: 45 31 e4 e9 46 ff ff ff 49 8b 84 24 00 04 00 00 49 8d b4 24 20 04 00 00 48 c7 c7 70 71 77 c0 48 85 c0 48 0f 45 f0 e8 0d 19 9b df <0f> ff e9 26 ff ff ff 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 
---[ end trace d5e6e93890bc3ea5 ]---



hostapd.conf
---------------------------------------------------------------------------
interface=phy0ap
bridge=brg0
driver=nl80211
logger_syslog=-1
logger_syslog_level=4
logger_stdout=-1
logger_stdout_level=4
country_code=US
ieee80211d=1
hw_mode=a

wds_sta=1

channel=36
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
beacon_int=200

ap_table_max_size=63
ap_table_expiration_time=300
local_pwr_constraint=3
ieee80211h=1

bssid=04:f0:21:3b:2f:78
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=4-addr-ap
dtim_period=2
max_num_sta=64
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wmm_enabled=1
ap_max_inactivity=300

ieee80211w=0
ieee8021x=0
#---------end of hostapd.conf---------------------------------------------




wpa_supplicant.conf
#------------------------------------------------------------------------
ctrl_interface=/var/run/wpa_supplicant

network={
	ssid="4-addr-ap"
	scan_ssid=1
	key_mgmt=NONE
}
#---------end of wpa_supplicant.conf------------------------------------


BTW: The Linux distribution should not matter. I use Slackware Linux on the PC 
	acting as AP because Slackware Linux use exact mainline kernel source 
	without any patching. Kernel source from kernel.org can be just compiled
    and dropped in.
I can also send you the radio card "Intel
