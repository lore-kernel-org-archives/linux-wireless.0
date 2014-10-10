Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:49308 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaJJSTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 14:19:32 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: iwlwifi/mvm: "Got an HT rate for a non data frame 0x8"
Date: Fri, 10 Oct 2014 20:19:21 +0200
Message-ID: <8738avyehi.fsf@nemi.mork.no> (sfid-20141010_201936_170876_967488DF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just hit this warning using the 3.17.0-rc7 version of the driver:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 12436 at drivers/net/wireless/iwlwifi/mvm/tx.c:190 iwl_mvm_set_tx_params+0x336/0x463 [iwlmvm]()
Got an HT rate for a non data frame 0x8
Modules linked in: ext3 jbd tcp_diag inet_diag qmi_wwan option usb_wwan uas usb_storage xt_state ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge cpuid ctr ccm nfnetlink_log nfnetlink usb_serial_simple usbserial xt_multiport iptable_filter ip_tables bnep dm_mod xt_hl nf_log_ipv6 nf_log_common xt_LOG binfmt_misc ip6table_filter ip6_tables x_tables nfsd nfs_acl nfs lockd fscache sunrpc 8021q garp stp mrp llc tun loop fuse snd_hda_codec_conexant snd_hda_codec_generic iTCO_wdt iTCO_vendor_support arc4 coretemp cdc_mbim kvm_intel cdc_wdm kvm cdc_ncm evdev usbnet mii uvcvideo cdc_acm psmouse videobuf2_vmalloc videobuf2_memops videobuf2_core serio_raw v4l2_common videodev i2c_i801 iwlmvm mac80211 snd_hda_intel snd_hda_controller snd_hda_codec
 snd_hwdep snd_pcm_oss snd_mixer_oss iwlwifi lpc_ich mfd_core i915 snd_pcm i2c_algo_bit drm_kms_helper cfg80211 snd_timer drm wmi thinkpad_acpi nvram ac snd soundcore battery ecb btusb bluetooth video rfkill button acpi_cpufreq processor ext4 crc16 jbd2 mbcache nbd sg sd_mod crc_t10dif sr_mod crct10dif_generic cdrom crct10dif_common microcode ahci libahci libata scsi_mod ehci_pci uhci_hcd ehci_hcd e1000e ptp pps_core usbcore usb_common thermal thermal_sys [last unloaded: dummy]
CPU: 0 PID: 12436 Comm: wpa_supplicant Tainted: G           O   3.17.0-rc7+ #262
Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
 0000000000000009 ffff8802321bb748 ffffffff813bea47 0000000000000000
 ffff8802321bb798 ffff8802321bb788 ffffffff8103eb60 0000000000000020
 ffffffffa0640047 ffff8800b1d9bdc0 ffff88022f666c00 ffff88007f9f2a48
Call Trace:
 [<ffffffff813bea47>] dump_stack+0x4e/0x68
 [<ffffffff8103eb60>] warn_slowpath_common+0x7c/0x96
 [<ffffffffa0640047>] ? iwl_mvm_set_tx_params+0x336/0x463 [iwlmvm]
 [<ffffffff8103ec0e>] warn_slowpath_fmt+0x41/0x43
 [<ffffffffa0640047>] iwl_mvm_set_tx_params+0x336/0x463 [iwlmvm]
 [<ffffffffa0640663>] iwl_mvm_tx_skb+0x29f/0x30a [iwlmvm]
 [<ffffffffa06391a7>] iwl_mvm_mac_tx+0xbc/0x1ae [iwlmvm]
 [<ffffffffa059ff36>] __ieee80211_tx+0x28a/0x2f7 [mac80211]
 [<ffffffffa05a1ade>] ieee80211_tx+0xbf/0xd1 [mac80211]
 [<ffffffffa05a1b7c>] ieee80211_xmit+0x8c/0x95 [mac80211]
 [<ffffffffa05a286d>] ieee80211_subif_start_xmit+0x9df/0xa3a [mac80211]
 [<ffffffff812f813a>] dev_hard_start_xmit+0x287/0x3e5
 [<ffffffff813142fd>] sch_direct_xmit+0x70/0x179
 [<ffffffff812f115d>] ? spin_lock+0x9/0xb
 [<ffffffff812f8578>] __dev_queue_xmit+0x2e0/0x4e0
 [<ffffffff812f878e>] dev_queue_xmit+0xb/0xd
 [<ffffffff813aec11>] packet_sendmsg+0xb5d/0xbda
 [<ffffffff8106478e>] ? sched_clock_cpu+0xa4/0xbe
 [<ffffffff812de615>] __sock_sendmsg_nosec+0x25/0x27
 [<ffffffff812e0f4e>] sock_sendmsg+0x5a/0x7b
 [<ffffffff81107686>] ? might_fault+0x55/0xa5
 [<ffffffff812de93e>] ? copy_from_user+0x2a/0x2c
 [<ffffffff812e1d80>] SYSC_sendto+0x10a/0x139
 [<ffffffff810718c9>] ? trace_hardirqs_off_caller+0x37/0xa6
 [<ffffffff813c53cd>] ? retint_swapgs+0xe/0x13
 [<ffffffff81075976>] ? trace_hardirqs_on_caller+0x145/0x1a1
 [<ffffffff811ee62e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff812e1f75>] SyS_sendto+0x9/0xb
 [<ffffffff813c4852>] system_call_fastpath+0x16/0x1b
---[ end trace eda735e0dce4402f ]---

Looking at the code didn't make it clear to me whether this was
something you wanted reported or not, so I chose to report it just in
case. FWIW, the access point in use at this time was a Cisco/Linksys
EA6700, connected on 2.4 Ghz with somewhat low signal and lots of noise
around.  This is the view a few minutes later from the same position:


nemi:/home/bjorn# iw wlan0 link
Connected to c8:d7:19:37:f5:94 (on wlan0)
        SSID: Kjellerbod
        freq: 2417
        RX: 140862560 bytes (120659 packets)
        TX: 8919736 bytes (56267 packets)
        signal: -69 dBm
        tx bitrate: 86.7 MBit/s MCS 12 short GI

        bss flags:      short-preamble short-slot-time
        dtim period:    1
        beacon int:     100
nemi:/home/bjorn# iw wlan0 station dump
Station c8:d7:19:37:f5:94 (on wlan0)
        inactive time:  2884 ms
        rx bytes:       140863633
        rx packets:     120669
        tx bytes:       8919994
        tx packets:     56270
        tx retries:     11612
        tx failed:      10
        signal:         -74 [-74] dBm
        signal avg:     -72 [-72] dBm
        tx bitrate:     86.7 MBit/s MCS 12 short GI
        rx bitrate:     39.0 MBit/s MCS 10
        authorized:     yes
        authenticated:  yes
        preamble:       long
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no



Bjørn
