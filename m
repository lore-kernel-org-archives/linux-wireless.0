Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:37713 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbZIBOcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 10:32:22 -0400
Message-ID: <4A9E820F.5020702@csail.mit.edu>
Date: Wed, 02 Sep 2009 10:32:47 -0400
From: Michael Kaminsky <kaminsky@csail.mit.edu>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: phy0: release an RX reorder frame due to timeout on earlier frames
References: <4A9D7E79.6090000@csail.mit.edu> <69e28c910909011441l411bc8a1xcc968ce8c220b422@mail.gmail.com>
In-Reply-To: <69e28c910909011441l411bc8a1xcc968ce8c220b422@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2009 05:41 PM, Gábor Stefanik wrote:
> On Tue, Sep 1, 2009 at 10:05 PM, Michael Kaminsky<kaminsky@csail.mit.edu> wrote:
>> I'm running a git checkout of iwlwifi-2.6.git from around Aug. 10
>> (d229b68..).  I filed a bug report at
>>
>>  http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2076
>>
>> and I was asked to post my situation to this list.
>
> Try also enabling iwlwifi debugging - enable CONFIG_IWLWIFI_DEBUG,
> then load iwlagn with modparam "debug=0x43fff".

Okay.  I'm including two kernel log excerpts below with this debugging
output.  The two logs represent two different instances of the bug
(module was reloaded in-between).  In both cases the network stopped
working until re-association.

-- [dmesg log #1] ------------------------------------------------------

[...]
[419748.436690] ieee80211 phy0: I iwl_mac_tx leave
[419748.436856] ieee80211 phy0: I iwl_mac_tx enter
[419748.436858] ieee80211 phy0: I iwl_mac_tx leave
[419748.437068] ieee80211 phy0: I iwl_mac_tx enter
[419748.437070] ieee80211 phy0: I iwl_mac_tx leave
[419748.437209] ieee80211 phy0: I iwl_mac_tx enter
[419748.437212] ieee80211 phy0: I iwl_mac_tx leave
[419748.449145] ieee80211 phy0: U iwl_bss_info_changed changes = 0x10
[419748.449147] ieee80211 phy0: U iwl_ht_conf enter: 
[419748.449149] ieee80211 phy0: U iwl_ht_conf leave
[419748.449151] ieee80211 phy0: U iwl_set_rxon_chain rx_chain=0x7C0E active=3 idle=3
[419748.449153] ieee80211 phy0: U iwl_bss_info_changed Changes (0x10) while associated
[419748.449155] ieee80211 phy0: U iwl5000_send_rxon_assoc Using current RXON_ASSOC.  Not resending.
[419748.449157] ieee80211 phy0: U iwl_bss_info_changed leave
[419748.476569] ieee80211 phy0: I iwl_mac_tx enter
[419748.476574] ieee80211 phy0: I iwl_mac_tx leave
[419748.652606] ieee80211 phy0: I iwl_mac_tx enter
[419748.652614] ieee80211 phy0: I iwl_mac_tx leave
[419748.653826] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x048F, 28 bytes at 143[15]:4
[419748.653855] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419748.697290] ieee80211 phy0: I iwl_mac_tx enter
[419748.697298] ieee80211 phy0: I iwl_mac_tx leave
[419748.858631] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0490, 28 bytes at 144[16]:4
[419748.858699] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419748.952598] ieee80211 phy0: I iwl_mac_tx enter
[419748.952607] ieee80211 phy0: I iwl_mac_tx leave
[419749.101071] ieee80211 phy0: I iwl_mac_tx enter
[419749.101078] ieee80211 phy0: I iwl_mac_tx leave
[419749.137538] __ratelimit: 16 callbacks suppressed
[419749.137540] phy0: release an RX reorder frame due to timeout on earlier frames
[419749.137544] phy0: release an RX reorder frame due to timeout on earlier frames
[419749.137546] phy0: release an RX reorder frame due to timeout on earlier frames
[419749.137548] phy0: release an RX reorder frame due to timeout on earlier frames
[419749.137550] phy0: release an RX reorder frame due to timeout on earlier frames
[419749.165816] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0491, 12 bytes at 145[17]:4
[419749.165862] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[419749.464587] ieee80211 phy0: I iwl_mac_tx enter
[419749.464596] ieee80211 phy0: I iwl_mac_tx leave
[419749.677846] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0492, 28 bytes at 146[18]:4
[419749.677897] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419749.996606] ieee80211 phy0: I iwl_mac_tx enter
[419749.996613] ieee80211 phy0: I iwl_mac_tx leave
[419750.100082] ieee80211 phy0: U iwl_mac_hw_scan enter
[419750.100086] ieee80211 phy0: U iwl_scan_initiate Starting scan...
[419750.100090] ieee80211 phy0: U iwl_mac_hw_scan leave
[419750.100114] ieee80211 phy0: U iwl_bg_request_scan Scanning while associated...
[419750.100117] ieee80211 phy0: U iwl_bg_request_scan suspend_time 0x400000 beacon interval 100
[419750.100119] ieee80211 phy0: U iwl_bg_request_scan Kicking off active scan
[419750.100122] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=1 prob=0x1 [ACTIVE 33]
[419750.100124] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=2 prob=0x1 [ACTIVE 33]
[419750.100127] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=3 prob=0x1 [ACTIVE 33]
[419750.100129] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=4 prob=0x1 [ACTIVE 33]
[419750.100131] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=5 prob=0x1 [ACTIVE 33]
[419750.100134] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=6 prob=0x1 [ACTIVE 33]
[419750.100136] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=7 prob=0x1 [ACTIVE 33]
[419750.100138] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=8 prob=0x1 [ACTIVE 33]
[419750.100140] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=9 prob=0x1 [ACTIVE 33]
[419750.100142] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=10 prob=0x1 [ACTIVE 33]
[419750.100145] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=11 prob=0x1 [ACTIVE 33]
[419750.100147] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=12 prob=0x0 [PASSIVE 88]
[419750.100149] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=13 prob=0x0 [PASSIVE 88]
[419750.100151] ieee80211 phy0: U iwl_get_channels_for_scan total channels to scan 13 
[419750.100156] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4493, 995 bytes at 147[32]:4
[419750.100484] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x00000000:473DBB0F) - 1 (beacon timer 167859441)
[419750.135098] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF: 0x00000000:473E423B) - 9 elapsed=34604 usec (52996ms since last)
[419750.136883] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x00000000:473E4941) - 1 (beacon timer 167823039)
[419750.170736] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF: 0x00000000:473ECD56) - 4 elapsed=33813 usec (36ms since last)
[419750.172548] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0494, 12 bytes at 148[20]:4
[419750.172719] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[419750.294253] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x00000000:4740AFD7) - 1 (beacon timer 176259113)
[419750.328045] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF: 0x00000000:474133E4) - 2 elapsed=33805 usec (156ms since last)
[419750.329854] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x00000000:47413AEA) - 1 (beacon timer 176223510)
[419750.363667] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF: 0x00000000:4741BEF9) - 9 elapsed=33807 usec (36ms since last)
[419750.488584] ieee80211 phy0: I iwl_mac_tx enter
[419750.488593] ieee80211 phy0: I iwl_mac_tx leave
[419750.498979] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x00000000:4743CFA6) - 1 (beacon timer 184647770)
[419750.532808] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF: 0x00000000:474453AD) - 7 elapsed=33799 usec (172ms since last)
[419750.534600] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x00000000:47445AB2) - 1 (beacon timer 184612174)
[419750.545772] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF: 0x00000000:47448654) - 0 elapsed=11170 usec (12ms since last)
[419750.547578] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x00000000:47448D59) - 1 (beacon timer 184599207)
[419750.559699] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF: 0x00000000:4744BCBB) - 0 elapsed=12130 usec (12ms since last)
[419750.703804] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x00000000:4746EFA5) - 1 (beacon timer 193036378)
[419750.715170] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF: 0x00000000:47471C0B) - 1 elapsed=11366 usec (156ms since last)
[419750.716948] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x00000000:47472312) - 1 (beacon timer 193023214)
[419750.751089] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF: 0x00000000:4747A856) - 4 elapsed=34116 usec (36ms since last)
[419750.752870] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0x00000000:4747AF5D) - 1 (beacon timer 192987299)
[419750.786700] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF: 0x00000000:47483374) - 24 elapsed=33815 usec (36ms since last)
[419750.908812] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0x00000000:474A1096) - 1 (beacon timer 201424746)
[419750.920075] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF: 0x00000000:474A3C7C) - 1 elapsed=11238 usec (132ms since last)
[419750.997849] phy0: release an RX reorder frame due to timeout on earlier frames
[419750.997857] phy0: release an RX reorder frame due to timeout on earlier frames
[419751.113406] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 12 [802.11bg] (TSF: 0x00000000:474D2FB4) - 1 (beacon timer 209813580)
[419751.205008] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 12 [802.11bg] (TSF: 0x00000000:474E9575) - 4 elapsed=91585 usec (288ms since last)
[419751.318181] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 13 [802.11bg] (TSF: 0x00000000:47504FA6) - 1 (beacon timer 218202202)
[419751.408373] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 13 [802.11bg] (TSF: 0x00000000:4751AFD1) - 0 elapsed=90155 usec (200ms since last)
[419751.410350] ieee80211 phy0: I iwl_rx_scan_complete_notif Scan complete: 13 channels (TSF 0x4751B793:00000000) - 1
[419751.410352] ieee80211 phy0: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 1312ms
[419751.410367] ieee80211 phy0: U iwl_bg_request_scan Scanning while associated...
[419751.410369] ieee80211 phy0: U iwl_bg_request_scan suspend_time 0x400000 beacon interval 100
[419751.410371] ieee80211 phy0: U iwl_bg_request_scan Kicking off active scan
[419751.410375] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=36 prob=0x0 [PASSIVE 88]
[419751.410378] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=40 prob=0x0 [PASSIVE 88]
[419751.410380] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=44 prob=0x0 [PASSIVE 88]
[419751.410382] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=48 prob=0x0 [PASSIVE 88]
[419751.410384] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=52 prob=0x0 [PASSIVE 88]
[419751.410386] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=56 prob=0x0 [PASSIVE 88]
[419751.410388] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=60 prob=0x0 [PASSIVE 88]
[419751.410390] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=64 prob=0x0 [PASSIVE 88]
[419751.410392] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=100 prob=0x0 [PASSIVE 88]
[419751.410395] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=104 prob=0x0 [PASSIVE 88]
[419751.410397] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=108 prob=0x0 [PASSIVE 88]
[419751.410399] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=112 prob=0x0 [PASSIVE 88]
[419751.410401] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=116 prob=0x0 [PASSIVE 88]
[419751.410403] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=120 prob=0x0 [PASSIVE 88]
[419751.410405] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=124 prob=0x0 [PASSIVE 88]
[419751.410407] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=128 prob=0x0 [PASSIVE 88]
[419751.410410] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=132 prob=0x0 [PASSIVE 88]
[419751.410412] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=136 prob=0x0 [PASSIVE 88]
[419751.410414] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=140 prob=0x0 [PASSIVE 88]
[419751.410416] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=149 prob=0x0 [PASSIVE 88]
[419751.410418] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=153 prob=0x0 [PASSIVE 88]
[419751.410420] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=157 prob=0x0 [PASSIVE 88]
[419751.410422] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=161 prob=0x0 [PASSIVE 88]
[419751.410425] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=165 prob=0x0 [PASSIVE 88]
[419751.410426] ieee80211 phy0: U iwl_get_channels_for_scan total channels to scan 24 
[419751.410431] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4495, 1127 bytes at 149[32]:4
[419751.420573] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x00000000:4751DFAA) - 1 (beacon timer 222396502)
[419751.625487] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x00000000:4754FFF3) - 1 (beacon timer 230785037)
[419751.715633] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF: 0x00000000:47566010) - 1 elapsed=90141 usec (308ms since last)
[419751.788612] ieee80211 phy0: I iwl_mac_tx enter
[419751.788621] ieee80211 phy0: I iwl_mac_tx leave
[419751.830235] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x00000000:47581FC3) - 1 (beacon timer 239173693)
[419751.866490] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF: 0x00000000:4758AD5F) - 2 elapsed=36252 usec (152ms since last)
[419751.931606] phy0: release an RX reorder frame due to timeout on earlier frames
[419751.931613] phy0: release an RX reorder frame due to timeout on earlier frames
[419751.931615] phy0: release an RX reorder frame due to timeout on earlier frames
[419752.035080] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x00000000:475B4007) - 1 (beacon timer 247562233)
[419752.067194] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF: 0x00000000:475BBD5C) - 13 elapsed=32085 usec (200ms since last)
[419752.239836] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x00000000:475E5FC3) - 1 (beacon timer 255950909)
[419752.267293] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF: 0x00000000:475ECB0E) - 7 elapsed=27467 usec (200ms since last)
[419752.444740] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x00000000:4761804D) - 1 (beacon timer 264339379)
[419752.468452] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF: 0x00000000:4761DCBD) - 2 elapsed=23664 usec (200ms since last)
[419752.536536] ieee80211 phy0: I iwl_mac_tx enter
[419752.536544] ieee80211 phy0: I iwl_mac_tx leave
[419752.652200] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x00000000:4764AA90) - 1 (beacon timer 272725360)
[419752.742350] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF: 0x00000000:47660AAA) - 0 elapsed=90138 usec (276ms since last)
[419752.854204] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x00000000:4767BFC8) - 1 (beacon timer 281116728)
[419752.944382] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF: 0x00000000:47691FDE) - 0 elapsed=90134 usec (200ms since last)
[419753.059067] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x00000000:476ADFFF) - 1 (beacon timer 289505280)
[419753.149225] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF: 0x00000000:476C4016) - 0 elapsed=90135 usec (208ms since last)
[419753.265867] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 100 [802.11a] (TSF: 0x00000000:476E07B3) - 1 (beacon timer 297891917)
[419753.356015] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 100 [802.11a] (TSF: 0x00000000:476F67CB) - 0 elapsed=90136 usec (204ms since last)
[419753.468646] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 104 [802.11a] (TSF: 0x00000000:47711FD3) - 1 (beacon timer 306282541)
[419753.558800] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 104 [802.11a] (TSF: 0x00000000:47727FED) - 0 elapsed=90138 usec (204ms since last)
[419753.673454] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 108 [802.11a] (TSF: 0x00000000:47743FD3) - 1 (beacon timer 314671149)
[419753.763600] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 108 [802.11a] (TSF: 0x00000000:47759FEC) - 0 elapsed=90137 usec (204ms since last)
[419753.878248] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 112 [802.11a] (TSF: 0x00000000:47775FC2) - 1 (beacon timer 323059774)
[419753.968390] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 112 [802.11a] (TSF: 0x00000000:4778BFDF) - 0 elapsed=90141 usec (204ms since last)
[419754.083054] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 116 [802.11a] (TSF: 0x00000000:477A7FCD) - 1 (beacon timer 331448370)
[419754.173158] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 116 [802.11a] (TSF: 0x00000000:477BDFE7) - 0 elapsed=90138 usec (208ms since last)
[419754.287858] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 120 [802.11a] (TSF: 0x00000000:477D9FF3) - 1 (beacon timer 339836941)
[419754.378033] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 120 [802.11a] (TSF: 0x00000000:477F000E) - 0 elapsed=90139 usec (204ms since last)
[419754.492681] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 124 [802.11a] (TSF: 0x00000000:4780BFEE) - 1 (beacon timer 348225554)
[419754.582811] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 124 [802.11a] (TSF: 0x00000000:4782200E) - 0 elapsed=90144 usec (204ms since last)
[419754.697538] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 128 [802.11a] (TSF: 0x00000000:4783E021) - 1 (beacon timer 356614111)
[419754.787644] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 128 [802.11a] (TSF: 0x00000000:47854040) - 0 elapsed=90143 usec (204ms since last)
[419754.902388] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 132 [802.11a] (TSF: 0x00000000:47870057) - 1 (beacon timer 365002665)
[419754.992542] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 132 [802.11a] (TSF: 0x00000000:47886074) - 0 elapsed=90141 usec (208ms since last)
[419755.003465] __ratelimit: 9 callbacks suppressed
[419755.003467] phy0: release an RX reorder frame due to timeout on earlier frames
[419755.107217] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 136 [802.11a] (TSF: 0x00000000:478A208F) - 1 (beacon timer 373391217)
[419755.197389] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 136 [802.11a] (TSF: 0x00000000:478B80A9) - 0 elapsed=90138 usec (204ms since last)
[419755.312120] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 140 [802.11a] (TSF: 0x00000000:478D40DB) - 1 (beacon timer 381779749)
[419755.372608] ieee80211 phy0: I iwl_mac_tx enter
[419755.372616] ieee80211 phy0: I iwl_mac_tx leave
[419755.402268] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 140 [802.11a] (TSF: 0x00000000:478EA0FB) - 0 elapsed=90144 usec (204ms since last)
[419755.519877] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0x00000000:47906C63) - 1 (beacon timer 390165405)
[419755.563987] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF: 0x00000000:479118AF) - 2 elapsed=44108 usec (160ms since last)
[419755.721800] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0x00000000:4793812B) - 1 (beacon timer 398556885)
[419755.798656] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF: 0x00000000:4794AD69) - 2 elapsed=76862 usec (236ms since last)
[419755.822991] phy0: release an RX reorder frame due to timeout on earlier frames
[419755.926692] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0x00000000:4796A189) - 1 (beacon timer 406945399)
[419756.016807] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF: 0x00000000:479801A9) - 0 elapsed=90144 usec (220ms since last)
[419756.027996] phy0: release an RX reorder frame due to timeout on earlier frames
[419756.131569] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0x00000000:4799C1D4) - 1 (beacon timer 415333932)
[419756.221723] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF: 0x00000000:479B21F5) - 0 elapsed=90145 usec (204ms since last)
[419756.232957] phy0: release an RX reorder frame due to timeout on earlier frames
[419756.337045] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0x00000000:479CE478) - 1 (beacon timer 423721864)
[419756.427190] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF: 0x00000000:479E4492) - 0 elapsed=90138 usec (204ms since last)
[419756.429172] ieee80211 phy0: I iwl_rx_scan_complete_notif Scan complete: 24 channels (TSF 0x479E4C55:00000000) - 1
[419756.429174] ieee80211 phy0: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 5020ms
[419756.429176] ieee80211 phy0: I iwl_rx_scan_complete_notif Setting scan to off
[419756.429178] ieee80211 phy0: I iwl_rx_scan_complete_notif Scan took 6332ms
[419756.429186] ieee80211 phy0: U iwl_bg_scan_completed SCAN complete scan
[419756.429191] ieee80211 phy0: U iwl_mac_config enter to channel 1 changed 0x40
[419756.429195] ieee80211 phy0: U iwl_set_rxon_chain rx_chain=0x7C0E active=3 idle=3
[419756.429197] ieee80211 phy0: U iwl_mac_config Not re-sending same RXON configuration.
[419756.429199] ieee80211 phy0: U iwl_mac_config leave
[419756.429206] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x0496, 8 bytes at 150[22]:4
[419756.429448] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[419756.429505] ieee80211 phy0: I iwl_mac_tx enter
[419756.429510] ieee80211 phy0: I iwl_mac_tx leave
[419756.436866] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0497, 28 bytes at 151[23]:4
[419756.436898] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419756.539267] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0498, 28 bytes at 152[24]:4
[419756.539314] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419756.632551] ieee80211 phy0: I iwl_mac_tx enter
[419756.632561] ieee80211 phy0: I iwl_mac_tx leave
[419756.641604] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0499, 28 bytes at 153[25]:4
[419756.641651] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419756.642782] phy0: release an RX reorder frame due to timeout on earlier frames
[419756.851571] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x049A, 28 bytes at 154[26]:4
[419756.851657] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419757.051405] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x049B, 28 bytes at 155[27]:4
[419757.051451] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419757.153752] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x049C, 28 bytes at 156[28]:4
[419757.153797] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419757.769618] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x049D, 28 bytes at 157[29]:4
[419757.771622] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419758.075584] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x049E, 28 bytes at 158[30]:4
[419758.075635] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419758.792572] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x049F, 28 bytes at 159[31]:4
[419758.792609] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419759.816645] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A0, 28 bytes at 160[0]:4
[419759.816684] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419760.021462] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A1, 28 bytes at 161[1]:4
[419760.021492] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419760.122666] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A2, 28 bytes at 162[2]:4
[419760.122736] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419760.226271] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A3, 28 bytes at 163[3]:4
[419760.226338] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419760.327428] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A4, 28 bytes at 164[4]:4
[419760.327460] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419760.431064] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A5, 28 bytes at 165[5]:4
[419760.431137] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419760.941852] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A6, 28 bytes at 166[6]:4
[419760.941904] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419761.045427] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A7, 28 bytes at 167[7]:4
[419761.045479] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419761.455068] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A8, 28 bytes at 168[8]:4
[419761.455141] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419761.900980] ieee80211 phy0: I iwl_mac_tx enter
[419761.900988] ieee80211 phy0: I iwl_mac_tx leave
[419762.540589] ieee80211 phy0: I iwl_mac_tx enter
[419762.540597] ieee80211 phy0: I iwl_mac_tx leave
[419763.094447] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04A9, 28 bytes at 169[9]:4
[419763.094515] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419764.527118] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[419764.824589] ieee80211 phy0: I iwl_mac_tx enter
[419764.824597] ieee80211 phy0: I iwl_mac_tx leave
[419764.824804] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04AA, 92 bytes at 170[10]:4
[419764.824868] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419766.904916] ieee80211 phy0: I iwl_mac_tx enter
[419766.904923] ieee80211 phy0: I iwl_mac_tx leave
[419767.290633] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04AB, 28 bytes at 171[11]:4
[419767.290683] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419771.908076] ieee80211 phy0: I iwl_mac_tx enter
[419771.908083] ieee80211 phy0: I iwl_mac_tx leave
[419771.910682] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04AC, 92 bytes at 172[12]:4
[419771.910758] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419773.741837] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04AD, 28 bytes at 173[13]:4
[419773.741888] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419773.844297] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04AE, 28 bytes at 174[14]:4
[419773.844343] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419773.946670] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04AF, 28 bytes at 175[15]:4
[419773.946738] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419774.151454] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B0, 28 bytes at 176[16]:4
[419774.151499] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419774.663454] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B1, 28 bytes at 177[17]:4
[419774.663504] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419775.380272] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B2, 28 bytes at 178[18]:4
[419775.380340] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419776.406760] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B3, 28 bytes at 179[19]:4
[419776.408677] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419776.876619] ieee80211 phy0: I iwl_mac_tx enter
[419776.876627] ieee80211 phy0: I iwl_mac_tx leave
[419776.876865] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04B4, 92 bytes at 180[20]:4
[419776.876924] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419776.913092] ieee80211 phy0: I iwl_mac_tx enter
[419776.913097] ieee80211 phy0: I iwl_mac_tx leave
[419777.018648] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B5, 28 bytes at 181[21]:4
[419777.018698] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419777.530664] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B6, 28 bytes at 182[22]:4
[419777.530732] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419777.735452] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B7, 28 bytes at 183[23]:4
[419777.735498] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419777.940292] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B8, 28 bytes at 184[24]:4
[419777.940362] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419778.042678] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04B9, 28 bytes at 185[25]:4
[419778.042747] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419778.145095] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04BA, 28 bytes at 186[26]:4
[419778.145170] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419778.452289] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04BB, 28 bytes at 187[27]:4
[419778.452338] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419778.861870] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04BC, 28 bytes at 188[28]:4
[419778.861920] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419779.066664] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04BD, 28 bytes at 189[29]:4
[419779.066731] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419780.397866] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04BE, 28 bytes at 190[30]:4
[419780.397914] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419781.208574] ieee80211 phy0: I iwl_mac_tx enter
[419781.208585] ieee80211 phy0: I iwl_mac_tx leave
[419781.218092] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04BF, 92 bytes at 191[31]:4
[419781.218160] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419781.626745] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C0, 28 bytes at 192[0]:4
[419781.626780] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419781.916987] ieee80211 phy0: I iwl_mac_tx enter
[419781.916995] ieee80211 phy0: I iwl_mac_tx leave
[419781.917254] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C1, 92 bytes at 193[1]:4
[419781.917331] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419782.343476] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C2, 28 bytes at 194[2]:4
[419782.343543] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419783.060282] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C3, 28 bytes at 195[3]:4
[419783.060334] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419783.162669] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C4, 28 bytes at 196[4]:4
[419783.162743] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419784.596266] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C5, 28 bytes at 197[5]:4
[419784.596304] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419785.102055] ieee80211 phy0: I iwl_mac_tx enter
[419785.102064] ieee80211 phy0: I iwl_mac_tx leave
[419785.115191] ieee80211 phy0: I iwl_mac_tx enter
[419785.115196] ieee80211 phy0: I iwl_mac_tx leave
[419785.380069] ieee80211 phy0: I iwl_mac_tx enter
[419785.380078] ieee80211 phy0: I iwl_mac_tx leave
[419785.392058] ieee80211 phy0: I iwl_mac_tx enter
[419785.392063] ieee80211 phy0: I iwl_mac_tx leave
[419785.940079] ieee80211 phy0: I iwl_mac_tx enter
[419785.940086] ieee80211 phy0: I iwl_mac_tx leave
[419785.952060] ieee80211 phy0: I iwl_mac_tx enter
[419785.952065] ieee80211 phy0: I iwl_mac_tx leave
[419786.208586] ieee80211 phy0: I iwl_mac_tx enter
[419786.208594] ieee80211 phy0: I iwl_mac_tx leave
[419786.816599] ieee80211 phy0: I iwl_mac_tx enter
[419786.816607] ieee80211 phy0: I iwl_mac_tx leave
[419786.921618] ieee80211 phy0: I iwl_mac_tx enter
[419786.921625] ieee80211 phy0: I iwl_mac_tx leave
[419786.922633] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C6, 92 bytes at 198[6]:4
[419786.922690] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419787.060693] ieee80211 phy0: I iwl_mac_tx enter
[419787.060700] ieee80211 phy0: I iwl_mac_tx leave
[419787.061565] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C7, 92 bytes at 199[7]:4
[419787.061628] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419787.072712] ieee80211 phy0: I iwl_mac_tx enter
[419787.072722] ieee80211 phy0: I iwl_mac_tx leave
[419787.208549] ieee80211 phy0: I iwl_mac_tx enter
[419787.208565] ieee80211 phy0: I iwl_mac_tx leave
[419787.565884] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C8, 28 bytes at 200[8]:4
[419787.565953] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419788.077882] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C9, 28 bytes at 201[9]:4
[419788.077951] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419788.208593] ieee80211 phy0: I iwl_mac_tx enter
[419788.208601] ieee80211 phy0: I iwl_mac_tx leave
[419789.304610] ieee80211 phy0: I iwl_mac_tx enter
[419789.304619] ieee80211 phy0: I iwl_mac_tx leave
[419790.304605] ieee80211 phy0: I iwl_mac_tx enter
[419790.304612] ieee80211 phy0: I iwl_mac_tx leave
[419791.306050] ieee80211 phy0: I iwl_mac_tx enter
[419791.306057] ieee80211 phy0: I iwl_mac_tx leave
[419791.457060] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CA, 28 bytes at 202[10]:4
[419791.457106] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419792.481167] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CB, 28 bytes at 203[11]:4
[419792.481213] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419792.481458] phy0: release an RX reorder frame due to timeout on earlier frames
[419792.481469] phy0: release an RX reorder frame due to timeout on earlier frames
[419793.402680] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CC, 28 bytes at 204[12]:4
[419793.402748] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419793.505057] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CD, 28 bytes at 205[13]:4
[419793.505124] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419793.784601] ieee80211 phy0: I iwl_mac_tx enter
[419793.784608] ieee80211 phy0: I iwl_mac_tx leave
[419794.784649] ieee80211 phy0: I iwl_mac_tx enter
[419794.784656] ieee80211 phy0: I iwl_mac_tx leave
[419794.784856] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04CE, 92 bytes at 206[14]:4
[419794.784919] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419795.245874] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CF, 28 bytes at 207[15]:4
[419795.245925] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419795.348281] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D0, 28 bytes at 208[16]:4
[419795.348331] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419795.475168] ieee80211 phy0: I iwl_mac_tx enter
[419795.475175] ieee80211 phy0: I iwl_mac_tx leave
[419795.475389] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D1, 92 bytes at 209[17]:4
[419795.475458] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419795.784605] ieee80211 phy0: I iwl_mac_tx enter
[419795.784613] ieee80211 phy0: I iwl_mac_tx leave
[419796.167493] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D2, 28 bytes at 210[18]:4
[419796.167564] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419796.269863] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D3, 28 bytes at 211[19]:4
[419796.269912] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419796.932860] ieee80211 phy0: I iwl_mac_tx enter
[419796.932868] ieee80211 phy0: I iwl_mac_tx leave
[419796.937177] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D4, 92 bytes at 212[20]:4
[419796.937256] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419797.193551] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D5, 28 bytes at 213[21]:4
[419797.193619] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419797.932957] ieee80211 phy0: I iwl_mac_tx enter
[419797.932965] ieee80211 phy0: I iwl_mac_tx leave
[419798.113145] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D6, 28 bytes at 214[22]:4
[419798.113192] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419798.933048] ieee80211 phy0: I iwl_mac_tx enter
[419798.933055] ieee80211 phy0: I iwl_mac_tx leave
[419799.546813] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D7, 28 bytes at 215[23]:4
[419799.546861] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419800.570695] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D8, 28 bytes at 216[24]:4
[419800.570762] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419800.980298] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D9, 28 bytes at 217[25]:4
[419800.980368] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419801.082702] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DA, 28 bytes at 218[26]:4
[419801.082776] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419801.185099] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DB, 28 bytes at 219[27]:4
[419801.185167] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419801.940065] ieee80211 phy0: I iwl_mac_tx enter
[419801.940071] ieee80211 phy0: I iwl_mac_tx leave
[419802.415937] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DC, 28 bytes at 220[28]:4
[419802.416015] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419802.936618] ieee80211 phy0: I iwl_mac_tx enter
[419802.936626] ieee80211 phy0: I iwl_mac_tx leave
[419803.028286] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DD, 28 bytes at 221[29]:4
[419803.028353] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419803.133191] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DE, 28 bytes at 222[30]:4
[419803.133242] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419803.242138] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DF, 28 bytes at 223[31]:4
[419803.242206] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419803.335543] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E0, 28 bytes at 224[0]:4
[419803.335594] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419803.540377] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E1, 28 bytes at 225[1]:4
[419803.540436] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419803.642699] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E2, 28 bytes at 226[2]:4
[419803.642767] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419803.746697] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E3, 28 bytes at 227[3]:4
[419803.746745] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419803.936601] ieee80211 phy0: I iwl_mac_tx enter
[419803.936607] ieee80211 phy0: I iwl_mac_tx leave
[419805.552540] ieee80211 phy0: I iwl_mac_tx enter
[419805.552548] ieee80211 phy0: I iwl_mac_tx leave
[419805.561657] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04E4, 92 bytes at 228[4]:4
[419805.561734] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419806.100292] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E5, 28 bytes at 229[5]:4
[419806.100361] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419806.202674] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E6, 28 bytes at 230[6]:4
[419806.202719] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419806.305094] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E7, 28 bytes at 231[7]:4
[419806.305161] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419806.407493] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E8, 28 bytes at 232[8]:4
[419806.407571] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419806.519720] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E9, 28 bytes at 233[9]:4
[419806.520709] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419806.552608] ieee80211 phy0: I iwl_mac_tx enter
[419806.552614] ieee80211 phy0: I iwl_mac_tx leave
[419806.612357] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EA, 28 bytes at 234[10]:4
[419806.612389] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419806.714707] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EB, 28 bytes at 235[11]:4
[419806.714775] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419806.817087] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EC, 28 bytes at 236[12]:4
[419806.817131] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419806.919516] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04ED, 28 bytes at 237[13]:4
[419806.919595] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419807.021884] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EE, 28 bytes at 238[14]:4
[419807.021955] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419807.124298] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EF, 28 bytes at 239[15]:4
[419807.124365] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419807.431501] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F0, 28 bytes at 240[16]:4
[419807.431570] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419807.552605] ieee80211 phy0: I iwl_mac_tx enter
[419807.552612] ieee80211 phy0: I iwl_mac_tx leave
[419808.660302] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F1, 28 bytes at 241[17]:4
[419808.660348] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419809.749536] ieee80211 phy0: I iwl_mac_tx enter
[419809.749545] ieee80211 phy0: I iwl_mac_tx leave
[419810.749488] ieee80211 phy0: I iwl_mac_tx enter
[419810.749497] ieee80211 phy0: I iwl_mac_tx leave
[419810.810715] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F2, 28 bytes at 242[18]:4
[419810.810810] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[419811.748072] ieee80211 phy0: I iwl_mac_tx enter
[419811.748080] ieee80211 phy0: I iwl_mac_tx leave
[419813.408645] ieee80211 phy0: I iwl_mac_tx enter
[419813.408653] ieee80211 phy0: I iwl_mac_tx leave
[419813.410781] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04F3, 92 bytes at 243[19]:4
[419813.410853] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[419814.408065] ieee80211 phy0: I iwl_mac_tx enter
[419814.408071] ieee80211 phy0: I iwl_mac_tx leave
[419814.599506] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F4, 28 bytes at 244[20]:4
[419814.599576] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)


-- [dmesg log #2] ------------------------------------------------------

[...]
[420810.468556] ieee80211 phy0: I iwl_mac_tx enter
[420810.468564] ieee80211 phy0: I iwl_mac_tx leave
[420810.468902] ieee80211 phy0: I iwl_mac_tx enter
[420810.468905] ieee80211 phy0: I iwl_mac_tx leave
[420810.513570] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C5, 28 bytes at 197[5]:4
[420810.513620] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420810.532038] ieee80211 phy0: I iwl_mac_tx enter
[420810.532041] ieee80211 phy0: I iwl_mac_tx leave
[420810.820771] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C6, 28 bytes at 198[6]:4
[420810.820820] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420811.537570] ieee80211 phy0: U iwl_bss_info_changed changes = 0x10
[420811.537601] ieee80211 phy0: U iwl_ht_conf enter: 
[420811.537603] ieee80211 phy0: U iwl_ht_conf leave
[420811.537606] ieee80211 phy0: U iwl_set_rxon_chain rx_chain=0x7C0E active=3 idle=3
[420811.537608] ieee80211 phy0: U iwl_bss_info_changed Changes (0x10) while associated
[420811.537610] ieee80211 phy0: U iwl5000_send_rxon_assoc Using current RXON_ASSOC.  Not resending.
[420811.537612] ieee80211 phy0: U iwl_bss_info_changed leave
[420811.645487] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C7, 28 bytes at 199[7]:4
[420811.645533] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420811.844801] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C8, 28 bytes at 200[8]:4
[420811.844871] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420813.069468] ieee80211 phy0: I iwl_mac_tx enter
[420813.069476] ieee80211 phy0: I iwl_mac_tx leave
[420813.105855] phy0: release an RX reorder frame due to timeout on earlier frames
[420813.105860] phy0: release an RX reorder frame due to timeout on earlier frames
[420813.105862] phy0: release an RX reorder frame due to timeout on earlier frames
[420813.105864] phy0: release an RX reorder frame due to timeout on earlier frames
[420813.105866] phy0: release an RX reorder frame due to timeout on earlier frames
[420813.105868] phy0: release an RX reorder frame due to timeout on earlier frames
[420813.105870] phy0: release an RX reorder frame due to timeout on earlier frames
[420813.105872] phy0: release an RX reorder frame due to timeout on earlier frames
[420813.296584] ieee80211 phy0: I iwl_mac_tx enter
[420813.296591] ieee80211 phy0: I iwl_mac_tx leave
[420813.752585] ieee80211 phy0: I iwl_mac_tx enter
[420813.752593] ieee80211 phy0: I iwl_mac_tx leave
[420814.404756] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04C9, 28 bytes at 201[9]:4
[420814.404808] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420814.507180] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CA, 28 bytes at 202[10]:4
[420814.508420] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420814.664584] ieee80211 phy0: I iwl_mac_tx enter
[420814.664592] ieee80211 phy0: I iwl_mac_tx leave
[420815.428766] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CB, 28 bytes at 203[11]:4
[420815.430244] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420816.145570] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CC, 28 bytes at 204[12]:4
[420816.146831] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420816.488588] ieee80211 phy0: I iwl_mac_tx enter
[420816.488596] ieee80211 phy0: I iwl_mac_tx leave
[420817.271953] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CD, 28 bytes at 205[13]:4
[420817.271999] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420817.681558] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CE, 28 bytes at 206[14]:4
[420817.681625] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420818.500777] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04CF, 28 bytes at 207[15]:4
[420818.502010] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420819.944192] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D0, 28 bytes at 208[16]:4
[420819.944260] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420819.992760] ieee80211 phy0: I iwl_mac_tx enter
[420819.992768] ieee80211 phy0: I iwl_mac_tx leave
[420819.992789] ieee80211 phy0: I iwl_mac_tx enter
[420819.992791] ieee80211 phy0: I iwl_mac_tx leave
[420820.136582] ieee80211 phy0: I iwl_mac_tx enter
[420820.136589] ieee80211 phy0: I iwl_mac_tx leave
[420820.139164] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D1, 28 bytes at 209[17]:4
[420820.139371] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420820.241569] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D2, 28 bytes at 210[18]:4
[420820.241643] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420820.288596] ieee80211 phy0: I iwl_mac_tx enter
[420820.288602] ieee80211 phy0: I iwl_mac_tx leave
[420820.880595] ieee80211 phy0: I iwl_mac_tx enter
[420820.880602] ieee80211 phy0: I iwl_mac_tx leave
[420820.881598] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D3, 92 bytes at 211[19]:4
[420820.881686] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420820.958359] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D4, 28 bytes at 212[20]:4
[420820.958430] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420821.060776] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D5, 28 bytes at 213[21]:4
[420821.060825] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420822.064599] ieee80211 phy0: I iwl_mac_tx enter
[420822.064608] ieee80211 phy0: I iwl_mac_tx leave
[420823.008448] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D6, 28 bytes at 214[22]:4
[420823.008533] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420823.518367] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D7, 28 bytes at 215[23]:4
[420823.518435] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420824.235271] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D8, 28 bytes at 216[24]:4
[420824.235337] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420824.337588] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04D9, 28 bytes at 217[25]:4
[420824.337617] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420824.432582] ieee80211 phy0: I iwl_mac_tx enter
[420824.432588] ieee80211 phy0: I iwl_mac_tx leave
[420826.078367] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DA, 28 bytes at 218[26]:4
[420826.078398] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420826.180803] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DB, 28 bytes at 219[27]:4
[420826.180873] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420826.590391] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DC, 28 bytes at 220[28]:4
[420826.590466] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420826.692778] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DD, 28 bytes at 221[29]:4
[420826.692827] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420826.795191] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DE, 28 bytes at 222[30]:4
[420826.795242] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420827.432602] ieee80211 phy0: I iwl_mac_tx enter
[420827.432610] ieee80211 phy0: I iwl_mac_tx leave
[420828.945568] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04DF, 28 bytes at 223[31]:4
[420828.945637] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420829.150370] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E0, 28 bytes at 224[0]:4
[420829.150421] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420829.168546] ieee80211 phy0: I iwl_mac_tx enter
[420829.168557] ieee80211 phy0: I iwl_mac_tx leave
[420829.457583] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E1, 28 bytes at 225[1]:4
[420829.457651] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420829.970733] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E2, 28 bytes at 226[2]:4
[420829.970812] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420831.403193] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E3, 28 bytes at 227[3]:4
[420831.403240] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420832.324790] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E4, 28 bytes at 228[4]:4
[420832.324841] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420832.939306] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E5, 28 bytes at 229[5]:4
[420832.940551] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420833.041599] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E6, 28 bytes at 230[6]:4
[420833.041670] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420834.168001] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E7, 28 bytes at 231[7]:4
[420834.168032] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420834.987173] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E8, 28 bytes at 232[8]:4
[420834.987241] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420835.703974] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04E9, 28 bytes at 233[9]:4
[420835.704018] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420835.908849] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EA, 28 bytes at 234[10]:4
[420835.908894] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420836.625582] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EB, 28 bytes at 235[11]:4
[420836.625650] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420836.933634] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EC, 28 bytes at 236[12]:4
[420836.934849] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420838.264009] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04ED, 28 bytes at 237[13]:4
[420838.264046] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420838.366379] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EE, 28 bytes at 238[14]:4
[420838.366456] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420838.640559] ieee80211 phy0: I iwl_mac_tx enter
[420838.640568] ieee80211 phy0: I iwl_mac_tx leave
[420839.390451] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04EF, 28 bytes at 239[15]:4
[420839.390485] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420839.902397] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F0, 28 bytes at 240[16]:4
[420839.902466] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420840.816600] ieee80211 phy0: I iwl_mac_tx enter
[420840.816609] ieee80211 phy0: I iwl_mac_tx leave
[420841.848003] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F1, 28 bytes at 241[17]:4
[420841.848037] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420842.024550] ieee80211 phy0: I iwl_mac_tx enter
[420842.024569] ieee80211 phy0: I iwl_mac_tx leave
[420842.974459] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F2, 28 bytes at 242[18]:4
[420842.974490] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420843.486420] ieee80211 phy0: U iwl_bss_info_changed changes = 0x10
[420843.486425] ieee80211 phy0: U iwl_ht_conf enter: 
[420843.486428] ieee80211 phy0: U iwl_ht_conf leave
[420843.486431] ieee80211 phy0: U iwl_set_rxon_chain rx_chain=0x7C0E active=3 idle=3
[420843.486435] ieee80211 phy0: U iwl_bss_info_changed Changes (0x10) while associated
[420843.486439] ieee80211 phy0: U iwl5000_send_rxon_assoc Using current RXON_ASSOC.  Not resending.
[420843.486442] ieee80211 phy0: U iwl_bss_info_changed leave
[420843.691190] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F3, 28 bytes at 243[19]:4
[420843.691262] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420843.714560] ieee80211 phy0: I iwl_mac_tx enter
[420843.714564] ieee80211 phy0: I iwl_mac_tx leave
[420843.727186] ieee80211 phy0: I iwl_mac_tx enter
[420843.727195] ieee80211 phy0: I iwl_mac_tx leave
[420843.952534] ieee80211 phy0: I iwl_mac_tx enter
[420843.952541] ieee80211 phy0: I iwl_mac_tx leave
[420843.952697] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04F4, 92 bytes at 244[20]:4
[420843.952759] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420844.100803] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F5, 28 bytes at 245[21]:4
[420844.100852] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420844.432585] ieee80211 phy0: I iwl_mac_tx enter
[420844.432592] ieee80211 phy0: I iwl_mac_tx leave
[420844.510384] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F6, 28 bytes at 246[22]:4
[420844.510452] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420845.022404] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F7, 28 bytes at 247[23]:4
[420845.022474] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420845.392595] ieee80211 phy0: I iwl_mac_tx enter
[420845.392602] ieee80211 phy0: I iwl_mac_tx leave
[420845.395921] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04F8, 92 bytes at 248[24]:4
[420845.395980] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420845.431994] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04F9, 28 bytes at 249[25]:4
[420845.432028] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420845.943985] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04FA, 28 bytes at 250[26]:4
[420845.944032] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420846.724582] ieee80211 phy0: I iwl_mac_tx enter
[420846.724590] ieee80211 phy0: I iwl_mac_tx leave
[420846.724781] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04FB, 92 bytes at 251[27]:4
[420846.724858] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420847.070396] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04FC, 28 bytes at 252[28]:4
[420847.070458] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420847.312584] ieee80211 phy0: I iwl_mac_tx enter
[420847.312591] ieee80211 phy0: I iwl_mac_tx leave
[420848.095571] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04FD, 28 bytes at 253[29]:4
[420848.096788] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420848.824910] ieee80211 phy0: I iwl_mac_tx enter
[420848.824919] ieee80211 phy0: I iwl_mac_tx leave
[420848.828990] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04FE, 92 bytes at 254[30]:4
[420848.829035] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420849.732806] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x04FF, 28 bytes at 255[31]:4
[420849.732854] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420849.835197] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0400, 28 bytes at 0[0]:4
[420849.835264] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420850.039988] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0401, 28 bytes at 1[1]:4
[420850.040036] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420850.347224] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0402, 28 bytes at 2[2]:4
[420850.347274] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420850.654396] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0403, 28 bytes at 3[3]:4
[420850.654464] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420850.756793] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0404, 28 bytes at 4[4]:4
[420850.756840] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420851.152585] ieee80211 phy0: I iwl_mac_tx enter
[420851.152594] ieee80211 phy0: I iwl_mac_tx leave
[420851.152760] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0405, 92 bytes at 5[5]:4
[420851.152824] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420851.824585] ieee80211 phy0: I iwl_mac_tx enter
[420851.824594] ieee80211 phy0: I iwl_mac_tx leave
[420852.724588] ieee80211 phy0: I iwl_mac_tx enter
[420852.724597] ieee80211 phy0: I iwl_mac_tx leave
[420853.419201] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0406, 28 bytes at 6[6]:4
[420853.419250] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420853.931212] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0407, 28 bytes at 7[7]:4
[420853.931280] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420854.647996] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0408, 28 bytes at 8[8]:4
[420854.648041] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420854.852804] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0409, 28 bytes at 9[9]:4
[420854.852854] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420854.955218] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040A, 28 bytes at 10[10]:4
[420854.955269] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420855.057694] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040B, 28 bytes at 11[11]:4
[420855.057763] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420855.262413] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040C, 28 bytes at 12[12]:4
[420855.262480] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420855.467220] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040D, 28 bytes at 13[13]:4
[420855.467288] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420855.876811] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040E, 28 bytes at 14[14]:4
[420855.876856] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420855.979201] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040F, 28 bytes at 15[15]:4
[420855.979251] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420856.091932] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0410, 28 bytes at 16[16]:4
[420856.091982] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420857.048554] ieee80211 phy0: I iwl_mac_tx enter
[420857.048570] ieee80211 phy0: I iwl_mac_tx leave
[420857.584597] ieee80211 phy0: I iwl_mac_tx enter
[420857.584605] ieee80211 phy0: I iwl_mac_tx leave
[420857.824587] ieee80211 phy0: I iwl_mac_tx enter
[420857.824601] ieee80211 phy0: I iwl_mac_tx leave
[420858.048578] ieee80211 phy0: I iwl_mac_tx enter
[420858.048586] ieee80211 phy0: I iwl_mac_tx leave
[420858.436821] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0411, 28 bytes at 17[17]:4
[420858.436889] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420858.832585] ieee80211 phy0: I iwl_mac_tx enter
[420858.832593] ieee80211 phy0: I iwl_mac_tx leave
[420859.022764] ieee80211 phy0: I iwl_mac_tx enter
[420859.022772] ieee80211 phy0: I iwl_mac_tx leave
[420859.022979] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0412, 92 bytes at 18[18]:4
[420859.023038] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420859.048529] ieee80211 phy0: I iwl_mac_tx enter
[420859.048538] ieee80211 phy0: I iwl_mac_tx leave
[420859.048707] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0413, 92 bytes at 19[19]:4
[420859.048769] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420859.051199] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0414, 28 bytes at 20[20]:4
[420859.051225] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420859.463434] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0415, 28 bytes at 21[21]:4
[420859.463501] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420859.972803] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0416, 28 bytes at 22[22]:4
[420859.972853] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420862.737607] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0417, 28 bytes at 23[23]:4
[420862.737652] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420863.659239] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0418, 28 bytes at 24[24]:4
[420863.659306] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420863.762684] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0419, 28 bytes at 25[25]:4
[420863.763892] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420863.864360] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x041A, 28 bytes at 26[26]:4
[420863.864440] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420864.729567] ieee80211 phy0: I iwl_mac_tx enter
[420864.729574] ieee80211 phy0: I iwl_mac_tx leave
[420865.297610] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x041B, 28 bytes at 27[27]:4
[420865.297678] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420865.400031] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x041C, 28 bytes at 28[28]:4
[420865.400101] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420865.728610] ieee80211 phy0: I iwl_mac_tx enter
[420865.728617] ieee80211 phy0: I iwl_mac_tx leave
[420866.219209] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x041D, 28 bytes at 29[29]:4
[420866.219256] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420866.321607] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x041E, 28 bytes at 30[30]:4
[420866.321653] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420866.729604] ieee80211 phy0: I iwl_mac_tx enter
[420866.729613] ieee80211 phy0: I iwl_mac_tx leave
[420866.740696] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x041F, 28 bytes at 31[31]:4
[420866.740726] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420867.448045] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0420, 28 bytes at 32[0]:4
[420867.448094] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420867.550406] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0421, 28 bytes at 33[1]:4
[420867.550453] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420867.736043] ieee80211 phy0: I iwl_mac_tx enter
[420867.736053] ieee80211 phy0: I iwl_mac_tx leave
[420867.755210] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0422, 28 bytes at 34[2]:4
[420867.755276] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420868.732613] ieee80211 phy0: I iwl_mac_tx enter
[420868.732621] ieee80211 phy0: I iwl_mac_tx leave
[420869.393612] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0423, 28 bytes at 35[3]:4
[420869.393643] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420869.732052] ieee80211 phy0: I iwl_mac_tx enter
[420869.732059] ieee80211 phy0: I iwl_mac_tx leave
[420870.724818] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0424, 28 bytes at 36[4]:4
[420870.724886] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420870.740036] ieee80211 phy0: I iwl_mac_tx enter
[420870.740045] ieee80211 phy0: I iwl_mac_tx leave
[420870.929628] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0425, 28 bytes at 37[5]:4
[420870.929683] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420871.236829] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0426, 28 bytes at 38[6]:4
[420871.236899] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420871.736617] ieee80211 phy0: I iwl_mac_tx enter
[420871.736625] ieee80211 phy0: I iwl_mac_tx leave
[420871.736783] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0427, 92 bytes at 39[7]:4
[420871.736850] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420871.817903] ieee80211 phy0: I iwl_mac_tx enter
[420871.817914] ieee80211 phy0: I iwl_mac_tx leave
[420871.851216] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0428, 28 bytes at 40[8]:4
[420871.851284] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420872.736614] ieee80211 phy0: I iwl_mac_tx enter
[420872.736621] ieee80211 phy0: I iwl_mac_tx leave
[420872.736776] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0429, 92 bytes at 41[9]:4
[420872.736844] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[420873.080037] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x042A, 28 bytes at 42[10]:4
[420873.080105] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420873.182401] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x042B, 28 bytes at 43[11]:4
[420873.182469] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420873.284840] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x042C, 28 bytes at 44[12]:4
[420873.284880] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420873.387216] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x042D, 28 bytes at 45[13]:4
[420873.387293] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420873.744048] ieee80211 phy0: I iwl_mac_tx enter
[420873.744056] ieee80211 phy0: I iwl_mac_tx leave
[420874.740568] ieee80211 phy0: I iwl_mac_tx enter
[420874.740575] ieee80211 phy0: I iwl_mac_tx leave
[420875.435201] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x042E, 28 bytes at 46[14]:4
[420875.435247] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420875.537619] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x042F, 28 bytes at 47[15]:4
[420875.537688] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420875.740607] ieee80211 phy0: I iwl_mac_tx enter
[420875.740615] ieee80211 phy0: I iwl_mac_tx leave
[420875.742506] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0430, 28 bytes at 48[16]:4
[420875.742684] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420876.154148] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0431, 28 bytes at 49[17]:4
[420876.154216] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420876.254405] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0432, 28 bytes at 50[18]:4
[420876.254449] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420876.664001] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0433, 28 bytes at 51[19]:4
[420876.664049] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420876.748095] ieee80211 phy0: I iwl_mac_tx enter
[420876.748104] ieee80211 phy0: I iwl_mac_tx leave
[420876.766429] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0434, 28 bytes at 52[20]:4
[420876.766457] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420877.744557] ieee80211 phy0: I iwl_mac_tx enter
[420877.744565] ieee80211 phy0: I iwl_mac_tx leave
[420877.892821] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0435, 28 bytes at 53[21]:4
[420877.892868] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420878.404846] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0436, 28 bytes at 54[22]:4
[420878.404892] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420878.744604] ieee80211 phy0: I iwl_mac_tx enter
[420878.744611] ieee80211 phy0: I iwl_mac_tx leave
[420878.814428] ieee80211 phy0: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0437, 28 bytes at 55[23]:4
[420878.814495] ieee80211 phy0: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[420879.093970] ieee80211 phy0: U iwl_mac_hw_scan enter
[420879.093974] ieee80211 phy0: U iwl_scan_initiate Starting scan...
[420879.093978] ieee80211 phy0: U iwl_mac_hw_scan leave
[420879.093996] ieee80211 phy0: U iwl_bg_request_scan Scanning while associated...
[420879.093998] ieee80211 phy0: U iwl_bg_request_scan suspend_time 0x400000 beacon interval 100
[420879.094000] ieee80211 phy0: U iwl_bg_request_scan Kicking off active scan
[420879.094003] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=1 prob=0x3 [ACTIVE 36]
[420879.094006] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=2 prob=0x3 [ACTIVE 36]
[420879.094008] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=3 prob=0x3 [ACTIVE 36]
[420879.094010] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=4 prob=0x3 [ACTIVE 36]
[420879.094012] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=5 prob=0x3 [ACTIVE 36]
[420879.094014] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=6 prob=0x3 [ACTIVE 36]
[420879.094016] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=7 prob=0x3 [ACTIVE 36]
[420879.094018] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=8 prob=0x3 [ACTIVE 36]
[420879.094020] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=9 prob=0x3 [ACTIVE 36]
[420879.094022] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=10 prob=0x3 [ACTIVE 36]
[420879.094024] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=11 prob=0x3 [ACTIVE 36]
[420879.094027] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=12 prob=0x2 [PASSIVE 88]
[420879.094029] ieee80211 phy0: U iwl_get_channels_for_scan Scanning ch=13 prob=0x2 [PASSIVE 88]
[420879.094031] ieee80211 phy0: U iwl_get_channels_for_scan total channels to scan 13 
[420879.094036] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4438, 995 bytes at 56[32]:4
[420879.123741] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x00000000:195DD03A) - 1 (beacon timer 3435233222)
[420879.160592] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF: 0x00000000:195E6041) - 5 elapsed=36871 usec (73776ms since last)
[420879.162418] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x00000000:195E674D) - 1 (beacon timer 3435194547)
[420879.199307] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF: 0x00000000:195EF765) - 6 elapsed=36888 usec (36ms since last)
[420879.328541] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x00000000:1960F038) - 1 (beacon timer 3443621831)
[420879.340643] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF: 0x00000000:19611F7E) - 1 elapsed=12102 usec (144ms since last)
[420879.342445] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x00000000:1961268A) - 1 (beacon timer 3443607926)
[420879.379331] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF: 0x00000000:1961B69D) - 4 elapsed=36883 usec (36ms since last)
[420879.381140] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x00000000:1961BDA7) - 1 (beacon timer 3443569241)
[420879.398551] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF: 0x00000000:196201A8) - 1 elapsed=17409 usec (20ms since last)
[420879.535222] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x00000000:196417BA) - 1 (beacon timer 3452008518)
[420879.572144] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF: 0x00000000:1964A7C8) - 5 elapsed=36878 usec (172ms since last)
[420879.573939] ieee80211 phy0: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x00000000:1964AECF) - 1 (beacon timer 3451969841)
[420879.610823] ieee80211 phy0: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF: 0x00000000:19653EDC) - 4 elapsed=36877 usec (40ms since last)
