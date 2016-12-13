Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35655 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932250AbcLMSma (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 13:42:30 -0500
Received: by mail-oi0-f49.google.com with SMTP id b126so132854423oia.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2016 10:42:30 -0800 (PST)
Subject: Re: ath10k firmware crashes in mesh mode on QCA9880
To: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
References: <583DD564.8040704@cococorp.com>
 <20161201070908.GB11953@atheros-ThinkPad-T61> <58421FA2.2020004@cococorp.com>
 <20161203124358.GB31861@atheros-ThinkPad-T61>
 <20161203124600.GC31861@atheros-ThinkPad-T61> <5845B325.6060002@cococorp.com>
 <d8eb0ba5828d43dd83030247ba443b88@aphydexm01f.ap.qualcomm.com>
 <58472E7B.7090603@cococorp.com>
Cc: "agreen@cococorp.com" <agreen@cococorp.com>,
        "lede-dev@lists.infradead.org" <lede-dev@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Benjamin Morgan <bmorgan@cococorp.com>
Message-ID: <58504113.2080702@cococorp.com> (sfid-20161213_194235_774108_EAE6568F)
Date: Tue, 13 Dec 2016 10:42:27 -0800
MIME-Version: 1.0
In-Reply-To: <58472E7B.7090603@cococorp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just tested the latest 10.2.4.70.59-2 firmware and it still crashes with 
wpa_supplicant encrypted mesh =(

[   85.201440] ath10k_pci 0000:01:00.0: firmware crashed! (uuid 
b7f44483-0488-46af-8dff-db88f4b56327)
[   85.210573] ath10k_pci 0000:01:00.0: qca988x hw2.0 target 0x4100016c 
chip_id 0x043202ff sub 0000:0000
[   85.219940] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1 
tracing 0 dfs 1 testmode 1
[   85.233034] ath10k_pci 0000:01:00.0: firmware ver 10.2.4.70.59-2 api 
5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 4159f498
[   85.245177] ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A 
crc32 bebc7c08
[   85.252592] ath10k_pci 0000:01:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 
cal file max-sta 128 raw 0 hwcrypto 1
[   85.264235] ath10k_pci 0000:01:00.0: firmware register dump:
[   85.269992] ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3 
0x009A45AF 0x00955B31
[   85.278031] ath10k_pci 0000:01:00.0: [04]: 0x009A45AF 0x00060130 
0x00000002 0x00439E98
[   85.286078] ath10k_pci 0000:01:00.0: [08]: 0x0044110C 0x00442074 
0x00407120 0x004436CC
[   85.294107] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000000 
0x009A3550 0x009A355E
[   85.302152] ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094085D 
0x00000000 0x00000000
[   85.310195] ath10k_pci 0000:01:00.0: [20]: 0x409A45AF 0x0040AAC4 
0x0040AC60 0x0040AC09
[   85.318239] ath10k_pci 0000:01:00.0: [24]: 0x809A44F2 0x0040AB24 
0x00400000 0xC09A45AF
[   85.326282] ath10k_pci 0000:01:00.0: [28]: 0x809A3A16 0x0040AB84 
0x0044110C 0x00442074
[   85.334314] ath10k_pci 0000:01:00.0: [32]: 0x809A601A 0x0040ABB4 
0x0044110C 0x00407120
[   85.342350] ath10k_pci 0000:01:00.0: [36]: 0x809A2EA4 0x0040ABF4 
0x0040AC14 0x00001580
[   85.350393] ath10k_pci 0000:01:00.0: [40]: 0x80990F63 0x0040AD04 
0x009C6458 0x004436CC
[   85.358437] ath10k_pci 0000:01:00.0: [44]: 0x80998520 0x0040AD64 
0x004208FC 0x00439E4C
[   85.366479] ath10k_pci 0000:01:00.0: [48]: 0x8099AEA5 0x0040AD84 
0x004208FC 0x00425AAC
[   85.374512] ath10k_pci 0000:01:00.0: [52]: 0x809BFC39 0x0040AEE4 
0x00424FE8 0x00000002
[   85.382548] ath10k_pci 0000:01:00.0: [56]: 0x80940F18 0x0040AF14 
0x00000004 0x004039D0
[   85.487067] ieee80211 phy0: Hardware restart was requested
[   85.492701] ath10k_pci 0000:01:00.0: wmi disable pktlog

Any new leads on tracking down this issue?

~Benjamin


On 12/06/2016 01:32 PM, Benjamin Morgan wrote:
> 1. Yes, this appears to happens every time a unicast packet with 
> wpa_supplicant encryption in VHT80 mode is received. I haven't seen a 
> successful ping-pong pair.
> 2. We tried with 10.2.4.70.42-2 firmware and still saw crashes.
> 3. We ran our experiment again with extra debugging turned on.
>     Node A: 18:A6:F7:23:6E:66 | 10.230.5.41
>     Node B: 18:A6:F7:26:0F:21 | 10.230.5.42
>     The ping command we used was run on Node A was 'ping -s 1500 -i 
> 0.1 10.230.5.42'
>     Here is the dmesg log from Node B.
>
> [ 5413.478170] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5413.503954] ath10k_pci 0000:01:00.0: scan event bss channel type 4 
> reason 3 freq 5825 req_id 40961 scan_id 40960 vdev_id 0 state running (2)
> [ 5413.503985] ath10k_pci 0000:01:00.0: chan info err_code 0 freq 5825 
> cmd_flags 1 noise_floor -105 rx_clear_count 7692807 cycle_count 312271423
> [ 5413.504029] ath10k_pci 0000:01:00.0: scan event completed type 2 
> reason 0 freq 5825 req_id 40961 scan_id 40960 vdev_id 0 state running (2)
> [ 5413.525868] ath10k_pci 0000:01:00.0: wmi vdev install key idx 1 
> cipher 4 len 16
> [ 5413.526014] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 31 
> value 1
> [ 5413.526193] ath10k_pci 0000:01:00.0: mac vdev 0 set keyidx 1
> [ 5413.526216] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 31 
> value 1
> [ 5413.526532] ath10k_pci 0000:01:00.0: mac chanctx add freq 5180 
> width 3 ptr 86db29b0
> [ 5413.526556] ath10k_pci 0000:01:00.0: mac monitor recalc started? 0 
> needed? 0 allowed? 1
> [ 5413.526574] ath10k_pci 0000:01:00.0: mac chanctx assign ptr 
> 86db29b0 vdev_id 0
> [ 5413.526592] ath10k_pci 0000:01:00.0: mac vdev 0 start center_freq 
> 5180 phymode 11ac-vht80
> [ 5413.526616] ath10k_pci 0000:01:00.0: wmi vdev start id 0x0 flags: 
> 0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 46
> [ 5413.533099] ath10k_pci 0000:01:00.0: WMI_VDEV_START_RESP_EVENTID
> [ 5413.533148] ath10k_pci 0000:01:00.0: mac vdev_id 0 txpower 23
> [ 5413.533163] ath10k_pci 0000:01:00.0: mac txpower 23
> [ 5413.533180] ath10k_pci 0000:01:00.0: wmi pdev set param 3 value 46
> [ 5413.533247] ath10k_pci 0000:01:00.0: wmi pdev set param 4 value 46
> [ 5413.533295] ath10k_pci 0000:01:00.0: mac chanctx change freq 5180 
> width 3 ptr 86db29b0 changed 10
> [ 5413.533318] ath10k_pci 0000:01:00.0: mac chanctx change freq 5180 
> width 3 ptr 86db29b0 changed 2
> [ 5413.533337] ath10k_pci 0000:01:00.0: mac monitor recalc started? 0 
> needed? 1 allowed? 1
> [ 5413.533357] ath10k_pci 0000:01:00.0: WMI vdev create: id 1 type 4 
> subtype 0 macaddr 18:a6:f7:26:0f:21
> [ 5413.533412] ath10k_pci 0000:01:00.0: mac monitor vdev 1 created
> [ 5413.533463] ath10k_pci 0000:01:00.0: wmi vdev start id 0x1 flags: 
> 0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 46
> [ 5413.937652] ath10k_pci 0000:01:00.0: wmi event debug mesg len 152
> [ 5413.978273] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5414.478363] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5414.527015] ath10k_pci 0000:01:00.0: WMI_VDEV_START_RESP_EVENTID
> [ 5414.527067] ath10k_pci 0000:01:00.0: wmi mgmt vdev up id 0x1 assoc 
> id 0 bssid 18:a6:f7:26:0f:21
> [ 5414.527121] ath10k_pci 0000:01:00.0: mac monitor vdev 1 started
> [ 5414.527165] ath10k_pci 0000:01:00.0: mac monitor started
> [ 5414.527216] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 3 
> value 1000
> [ 5414.527262] ath10k_pci 0000:01:00.0: mac vdev 0 beacon_interval 1000
> [ 5414.527278] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [ 5414.527294] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [ 5414.527314] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [ 5414.527330] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [ 5414.527457] ath10k_pci 0000:01:00.0: wmi mgmt vdev up id 0x0 assoc 
> id 0 bssid 00:00:00:00:00:00
> [ 5414.527501] ath10k_pci 0000:01:00.0: mac vdev 0 up
> [ 5414.527564] ath10k_pci 0000:01:00.0: WMI_TBTTOFFSET_UPDATE_EVENTID
> [ 5414.541090] ath10k_pci 0000:01:00.0: mac monitor recalc started? 1 
> needed? 1 allowed? 1
> [ 5414.978454] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5415.478548] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5415.978649] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5416.445280] ath10k_pci 0000:01:00.0: mac monitor recalc started? 1 
> needed? 1 allowed? 1
> [ 5416.478761] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5416.978879] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5417.478985] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5417.979081] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5418.479190] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5418.979301] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5419.479403] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5419.979551] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5420.479643] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5420.979746] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5421.479841] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5421.979940] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5422.480288] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5422.980386] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5423.480490] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5423.980600] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5424.480702] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5424.971969] ath10k_pci 0000:01:00.0: mac vdev 0 peer create 
> 18:a6:f7:23:6e:66 (new sta) sta 1 / 128 peer 2 / 144
> [ 5424.972000] ath10k_pci 0000:01:00.0: wmi peer create vdev_id 0 
> peer_addr 18:a6:f7:23:6e:66
> [ 5424.975107] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [ 5424.975134] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [ 5424.975219] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [ 5424.975238] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [ 5424.980787] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5425.204468] ath10k_pci 0000:01:00.0: mac sta 18:a6:f7:23:6e:66 
> associated
> [ 5425.204531] ath10k_pci 0000:01:00.0: mac ht peer 18:a6:f7:23:6e:66 
> mcs cnt 24 nss 3
> [ 5425.204548] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:23:6e:66 qos 1
> [ 5425.204563] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:23:6e:66 
> phymode 11na-ht40
> [ 5425.204585] ath10k_pci 0000:01:00.0: wmi peer assoc vdev 0 addr 
> 18:a6:f7:23:6e:66 (new)
> [ 5425.204614] ath10k_pci 0000:01:00.0: wmi vdev 0 peer 
> 0x18:a6:f7:23:6e:66 set param 1 value 0
> [ 5425.205376] ath10k_pci 0000:01:00.0: received event id 36891 not 
> implemented
> [ 5425.209240] ath10k_pci 0000:01:00.0: wmi vdev install key idx 0 
> cipher 4 len 16
> [ 5425.209655] ath10k_pci 0000:01:00.0: wmi vdev install key idx 1 
> cipher 4 len 16
> [ 5425.209848] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 31 
> value 1
> [ 5425.210196] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [ 5425.210221] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [ 5425.210296] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [ 5425.210315] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [ 5425.480863] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5425.938619] ath10k_pci 0000:01:00.0: wmi event debug mesg len 100
> [ 5425.980946] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5425.995007] ath10k_pci 0000:01:00.0: mac sta rc update for 
> 18:a6:f7:23:6e:66 changed 00000001 bw 2 nss 3 smps 1
> [ 5425.995060] ath10k_pci 0000:01:00.0: mac update sta 
> 18:a6:f7:23:6e:66 peer bw 2
> [ 5425.995081] ath10k_pci 0000:01:00.0: wmi vdev 0 peer 
> 0x18:a6:f7:23:6e:66 set param 4 value 2
> [ 5426.481030] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5426.981117] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5427.481206] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5427.981294] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5428.481628] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5428.981718] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5429.481812] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5429.981894] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5430.481985] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5430.982073] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5431.482174] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5431.982505] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5432.482597] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5432.982679] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5433.482765] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5433.982857] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5434.482946] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5434.983008] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5435.483100] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5435.983181] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5436.483276] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5436.983366] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5437.483445] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5437.983516] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5438.483607] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5438.983692] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [ 5439.439875] ath10k_pci 0000:01:00.0: firmware crashed! (uuid 
> db76b67c-ca98-4519-a762-4ff4edb45526)
> [ 5439.449007] ath10k_pci 0000:01:00.0: qca988x hw2.0 target 
> 0x4100016c chip_id 0x043202ff sub 0000:0000
> [ 5439.458378] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1 
> tracing 0 dfs 1 testmode 1
> [ 5439.471460] ath10k_pci 0000:01:00.0: firmware ver 10.2.4.70.54 api 
> 5 features no-p2p,raw-mode,mfp crc32 9d340dd9
> [ 5439.481844] ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A 
> crc32 bebc7c08
> [ 5439.489267] ath10k_pci 0000:01:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 
> cal file max-sta 128 raw 0 hwcrypto 1
> [ 5439.500918] ath10k_pci 0000:01:00.0: firmware register dump:
> [ 5439.506678] ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3 
> 0x009A4577 0x00955B31
> [ 5439.514706] ath10k_pci 0000:01:00.0: [04]: 0x009A4577 0x00060130 
> 0x00000002 0x00439E98
> [ 5439.522751] ath10k_pci 0000:01:00.0: [08]: 0x0044110C 0x00442074 
> 0x00407120 0x004436CC
> [ 5439.530794] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000000 
> 0x009A3518 0x009A3526
> [ 5439.538834] ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094085D 
> 0x00000000 0x00000000
> [ 5439.546871] ath10k_pci 0000:01:00.0: [20]: 0x409A4577 0x0040AAC4 
> 0x0040AC60 0x0040AC09
> [ 5439.554915] ath10k_pci 0000:01:00.0: [24]: 0x809A44BA 0x0040AB24 
> 0x00400000 0xC09A4577
> [ 5439.562948] ath10k_pci 0000:01:00.0: [28]: 0x809A39DE 0x0040AB84 
> 0x0044110C 0x00442074
> [ 5439.570992] ath10k_pci 0000:01:00.0: [32]: 0x809A5FE2 0x0040ABB4 
> 0x0044110C 0x00407120
> [ 5439.579032] ath10k_pci 0000:01:00.0: [36]: 0x809A2E6C 0x0040ABF4 
> 0x0040AC14 0x00001580
> [ 5439.587070] ath10k_pci 0000:01:00.0: [40]: 0x80990F6F 0x0040AD04 
> 0x009C643C 0x004436CC
> [ 5439.595113] ath10k_pci 0000:01:00.0: [44]: 0x80998510 0x0040AD64 
> 0x004208FC 0x00439E4C
> [ 5439.603146] ath10k_pci 0000:01:00.0: [48]: 0x8099AE95 0x0040AD84 
> 0x004208FC 0x00425E00
> [ 5439.611191] ath10k_pci 0000:01:00.0: [52]: 0x809BFC55 0x0040AEE4 
> 0x00424FE8 0x00000002
> [ 5439.619230] ath10k_pci 0000:01:00.0: [56]: 0x80940F18 0x0040AF14 
> 0x00000004 0x004039D0
> [ 5439.726818] ieee80211 phy0: Hardware restart was requested
> [ 5439.732433] ath10k_pci 0000:01:00.0: wmi mgmt vdev down id 0x1
> [ 5439.732461] ath10k_pci 0000:01:00.0: wmi vdev stop id 0x1
> [ 5439.732482] ath10k_pci 0000:01:00.0: failed to synchronize monitor 
> vdev 1 stop: -143
> [ 5439.740370] ath10k_pci 0000:01:00.0: mac monitor vdev 1 stopped
> [ 5439.740386] ath10k_pci 0000:01:00.0: failed to stop monitor vdev: -143
> [ 5439.747042] ath10k_pci 0000:01:00.0: wmi disable pktlog
>
> We noticed in this log that when the radio starts up it says that it 
> is in VHT80 mode:
> [ 5413.526592] ath10k_pci 0000:01:00.0: mac vdev 0 start center_freq 
> 5180 phymode 11ac-vht80
>
> But when a peer connects it seems to think the peer is in HT40 mode:
> [ 5425.204563] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:23:6e:66 
> phymode 11na-ht40
>
> Compared to no encryption case - this log was taken from Node A:
>
> [   24.874253] ath10k_pci 0000:01:00.0: mac chanctx add freq 5180 
> width 3 ptr 86d26db0
> [   24.874278] ath10k_pci 0000:01:00.0: mac monitor recalc started? 0 
> needed? 0 allowed? 1
> [   24.874296] ath10k_pci 0000:01:00.0: mac chanctx assign ptr 
> 86d26db0 vdev_id 0
> [   24.874312] ath10k_pci 0000:01:00.0: mac vdev 0 start center_freq 
> 5180 phymode 11ac-vht80
> [   24.874337] ath10k_pci 0000:01:00.0: wmi vdev start id 0x0 flags: 
> 0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 46
> [   24.881335] ath10k_pci 0000:01:00.0: WMI_VDEV_START_RESP_EVENTID
> [   24.881423] ath10k_pci 0000:01:00.0: mac vdev_id 0 txpower 23
> [   24.881438] ath10k_pci 0000:01:00.0: mac txpower 23
> [   24.881454] ath10k_pci 0000:01:00.0: wmi pdev set param 3 value 46
> [   24.881491] ath10k_pci 0000:01:00.0: wmi pdev set param 4 value 46
> [   24.881515] ath10k_pci 0000:01:00.0: mac chanctx change freq 5180 
> width 3 ptr 86d26db0 changed 10
> [   24.881535] ath10k_pci 0000:01:00.0: mac chanctx change freq 5180 
> width 3 ptr 86d26db0 changed 2
> [   24.881554] ath10k_pci 0000:01:00.0: mac monitor recalc started? 0 
> needed? 1 allowed? 1
> [   24.881574] ath10k_pci 0000:01:00.0: WMI vdev create: id 1 type 4 
> subtype 0 macaddr 18:a6:f7:23:6e:66
> [   24.881689] ath10k_pci 0000:01:00.0: mac monitor vdev 1 created
> [   24.881745] ath10k_pci 0000:01:00.0: wmi vdev start id 0x1 flags: 
> 0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 46
> [   25.273460] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [   25.730570] ath10k_pci 0000:01:00.0: wmi event debug mesg len 300
> [   25.773566] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [   25.874556] ath10k_pci 0000:01:00.0: WMI_VDEV_START_RESP_EVENTID
> [   25.879992] ath10k_pci 0000:01:00.0: wmi mgmt vdev up id 0x1 assoc 
> id 0 bssid 18:a6:f7:23:6e:66
> [   25.880077] ath10k_pci 0000:01:00.0: mac monitor vdev 1 started
> [   25.880093] ath10k_pci 0000:01:00.0: mac monitor started
> [   25.880139] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 3 
> value 1000
> [   25.880184] ath10k_pci 0000:01:00.0: mac vdev 0 beacon_interval 1000
> [   25.880199] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [   25.880215] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [   25.880235] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [   25.880250] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [   25.880988] ath10k_pci 0000:01:00.0: wmi mgmt vdev up id 0x0 assoc 
> id 0 bssid 00:00:00:00:00:00
> [   25.881035] ath10k_pci 0000:01:00.0: mac vdev 0 up
> [   25.881097] ath10k_pci 0000:01:00.0: WMI_TBTTOFFSET_UPDATE_EVENTID
> [   25.882968] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   25.928796] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [   25.928821] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [   25.928866] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [   25.928883] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [   25.929020] ath10k_pci 0000:01:00.0: mac monitor recalc started? 1 
> needed? 1 allowed? 1
> [   25.941886] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [   25.941911] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [   25.941955] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [   25.941972] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [   25.953727] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [   25.953753] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [   25.953798] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [   25.953817] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [   25.970588] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [   25.970614] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [   25.970659] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [   25.970676] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [   25.989056] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [   25.989081] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [   25.989126] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [   25.989143] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [   26.071686] ath10k_pci 0000:01:00.0: mac vdev 0 peer create 
> 18:a6:f7:26:0f:21 (new sta) sta 1 / 128 peer 2 / 144
> [   26.071712] ath10k_pci 0000:01:00.0: wmi peer create vdev_id 0 
> peer_addr 18:a6:f7:26:0f:21
> [   26.071952] ath10k_pci 0000:01:00.0: mac sta 18:a6:f7:26:0f:21 
> associated
> [   26.071981] ath10k_pci 0000:01:00.0: mac ht peer 18:a6:f7:26:0f:21 
> mcs cnt 24 nss 3
> [   26.071999] ath10k_pci 0000:01:00.0: mac vht peer 18:a6:f7:26:0f:21 
> max_mpdu 1048575 flags 0x601b001
> [   26.072013] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:26:0f:21 qos 1
> [   26.072028] ath10k_pci 0000:01:00.0: mac peer 18:a6:f7:26:0f:21 
> phymode 11ac-vht80
> [   26.072047] ath10k_pci 0000:01:00.0: wmi peer assoc vdev 0 addr 
> 18:a6:f7:26:0f:21 (new)
> [   26.072071] ath10k_pci 0000:01:00.0: wmi vdev 0 peer 
> 0x18:a6:f7:26:0f:21 set param 1 value 0
> [   26.072502] ath10k_pci 0000:01:00.0: received event id 36891 not 
> implemented
> [   26.074194] ath10k_pci 0000:01:00.0: mac sta rc update for 
> 18:a6:f7:26:0f:21 changed 00000000 bw 2 nss 3 smps 1
> [   26.074586] ath10k_pci 0000:01:00.0: vdev 0 set beacon tx mode to 
> staggered
> [   26.074609] ath10k_pci 0000:01:00.0: wmi pdev set param 7 value 0
> [   26.074682] ath10k_pci 0000:01:00.0: mac vdev 0 dtim_period 2
> [   26.074701] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 13 
> value 2
> [   26.074760] ath10k_pci 0000:01:00.0: mac vdev 0 slot_time 2
> [   26.074779] ath10k_pci 0000:01:00.0: wmi vdev id 0x0 set param 7 
> value 2
> [   26.273652] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [   26.730650] ath10k_pci 0000:01:00.0: wmi event debug mesg len 44
> [   26.773733] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
> [   27.135445] ath10k_pci 0000:01:00.0: mac monitor recalc started? 1 
> needed? 1 allowed? 1
> [   27.273810] ath10k_pci 0000:01:00.0: WMI_UPDATE_STATS_EVENTID
>
> It seems to start up in VHT80 mode and when it peers with Node B it 
> thinks Node B is also in VHT80 mode and ping works.
>
> 4. Beacons are sent at 6 Mb/s basic rate and unicast QoS Data is sent 
> with three spatial streams. Attached is the full pcap of the experiment.
>
> Thank you for looking into this!
>
> ~Benjamin
>
> On 12/05/2016 11:24 AM, Nagarajan, Ashok Raj wrote:
>> 0x009A4577 0x00955B31
>>
>> Benjamin, Thanks for the logs.
>> Quick questions to further debug the issue here,
>>
>> 1. Is this issue seen every time you start sending data traffic?
>> 2. Issue seen with older firmwares? (FYR, 
>> http://linuxwireless.org/en/users/Drivers/ath10k/firmware/ )
>> 3. Could you please share the dmesg from your device after enabling 
>> MAC and WMI logs in ath10k driver
>>     To enable debug logs please see 
>> http://linuxwireless.org/en/users/Drivers/ath10k/debug/
>> 4. Do you know what is the Number of Spatial Streams seen in mesh 
>> beacons and in mesh data packet?
>>
>> Thanks,
>> Ashok
>
