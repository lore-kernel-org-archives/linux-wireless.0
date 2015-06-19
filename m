Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:10837 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbbFSIAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2015 04:00:14 -0400
Message-ID: <5583CBFA.10601@broadcom.com> (sfid-20150619_100018_522168_DCE75AFE)
Date: Fri, 19 Jun 2015 09:59:54 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: creating ap interface
References: <5581BEBA.1080500@broadcom.com> <1434637584.3294.0.camel@redhat.com>
In-Reply-To: <1434637584.3294.0.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/15 16:26, Dan Williams wrote:
> On Wed, 2015-06-17 at 20:38 +0200, Arend van Spriel wrote:
>> Hi Dan,
>>
>> When I create an AP interface using iw, it is followed by a change
>> interface back to managed mode. I added a WARN_ON to see where it came
>> from and it turns out to be the NetworkManager. However, I had disabled
>> wifi as you suggested on the mailing list once. What is your take on
>> this: bug or intentional?
>
> Which method was that to disable wifi?  Also, what NM version are you
> running?

I used nmcli, ie. nmcli nm wifi off. Running 4.1-rc6 kernel on Ubuntu 
14.04. Here nmcli version info:

$ nmcli -v
nmcli tool, version 0.9.8.8

Regards,
Arend

> Dan
>
>> Regards,
>> Arend
>>
>> [195312.837736] brcmfmac: brcmf_cfg80211_add_iface enter: wl5ap type 3
>> [195312.844033] brcmfmac: brcmf_ap_add_vif Adding vif "wl5ap"
>> [195312.849525] brcmfmac: brcmf_alloc_vif allocating virtual interface
>> (size=3136)
>> [195312.856842] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bssidx=0,
>> name=bsscfg:ssid, len=40
>> [195312.865276] brcmutil: data
>> [195312.868070] 00000000: 02 00 00 00 05 00 00 00 73 73 69 64 32 00 00
>> 00  ........ssid2...
>> [195312.876187] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00  ................
>> [195312.884301] 00000020: 00 00 00 00 00 00 00 00
>>      ........
>> [195312.891725] brcmfmac: brcmf_sdio_bus_txctl Enter
>> [195312.896466] brcmfmac: brcmf_sdio_dpc Enter
>> [195312.900663] brcmfmac: brcmf_sdio_kso_control Enter: on=1
>> [195312.910548] brcmfmac: brcmf_sdio_isr Enter
>> [195312.914877] brcmfmac: brcmf_sdio_tx_ctrlframe Enter
>> [195312.919943] brcmfmac: brcmf_sdio_dpc Enter
>> [195312.920022] brcmfmac: brcmf_sdio_bus_rxctl Enter
>> [195312.928967] brcmfmac: brcmf_sdio_isr Enter
>> [195312.933282] brcmfmac: brcmf_sdio_dpc Dongle reports CHIPACTIVE
>> [195312.939220] brcmfmac: brcmf_sdio_readframes Enter
>> [195312.944099] brcmfmac: brcmf_sdio_read_control Enter
>> [195312.949234] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame,
>> got 68 expected 68
>> [195312.949310] brcmfmac: brcmf_fweh_event_worker event IF (54) ifidx 1
>> bsscfg 2 addr 00:90:4c:70:43:54
>> [195312.949312] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0
>> status 0 reason 0
>> [195312.949314] brcmutil: event payload, len=5
>> [195312.949316] 00000000: 01 01 00 02 01
>>      .....
>> [195312.949318] brcmfmac: brcmf_fweh_handle_if_event action: 1 idx: 1
>> bsscfg: 2 flags: 0 role: 1
>> [195312.949320] brcmfmac: brcmf_fweh_handle_if_event adding wl0.2
>> (00:90:4c:70:43:54)
>> [195312.949322] brcmfmac: brcmf_add_if Enter, idx=2, ifidx=1
>> [195312.949323] brcmfmac: brcmf_add_if allocate netdev interface
>> [195312.949333] brcmfmac: brcmf_add_if  ==== pid:135f, if:wl0.2
>> (00:90:4c:70:43:54) created ===
>> [195312.949336] brcmfmac: brcmf_fws_macdesc_init enter: desc
>> ffff8800bb798b00 ea=00:90:4c:70:43:54, ifidx=1
>> [195312.949338] brcmfmac: brcmf_fws_add_interface added MACIF:1
>> [195312.949341] brcmfmac: brcmf_notify_vif_event Enter: action 1 flags 0
>> ifidx 1 bsscfg 2
>> [195312.949403] brcmfmac: brcmf_sdio_dpc Enter
>> [195312.970325] brcmfmac: brcmf_sdio_kso_control Enter: on=0
>> [195313.054361] brcmfmac: brcmf_net_attach Enter, idx=2
>> mac=00:90:4c:70:43:54
>> [195313.061537] brcmfmac: brcmf_netdev_get_stats Enter, idx=2
>> [195313.067170] brcmfmac: brcmf_net_attach wl5ap: Broadcom Dongle Host
>> Driver
>> [195313.074637] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>> [195313.080149] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>> [195313.085653] brcmfmac: brcmf_netdev_get_stats Enter, idx=2
>> [195313.091877] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>> [195313.097400] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>> [195313.102934] brcmfmac: brcmf_netdev_get_stats Enter, idx=2
>> [195313.108825] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>> [195313.114322] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>> [195313.119835] brcmfmac: brcmf_netdev_get_stats Enter, idx=2
>> [195313.125593] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>> [195313.131117] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>> [195313.136610] brcmfmac: brcmf_netdev_get_stats Enter, idx=2
>> [195313.142185] brcmfmac: brcmf_cfg80211_change_iface Enter, idx=2, type=2
>> [195313.148804] ------------[ cut here ]------------
>> [195313.153520] WARNING: CPU: 1 PID: 1398 at
>> drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c:864
>> brcmf_cfg80211_change_iface+0x2a9/0x2d0 [brcmfmac]()
>> [195313.166897] Modules linked in: brcmfmac(O) brcmutil(O) sdhci_pci
>> sdhci cfg80211 nfsv3 nfs_acl nf_conntrack_ipv4 nf_defrag_ipv4
>> xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 iptable_mangle
>> xt_tcpudp ip6table_filter ip6_tables iptable_filter ip_tables
>> ebtable_nat ebtables x_tables autofs4 nfs bridge stp llc lockd grace
>> sunrpc fscache dell_wmi sparse_keymap snd_hda_codec_hdmi
>> snd_hda_codec_idt snd_hda_codec_generic dell_laptop pl2303 usbserial
>> nouveau dcdbas snd_hda_intel snd_hda_controller i8k snd_hda_codec
>> snd_hwdep snd_hda_core snd_pcm snd_seq_midi snd_seq_midi_event
>> snd_rawmidi snd_seq snd_seq_device coretemp crc32c_intel snd_timer
>> mxm_wmi intel_agp microcode serio_raw ttm drm_kms_helper intel_gtt
>> lpc_ich snd drm i2c_algo_bit intel_ips agpgart soundcore mfd_core video
>> mmc_block e1000e ptp firewire_ohci psmouse ahci libahci firewire_core
>> mmc_core crc_itu_t pps_core [last unloaded: cfg80211]
>> [195313.247913] CPU: 1 PID: 1398 Comm: NetworkManager Tainted: G
>> W  O    4.1.0-rc6-wl-testing-x64-00002-gc37b3da #1
>> [195313.258686] Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07
>> 02/15/2011
>> [195313.266107]  ffffffffa0edc918 ffff8800cafef988 ffffffff8161259f
>> 0000000000000001
>> [195313.273669]  0000000000000000 ffff8800cafef9c8 ffffffff810537ca
>> ffff8800c5483000
>> [195313.281228]  0000000000000002 ffff8800c5483000 ffff8800b9c36000
>> ffff8800b9cc0280
>> [195313.288787] Call Trace:
>> [195313.291325]  [<ffffffff8161259f>] dump_stack+0x45/0x57
>> [195313.296581]  [<ffffffff810537ca>] warn_slowpath_common+0x8a/0xc0
>> [195313.302669]  [<ffffffff810538ba>] warn_slowpath_null+0x1a/0x20
>> [195313.308617]  [<ffffffffa0ea9a29>]
>> brcmf_cfg80211_change_iface+0x2a9/0x2d0 [brcmfmac]
>> [195313.316460]  [<ffffffffa0e006e4>] cfg80211_change_iface+0x1a4/0x3f0
>> [cfg80211]
>> [195313.323801]  [<ffffffffa0e06dd6>] ?
>> __cfg80211_wdev_from_attrs+0x36/0x1a0 [cfg80211]
>> [195313.331630]  [<ffffffffa0e07ce7>] nl80211_set_interface+0x157/0x230
>> [cfg80211]
>> [195313.338973]  [<ffffffff8154a1e5>] genl_family_rcv_msg+0x1a5/0x3d0
>> [195313.345148]  [<ffffffff8154a410>] ? genl_family_rcv_msg+0x3d0/0x3d0
>> [195313.351513]  [<ffffffff8154a4a1>] genl_rcv_msg+0x91/0xd0
>> [195313.356907]  [<ffffffff81549741>] netlink_rcv_skb+0xc1/0xe0
>> [195313.362596]  [<ffffffff81549dec>] genl_rcv+0x2c/0x40
>> [195313.367644]  [<ffffffff815490bb>] netlink_unicast+0x15b/0x240
>> [195313.373502]  [<ffffffff815494e5>] netlink_sendmsg+0x345/0x3c0
>> [195313.379335]  [<ffffffff814ff82d>] sock_sendmsg+0x3d/0x50
>> [195313.384765]  [<ffffffff8150014f>] ___sys_sendmsg+0x28f/0x2a0
>> [195313.390507]  [<ffffffff815002c1>] ? ___sys_recvmsg+0x161/0x1f0
>> [195313.396456]  [<ffffffff811f1689>] ? sysctl_head_finish+0x49/0x50
>> [195313.402546]  [<ffffffff81059730>] ? proc_put_long+0x90/0x90
>> [195313.408238]  [<ffffffff811f1829>] ? proc_sys_call_handler+0x79/0xc0
>> [195313.414588]  [<ffffffff811c3f96>] ? fsnotify+0x2e6/0x410
>> [195313.420020]  [<ffffffff81337958>] ? lockref_put_or_lock+0x58/0x80
>> [195313.426196]  [<ffffffff811a2495>] ? __fget_light+0x25/0x70
>> [195313.431799]  [<ffffffff81500a32>] __sys_sendmsg+0x42/0x80
>> [195313.437281]  [<ffffffff81500a82>] SyS_sendmsg+0x12/0x20
>> [195313.442749]  [<ffffffff81618197>] system_call_fastpath+0x12/0x6a
>> [195313.448839] ---[ end trace a6c411e9e8c26904 ]---
>> [195313.453573] brcmf_cfg80211_change_iface: iface validation failed:
>> err=-16
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

