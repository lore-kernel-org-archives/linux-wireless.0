Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:39157 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbYFGN2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2008 09:28:24 -0400
Message-ID: <484A8CF5.3060801@mandriva.org> (sfid-20080607_152829_263312_70E1ECBD)
Date: Sat, 07 Jun 2008 16:28:21 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Thomas Backlund <tmb@mandriva.org>,
	Ian Schram <ischram@telenet.be>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
References: <4848289D.1080205@mandriva.org> <48485F12.2050908@mandriva.org>	 <48488878.5040708@telenet.be>	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org>	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>	 <48494EF6.4020506@mandriva.org>	 <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com>	 <4849AF9F.9010207@mandriva.org> <1ba2fa240806061659j7672f9d3w107be4509b533f68@mail.gmail.com>
In-Reply-To: <1ba2fa240806061659j7672f9d3w107be4509b533f68@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler skrev:
> On Sat, Jun 7, 2008 at 12:43 AM, Thomas Backlund <tmb@mandriva.org> wrote:
>> Tomas Winkler skrev:
>>> On Fri, Jun 6, 2008 at 5:51 PM, Thomas Backlund <tmb@mandriva.org> wrote:
>>>> Tomas Winkler skrev:
>>>>> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.org>
>>>>> wrote:
>>>>>> Thomas Backlund skrev:
>>>>>>> Tomas Winkler skrev:
>>>>>>>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be>
>>>>>>>> wrote:
>>>>>>>>> Isn't this the Oops Joonwoo Park wanted to patch with
>>>>>>>>>
>>>>>>>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
>>>>>>>>>
>>>>>>>>> invalid length of webkey that would/should be handled in mac80211?
>>>>>>>>>
>>>>>>>>> ian
>>>>>>>> Yes, it looks like.
>>>>>>> Ummm, what has a wep key to do with me trying to access a
>>>>>>> WPA2-Personal
>>>>>>> encrypted net ?
>>>>> Not sure yet, but mac is trying to assign default/static wep key.
>>>>>
>>>>> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5
>>>>> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc
>>>>>
>>>>> Try to set the encryption explicitly
>>>>> network={
>>>>>   psk="*************************"
>>>>>   scan_ssid=1
>>>>>   ssid="dlink"
>>>>>   pairwise=CCMP
>>>>>  group=CCMP
>>>>>  }
>>>>>
>>>>>
>>>> That didn't help at all.
>>>>
>>>> What's more it prevented the wifi to work on 2.6.24.7 so I had to remove
>>>> the
>>>> lines again...
>>>>
>>> So what's your AP configuration TKIP?
>>>
>> I've switched to clean WPA2-AES on the AP, but it does not do any
>> difference... I still get the oops...
>>
> 
> I would like to see the log of this one
> 
>>> Second try also with sw decryption:
>>>
>>> in /etc/modprobe.conf
>>> options iwl4965 swcrypto=1
>>>
>>
>> That works.
>> I now run a clean 2.6.26-rc5
>>
> Okay thanks for checking this one.
> 
>> I also tried to bisect between 2.6.25 and 2.6.26-rc1 and ended up with:
>>
>> [root@5720g linux-2.6]# git bisect good
>> 8318d78a44d49ac1edf2bdec7299de3617c4232e is first bad commit
>> commit 8318d78a44d49ac1edf2bdec7299de3617c4232e
>> Author: Johannes Berg <johannes@sipsolutions.net>
>> Date:   Thu Jan 24 19:38:38 2008 +0100
>>
>>    cfg80211 API for channels/bitrates, mac80211 and driver conversion
>>
>>
>>
>> Any more I can provide to help finding the bug ?
> 
> Just the log from AES try with  I will try to reproduce this as soon
> as I get to this particular AP and 64 bits kernel.
> 

with wpa_supplicant.conf:
network={
    psk="*************************"
    scan_ssid=1
    ssid="dlink"
    pairwise=CCMP
    group=CCMP
}

I also rebuilt the 2.6.26-rc5 with enabled mac* and iwl* debug options, 
so the configs are:

[thomas@5720g 1]$ grep MAC8 config-2.6.26-0.rc5.1mdvsmp
CONFIG_MAC80211=m
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
CONFIG_MAC80211_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_LOWTX_FRAME_DUMP is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y

[thomas@5720g 1]$ grep IWL config-2.6.26-0.rc5.1mdvsmp
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
CONFIG_IWL4965=m
CONFIG_IWL4965_HT=y
CONFIG_IWL4965_LEDS=y
CONFIG_IWL4965_SPECTRUM_MEASUREMENT=y
CONFIG_IWL4965_SENSITIVITY=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWL3945=m
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
CONFIG_IWL3945_DEBUG=y


Here is the log:

Jun  7 16:05:30 5720g kernel: firmware: requesting iwlwifi-4965-1.ucode
Jun  7 16:05:30 5720g kernel: Registered led device: iwl-phy0:radio
Jun  7 16:05:30 5720g kernel: Registered led device: iwl-phy0:assoc
Jun  7 16:05:30 5720g kernel: Registered led device: iwl-phy0:RX
Jun  7 16:05:30 5720g kernel: Registered led device: iwl-phy0:TX
Jun  7 16:05:31 5720g kernel: phy0: HW CONFIG: freq=2412
Jun  7 16:05:31 5720g kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jun  7 16:05:31 5720g kernel: phy0: HW CONFIG: freq=2412
Jun  7 16:05:31 5720g kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000000000000000
Jun  7 16:05:31 5720g kernel: IP: [<ffffffffa026e036>] 
:iwl4965:iwl4965_enqueue_hcmd+0x175/0x2c2
Jun  7 16:05:31 5720g kernel: PGD 0
Jun  7 16:05:31 5720g kernel: Oops: 0000 [1] SMP
Jun  7 16:05:31 5720g kernel: CPU 1
Jun  7 16:05:31 5720g kernel: Modules linked in: af_packet kvm_intel kvm 
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss ipv6 xt_tcpudp iptable_filter ip_tables 
x_tables binfmt_misc loop dm_mod cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table tifm_sd tifm_7xx1 tifm_core 
nvram pcmcia ohci1394 ieee1394 mmc_block battery ac arc4 ecb 
crypto_blkcipher firewire_ohci firewire_core video container 
yenta_socket rsrc_nonstatic crc_itu_t sdhci output snd_hda_intel 
pcmcia_core snd_pcsp iwl4965 mmc_core snd_pcm firmware_class nsc_ircc 
thermal button joydev rtc_cmos snd_timer iwlcore irda snd i2c_i801 
rtc_core iTCO_wdt rfkill crc_ccitt evdev soundcore rtc_lib serio_raw 
acer_wmi processor mac80211 wmi sr_mod iTCO_vendor_support 
snd_page_alloc i2c_core intel_agp cdrom led_class sg cfg80211 tg3 
ide_generic piix ide_core ata_piix ahci libata dock sd_mod scsi_mod ext3 
jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: nf_conntrack]
Jun  7 16:05:31 5720g kernel: Pid: 10, comm: events/1 Not tainted 
2.6.26-0.rc5.1mdvsmp #1
Jun  7 16:05:31 5720g kernel: RIP: 0010:[<ffffffffa026e036>] 
[<ffffffffa026e036>] :iwl4965:iwl4965_enqueue_hcmd+0x175/0x2c2
Jun  7 16:05:31 5720g kernel: RSP: 0018:ffff81013fb15b60  EFLAGS: 00010086
Jun  7 16:05:31 5720g kernel: RAX: 0000000000000000 RBX: 
ffff8100bf84c300 RCX: 0000000000000064
Jun  7 16:05:31 5720g kernel: RDX: 0000000000000022 RSI: 
0000000000000000 RDI: ffff8100bf84c318
Jun  7 16:05:31 5720g kernel: RBP: ffff81013fb15bd0 R08: 
ffff8100bf941100 R09: 0000000000000300
Jun  7 16:05:31 5720g kernel: R10: ffff81013fb15a10 R11: 
ffff81013fb10a78 R12: ffff81013fb15cf0
Jun  7 16:05:31 5720g kernel: R13: 00000000a0290068 R14: 
ffff81013e1021c0 R15: ffff8101364a1a20
Jun  7 16:05:31 5720g kernel: FS:  0000000000000000(0000) 
GS:ffff81013fab8ac0(0000) knlGS:0000000000000000
Jun  7 16:05:31 5720g kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
000000008005003b
Jun  7 16:05:31 5720g kernel: CR2: 0000000000000000 CR3: 
0000000000201000 CR4: 00000000000026e0
Jun  7 16:05:31 5720g kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Jun  7 16:05:31 5720g kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Jun  7 16:05:31 5720g kernel: Process events/1 (pid: 10, threadinfo 
ffff81013fb14000, task ffff81013fb102c0)
Jun  7 16:05:31 5720g kernel: Stack:  ffff81013fb14000 ffffffff806f7ed8 
0000000000000001 ffffffff806f8660
Jun  7 16:05:31 5720g kernel:  ffffffff806f8648 ffffffff8075bb50 
ffff81013e102c08 000000023fb10a10
Jun  7 16:05:31 5720g kernel:  0000000000000006 ffff8101364a1a00 
ffff81013fb15cf0 ffff81013e1021c0
Jun  7 16:05:31 5720g kernel: Call Trace:
Jun  7 16:05:31 5720g kernel:  [<ffffffffa021357e>] 
:iwlcore:iwl_send_cmd_sync+0x94/0x313
Jun  7 16:05:31 5720g kernel:  [<ffffffff80257ed5>] ? 
__lock_acquire+0xbee/0xd5a
Jun  7 16:05:31 5720g kernel:  [<ffffffffa021384e>] 
:iwlcore:iwl_send_cmd+0x16/0x18
Jun  7 16:05:31 5720g kernel:  [<ffffffffa0284784>] 
:iwl4965:iwl_send_static_wepkey_cmd+0xcb/0xd5
Jun  7 16:05:31 5720g kernel:  [<ffffffffa0284832>] 
:iwl4965:iwl_set_default_wep_key+0xa4/0xbe
Jun  7 16:05:31 5720g kernel:  [<ffffffffa026d14b>] 
:iwl4965:iwl4965_mac_set_key+0x1c9/0x2d3
Jun  7 16:05:31 5720g kernel:  [<ffffffff803049ed>] ? 
debugfs_remove+0xd5/0xda
Jun  7 16:05:31 5720g kernel:  [<ffffffffa017e3ca>] 
:mac80211:__ieee80211_key_todo+0x124/0x226
Jun  7 16:05:31 5720g kernel:  [<ffffffffa017e57a>] 
:mac80211:ieee80211_key_todo+0x17/0x25
Jun  7 16:05:31 5720g kernel:  [<ffffffffa017e591>] 
:mac80211:key_todo+0x9/0xb
Jun  7 16:05:31 5720g kernel:  [<ffffffff80247104>] run_workqueue+0xfc/0x203
Jun  7 16:05:31 5720g kernel:  [<ffffffffa017e588>] ? 
:mac80211:key_todo+0x0/0xb
Jun  7 16:05:31 5720g kernel:  [<ffffffff802472eb>] worker_thread+0xe0/0xf1
Jun  7 16:05:31 5720g kernel:  [<ffffffff8024acac>] ? 
autoremove_wake_function+0x0/0x38
Jun  7 16:05:31 5720g kernel:  [<ffffffff8024720b>] ? worker_thread+0x0/0xf1
Jun  7 16:05:31 5720g kernel:  [<ffffffff8024a97b>] kthread+0x49/0x76
Jun  7 16:05:31 5720g kernel:  [<ffffffff8020d248>] child_rip+0xa/0x12
Jun  7 16:05:31 5720g kernel:  [<ffffffff8020c7dc>] ? restore_args+0x0/0x30
Jun  7 16:05:31 5720g kernel:  [<ffffffff8024a932>] ? kthread+0x0/0x76
Jun  7 16:05:31 5720g kernel:  [<ffffffff8020d23e>] ? child_rip+0x0/0x12
Jun  7 16:05:31 5720g kernel:
Jun  7 16:05:31 5720g kernel:
Jun  7 16:05:31 5720g kernel: Code: 69 c8 80 01 00 00 41 8a 04 24 4c 89 
cb 49 03 9e c0 44 00 00 88 43 14 48 89 df f3 a5 48 8d 7b 18 41 0f b7 4c 
24 02 49 8b 74 24 18 <f3> a4 c6 43 15 00 41 0f b6 96 94 44 00 00 89 d0 
80 cc 04 f6 43
Jun  7 16:05:31 5720g kernel: RIP  [<ffffffffa026e036>] 
:iwl4965:iwl4965_enqueue_hcmd+0x175/0x2c2
Jun  7 16:05:31 5720g kernel:  RSP <ffff81013fb15b60>
Jun  7 16:05:31 5720g kernel: CR2: 0000000000000000
Jun  7 16:05:31 5720g kernel: ---[ end trace 61cbfb837f7cd04e ]---




> One more thing is suspicious in the WEP key try is that I don't see
> this can ever happen. The command that should be here iis
> wlcore:iwl_send_cmd_async
> Jun  5 19:55:06 5720g kernel:  [<ffffffffa018ee37>]
> :iwlcore:iwl_send_cmd_sync+0x94/0x257
> Jun  5 19:55:06 5720g kernel:  [<ffffffff80257ed5>] ? __lock_acquire+0xbee/0xd5a
> Jun  5 19:55:06 5720g kernel:  [<ffffffffa018f04b>]
> :iwlcore:iwl_send_cmd+0x16/0x1b
> Jun  5 19:55:06 5720g kernel:  [<ffffffffa0218c41>]
> :iwl4965:iwl_send_static_wepkey_cmd+0xcb/0xd5
> Jun  5 19:55:06 5720g kernel:  [<ffffffffa0218cef>]
> :iwl4965:iwl_set_default_wep_key+0xa4/0xbe
> Jun  5 19:55:06 5720g kernel:  [<ffffffffa020ae00>]
> :iwl4965:iwl4965_mac_set_key+0xf1/0x137
> 
> The code there looks like this
> 
> int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
> {
>         int i, not_empty = 0;
>         u8 buff[sizeof(struct iwl_wep_cmd) +
>                 sizeof(struct iwl_wep_key) * WEP_KEYS_MAX];
>         struct iwl_wep_cmd *wep_cmd = (struct iwl_wep_cmd *)buff;
>         size_t cmd_size  = sizeof(struct iwl_wep_cmd);
>         struct iwl_host_cmd cmd = {
>                 .id = REPLY_WEPKEY,
>                 .data = wep_cmd,
>                 .meta.flags = CMD_ASYNC, -----------------------------------------
> this is async
>         };
> 
> Thanks
> Tomas
> .
> 

