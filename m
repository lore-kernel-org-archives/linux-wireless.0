Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33343 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbcLFVcr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Dec 2016 16:32:47 -0500
Received: by mail-io0-f176.google.com with SMTP id j65so677323821iof.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2016 13:32:46 -0800 (PST)
Subject: Re: ath10k firmware crashes in mesh mode on QCA9880
To: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
References: <583DD564.8040704@cococorp.com>
 <20161201070908.GB11953@atheros-ThinkPad-T61> <58421FA2.2020004@cococorp.com>
 <20161203124358.GB31861@atheros-ThinkPad-T61>
 <20161203124600.GC31861@atheros-ThinkPad-T61> <5845B325.6060002@cococorp.com>
 <d8eb0ba5828d43dd83030247ba443b88@aphydexm01f.ap.qualcomm.com>
Cc: "agreen@cococorp.com" <agreen@cococorp.com>,
        "lede-dev@lists.infradead.org" <lede-dev@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Benjamin Morgan <bmorgan@cococorp.com>
Message-ID: <58472E7B.7090603@cococorp.com> (sfid-20161206_223256_909907_05D42173)
Date: Tue, 6 Dec 2016 13:32:43 -0800
MIME-Version: 1.0
In-Reply-To: <d8eb0ba5828d43dd83030247ba443b88@aphydexm01f.ap.qualcomm.com>
Content-Type: multipart/mixed;
 boundary="------------010307080509010901000406"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010307080509010901000406
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

1. Yes, this appears to happens every time a unicast packet with 
wpa_supplicant encryption in VHT80 mode is received. I haven't seen a 
successful ping-pong pair.
2. We tried with 10.2.4.70.42-2 firmware and still saw crashes.
3. We ran our experiment again with extra debugging turned on.
     Node A: 18:A6:F7:23:6E:66 | 10.230.5.41
     Node B: 18:A6:F7:26:0F:21 | 10.230.5.42
     The ping command we used was run on Node A was 'ping -s 1500 -i 0.1 
10.230.5.42'
     Here is the dmesg log from Node B.

[ 5413.478170] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5413.503954] ath10k_pci 0000:01:00.0: scan event bss channel type 4 
reason 3 freq 5825 req_id 40961 scan_id 40960 vdev_id 0 state running (2)
[ 5413.503985] ath10k_pci 0000:01:00.0: chan info err_code 0 freq 5825 
cmd_flags 1 noise_floor -105 rx_clear_count 7692807 cycle_count 312271423
[ 5413.504029] ath10k_pci 0000:01:00.0: scan event completed type 2 
reason 0 freq 5825 req_id 40961 scan_id 40960 vdev_id 0 state running (2)
[ 5413.525868] ath10k_pci 0000:01:00.0: wmi vdev install key idx 1 
cipher 4 len 16
[ 5413.526014] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 31 value 1
[ 5413.526193] ath10k_pci 0000:01:00.0: mac vdev 0 set keyidx 1
[ 5413.526216] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 31 value 1
[ 5413.526532] ath10k_pci 0000:01:00.0: mac chanctx add freq 5180 width 
3 ptr 86db29b0
[ 5413.526556] ath10k_pci 0000:01:00.0: mac monitor recalc started? 0 
needed? 0 allowed? 1
[ 5413.526574] ath10k_pci 0000:01:00.0: mac chanctx assign ptr 86db29b0 
vdev_id 0
[ 5413.526592] ath10k_pci 0000:01:00.0: mac vdev 0 start center_freq 
5180 phymode 11ac-vht80
[ 5413.526616] ath10k_pci 0000:01:00.0: wmi vdev start id 0x0 flags: 
0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 46
[ 5413.533099] ath10k_pci 0000:01:00.0: WMI_VDEV_START_RESP_EVENTID
[ 5413.533148] ath10k_pci 0000:01:00.0: mac vdev_id 0 txpower 23
[ 5413.533163] ath10k_pci 0000:01:00.0: mac txpower 23
[ 5413.533180] ath10k_pci 0000:01:00.0: wmi pdev set param 3 value 46
[ 5413.533247] ath10k_pci 0000:01:00.0: wmi pdev set param 4 value 46
[ 5413.533295] ath10k_pci 0000:01:00.0: mac chanctx change freq 5180 
width 3 ptr 86db29b0 changed 10
[ 5413.533318] ath10k_pci 0000:01:00.0: mac chanctx change freq 5180 
width 3 ptr 86db29b0 changed 2
[ 5413.533337] ath10k_pci 0000:01:00.0: mac monitor recalc started? 0 
needed? 1 allowed? 1
[ 5413.533357] ath10k_pci 0000:01:00.0: WMI vdev create: id 1 type 4 
subtype 0 macaddr 18:a6:f7:26:0f:21
[ 5413.533412] ath10k_pci 0000:01:00.0: mac monitor vdev 1 created
[ 5413.533463] ath10k_pci 0000:01:00.0: wmi vdev start id 0x1 flags: 
0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 46
[ 5413.937652] ath10k_pci 0000:01:00.0: wmi event debug mesg len 152
[ 5413.978273] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5414.478363] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5414.527015] ath10k_pci 0000:01:00.0: WMI_VDEV_START_RESP_EVENTID
[ 5414.527067] ath10k_pci 0000:01:00.0: wmi mgmt vdev up id 0x1 assoc id 
0 bssid 18:a6:f7:26:0f:21
[ 5414.527121] ath10k_pci 0000:01:00.0: mac monitor vdev 1 started
[ 5414.527165] ath10k_pci 0000:01:00.0: mac monitor started
[ 5414.527216] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 3 
value 1000
[ 5414.527262] ath10k_pci 0000:01:00.0: mac vdev 0 beacon_interval 1000
[ 5414.527278] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[ 5414.527294] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[ 5414.527314] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[ 5414.527330] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[ 5414.527457] ath10k_pci 0000:01:00.0: wmi mgmt vdev up id 0x0 assoc id 
0 bssid 00:00:00:00:00:00
[ 5414.527501] ath10k_pci 0000:01:00.0: mac vdev 0 up
[ 5414.527564] ath10k_pci 0000:01:00.0: WMI_TBTTOFFSET_UPDATE_EVENTID
[ 5414.541090] ath10k_pci 0000:01:00.0: mac monitor recalc started? 1 
needed? 1 allowed? 1
[ 5414.978454] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5415.478548] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5415.978649] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5416.445280] ath10k_pci 0000:01:00.0: mac monitor recalc started? 1 
needed? 1 allowed? 1
[ 5416.478761] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5416.978879] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5417.478985] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5417.979081] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5418.479190] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5418.979301] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5419.479403] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5419.979551] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5420.479643] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5420.979746] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5421.479841] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5421.979940] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5422.480288] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5422.980386] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5423.480490] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5423.980600] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5424.480702] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5424.971969] ath10k_pci 0000:01:00.0: mac vdev 0 peer create 
18:a6:f7:23:6e:66 (new sta) sta 1 / 128 peer 2 / 144
[ 5424.972000] ath10k_pci 0000:01:00.0: wmi peer create vdev_id 0 
peer_addr 18:a6:f7:23:6e:66
[ 5424.975107] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[ 5424.975134] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[ 5424.975219] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[ 5424.975238] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[ 5424.980787] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5425.204468] ath10k_pci 0000:01:00.0: mac sta 18:a6:f7:23:6e:66 associated
[ 5425.204531] ath10k_pci 0000:01:00.0: mac ht peer 18:a6:f7:23:6e:66 
mcs cnt 24 nss 3
[ 5425.204548] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:23:6e:66 qos 1
[ 5425.204563] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:23:6e:66 
phymode 11na-ht40
[ 5425.204585] ath10k_pci 0000:01:00.0: wmi peer assoc vdev 0 addr 
18:a6:f7:23:6e:66 (new)
[ 5425.204614] ath10k_pci 0000:01:00.0: wmi vdev 0 peer 
0x18:a6:f7:23:6e:66 set param 1 value 0
[ 5425.205376] ath10k_pci 0000:01:00.0: received event id 36891 not 
implemented
[ 5425.209240] ath10k_pci 0000:01:00.0: wmi vdev install key idx 0 
cipher 4 len 16
[ 5425.209655] ath10k_pci 0000:01:00.0: wmi vdev install key idx 1 
cipher 4 len 16
[ 5425.209848] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 31 value 1
[ 5425.210196] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[ 5425.210221] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[ 5425.210296] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[ 5425.210315] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[ 5425.480863] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5425.938619] ath10k_pci 0000:01:00.0: wmi event debug mesg len 100
[ 5425.980946] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5425.995007] ath10k_pci 0000:01:00.0: mac sta rc update for 
18:a6:f7:23:6e:66 changed 00000001 bw 2 nss 3 smps 1
[ 5425.995060] ath10k_pci 0000:01:00.0: mac update sta 18:a6:f7:23:6e:66 
peer bw 2
[ 5425.995081] ath10k_pci 0000:01:00.0: wmi vdev 0 peer 
0x18:a6:f7:23:6e:66 set param 4 value 2
[ 5426.481030] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5426.981117] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5427.481206] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5427.981294] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5428.481628] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5428.981718] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5429.481812] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5429.981894] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5430.481985] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5430.982073] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5431.482174] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5431.982505] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5432.482597] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5432.982679] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5433.482765] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5433.982857] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5434.482946] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5434.983008] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5435.483100] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5435.983181] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5436.483276] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5436.983366] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5437.483445] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5437.983516] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5438.483607] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5438.983692] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[ 5439.439875] ath10k_pci 0000:01:00.0: firmware crashed! (uuid 
db76b67c-ca98-4519-a762-4ff4edb45526)
[ 5439.449007] ath10k_pci 0000:01:00.0: qca988x hw2.0 target 0x4100016c 
chip_id 0x043202ff sub 0000:0000
[ 5439.458378] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1 
tracing 0 dfs 1 testmode 1
[ 5439.471460] ath10k_pci 0000:01:00.0: firmware ver 10.2.4.70.54 api 5 
features no-p2p,raw-mode,mfp crc32 9d340dd9
[ 5439.481844] ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A 
crc32 bebc7c08
[ 5439.489267] ath10k_pci 0000:01:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 
cal file max-sta 128 raw 0 hwcrypto 1
[ 5439.500918] ath10k_pci 0000:01:00.0: firmware register dump:
[ 5439.506678] ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3 
0x009A4577 0x00955B31
[ 5439.514706] ath10k_pci 0000:01:00.0: [04]: 0x009A4577 0x00060130 
0x00000002 0x00439E98
[ 5439.522751] ath10k_pci 0000:01:00.0: [08]: 0x0044110C 0x00442074 
0x00407120 0x004436CC
[ 5439.530794] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000000 
0x009A3518 0x009A3526
[ 5439.538834] ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094085D 
0x00000000 0x00000000
[ 5439.546871] ath10k_pci 0000:01:00.0: [20]: 0x409A4577 0x0040AAC4 
0x0040AC60 0x0040AC09
[ 5439.554915] ath10k_pci 0000:01:00.0: [24]: 0x809A44BA 0x0040AB24 
0x00400000 0xC09A4577
[ 5439.562948] ath10k_pci 0000:01:00.0: [28]: 0x809A39DE 0x0040AB84 
0x0044110C 0x00442074
[ 5439.570992] ath10k_pci 0000:01:00.0: [32]: 0x809A5FE2 0x0040ABB4 
0x0044110C 0x00407120
[ 5439.579032] ath10k_pci 0000:01:00.0: [36]: 0x809A2E6C 0x0040ABF4 
0x0040AC14 0x00001580
[ 5439.587070] ath10k_pci 0000:01:00.0: [40]: 0x80990F6F 0x0040AD04 
0x009C643C 0x004436CC
[ 5439.595113] ath10k_pci 0000:01:00.0: [44]: 0x80998510 0x0040AD64 
0x004208FC 0x00439E4C
[ 5439.603146] ath10k_pci 0000:01:00.0: [48]: 0x8099AE95 0x0040AD84 
0x004208FC 0x00425E00
[ 5439.611191] ath10k_pci 0000:01:00.0: [52]: 0x809BFC55 0x0040AEE4 
0x00424FE8 0x00000002
[ 5439.619230] ath10k_pci 0000:01:00.0: [56]: 0x80940F18 0x0040AF14 
0x00000004 0x004039D0
[ 5439.726818] ieee80211 phy0: Hardware restart was requested
[ 5439.732433] ath10k_pci 0000:01:00.0: wmi mgmt vdev down id 0x1
[ 5439.732461] ath10k_pci 0000:01:00.0: wmi vdev stop id 0x1
[ 5439.732482] ath10k_pci 0000:01:00.0: failed to synchronize monitor 
vdev 1 stop: -143
[ 5439.740370] ath10k_pci 0000:01:00.0: mac monitor vdev 1 stopped
[ 5439.740386] ath10k_pci 0000:01:00.0: failed to stop monitor vdev: -143
[ 5439.747042] ath10k_pci 0000:01:00.0: wmi disable pktlog

We noticed in this log that when the radio starts up it says that it is 
in VHT80 mode:
[ 5413.526592] ath10k_pci 0000:01:00.0: mac vdev 0 start center_freq 
5180 phymode 11ac-vht80

But when a peer connects it seems to think the peer is in HT40 mode:
[ 5425.204563] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:23:6e:66 
phymode 11na-ht40

Compared to no encryption case - this log was taken from Node A:

[   24.874253] ath10k_pci 0000:01:00.0: mac chanctx add freq 5180 width 
3 ptr 86d26db0
[   24.874278] ath10k_pci 0000:01:00.0: mac monitor recalc started? 0 
needed? 0 allowed? 1
[   24.874296] ath10k_pci 0000:01:00.0: mac chanctx assign ptr 86d26db0 
vdev_id 0
[   24.874312] ath10k_pci 0000:01:00.0: mac vdev 0 start center_freq 
5180 phymode 11ac-vht80
[   24.874337] ath10k_pci 0000:01:00.0: wmi vdev start id 0x0 flags: 
0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 46
[   24.881335] ath10k_pci 0000:01:00.0: WMI_VDEV_START_RESP_EVENTID
[   24.881423] ath10k_pci 0000:01:00.0: mac vdev_id 0 txpower 23
[   24.881438] ath10k_pci 0000:01:00.0: mac txpower 23
[   24.881454] ath10k_pci 0000:01:00.0: wmi pdev set param 3 value 46
[   24.881491] ath10k_pci 0000:01:00.0: wmi pdev set param 4 value 46
[   24.881515] ath10k_pci 0000:01:00.0: mac chanctx change freq 5180 
width 3 ptr 86d26db0 changed 10
[   24.881535] ath10k_pci 0000:01:00.0: mac chanctx change freq 5180 
width 3 ptr 86d26db0 changed 2
[   24.881554] ath10k_pci 0000:01:00.0: mac monitor recalc started? 0 
needed? 1 allowed? 1
[   24.881574] ath10k_pci 0000:01:00.0: WMI vdev create: id 1 type 4 
subtype 0 macaddr 18:a6:f7:23:6e:66
[   24.881689] ath10k_pci 0000:01:00.0: mac monitor vdev 1 created
[   24.881745] ath10k_pci 0000:01:00.0: wmi vdev start id 0x1 flags: 
0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 46
[   25.273460] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[   25.730570] ath10k_pci 0000:01:00.0: wmi event debug mesg len 300
[   25.773566] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[   25.874556] ath10k_pci 0000:01:00.0: WMI_VDEV_START_RESP_EVENTID
[   25.879992] ath10k_pci 0000:01:00.0: wmi mgmt vdev up id 0x1 assoc id 
0 bssid 18:a6:f7:23:6e:66
[   25.880077] ath10k_pci 0000:01:00.0: mac monitor vdev 1 started
[   25.880093] ath10k_pci 0000:01:00.0: mac monitor started
[   25.880139] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 3 
value 1000
[   25.880184] ath10k_pci 0000:01:00.0: mac vdev 0 beacon_interval 1000
[   25.880199] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[   25.880215] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[   25.880235] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[   25.880250] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[   25.880988] ath10k_pci 0000:01:00.0: wmi mgmt vdev up id 0x0 assoc id 
0 bssid 00:00:00:00:00:00
[   25.881035] ath10k_pci 0000:01:00.0: mac vdev 0 up
[   25.881097] ath10k_pci 0000:01:00.0: WMI_TBTTOFFSET_UPDATE_EVENTID
[   25.882968] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   25.928796] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[   25.928821] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[   25.928866] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[   25.928883] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[   25.929020] ath10k_pci 0000:01:00.0: mac monitor recalc started? 1 
needed? 1 allowed? 1
[   25.941886] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[   25.941911] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[   25.941955] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[   25.941972] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[   25.953727] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[   25.953753] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[   25.953798] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[   25.953817] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[   25.970588] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[   25.970614] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[   25.970659] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[   25.970676] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[   25.989056] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[   25.989081] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[   25.989126] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[   25.989143] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[   26.071686] ath10k_pci 0000:01:00.0: mac vdev 0 peer create 
18:a6:f7:26:0f:21 (new sta) sta 1 / 128 peer 2 / 144
[   26.071712] ath10k_pci 0000:01:00.0: wmi peer create vdev_id 0 
peer_addr 18:a6:f7:26:0f:21
[   26.071952] ath10k_pci 0000:01:00.0: mac sta 18:a6:f7:26:0f:21 associated
[   26.071981] ath10k_pci 0000:01:00.0: mac ht peer 18:a6:f7:26:0f:21 
mcs cnt 24 nss 3
[   26.071999] ath10k_pci 0000:01:00.0: mac vht peer 18:a6:f7:26:0f:21 
max_mpdu 1048575 flags 0x601b001
[   26.072013] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:26:0f:21 qos 1
[   26.072028] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:26:0f:21 
phymode 11ac-vht80
[   26.072047] ath10k_pci 0000:01:00.0: wmi peer assoc vdev 0 addr 
18:a6:f7:26:0f:21 (new)
[   26.072071] ath10k_pci 0000:01:00.0: wmi vdev 0 peer 
0x18:a6:f7:26:0f:21 set param 1 value 0
[   26.072502] ath10k_pci 0000:01:00.0: received event id 36891 not 
implemented
[   26.074194] ath10k_pci 0000:01:00.0: mac sta rc update for 
18:a6:f7:26:0f:21 changed 00000000 bw 2 nss 3 smps 1
[   26.074586] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
staggered
[   26.074609] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
[   26.074682] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
[   26.074701] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 value 2
[   26.074760] ath10k_pci 0000:01:00.0: mac vdev 0 slot_time 2
[   26.074779] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 7 value 2
[   26.273652] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[   26.730650] ath10k_pci 0000:01:00.0: wmi event debug mesg len 44
[   26.773733] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
[   27.135445] ath10k_pci 0000:01:00.0: mac monitor recalc started? 1 
needed? 1 allowed? 1
[   27.273810] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID

It seems to start up in VHT80 mode and when it peers with Node B it 
thinks Node B is also in VHT80 mode and ping works.

4. Beacons are sent at 6 Mb/s basic rate and unicast QoS Data is sent 
with three spatial streams. Attached is the full pcap of the experiment.

Thank you for looking into this!

~Benjamin

On 12/05/2016 11:24 AM, Nagarajan, Ashok Raj wrote:
> 0x009A4577 0x00955B31
>
> Benjamin, Thanks for the logs.
> Quick questions to further debug the issue here,
>
> 1. Is this issue seen every time you start sending data traffic?
> 2. Issue seen with older firmwares? (FYR, http://linuxwireless.org/en/users/Drivers/ath10k/firmware/ )
> 3. Could you please share the dmesg from your device after enabling MAC and WMI logs in ath10k driver
> 	To enable debug logs please see http://linuxwireless.org/en/users/Drivers/ath10k/debug/	
> 4. Do you know what is the Number of Spatial Streams seen in mesh beacons and in mesh data packet?
>
> Thanks,
> Ashok


--------------010307080509010901000406
Content-Type: application/x-compressed-tar;
 name="ath10k_crash_pcap.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ath10k_crash_pcap.tgz"

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
gUAgEAgEAoFAIBAIBAKB/rv6CznKBugAYAQA
--------------010307080509010901000406--
