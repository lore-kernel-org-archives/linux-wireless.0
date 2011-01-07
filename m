Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([213.88.146.6]:39204 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751790Ab1AGVzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 16:55:52 -0500
Message-ID: <20110107215549.4053.qmail@stuge.se>
Date: Fri, 7 Jan 2011 22:55:49 +0100
From: Peter Stuge <peter@stuge.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: ath9k tx lockup, ath: received PCI FATAL interrupt
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Weqbz6OltVu8XOAh"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

First of all, sorry for dropping linux-wireless from my previous
message, it was mostly about my understanding of ath9k processes.

Crossposting is a bit unnatural for me, I usually strictly use
list-reply. Let's try with this one! :)


Peter Stuge wrote:
> So there was a problem while writing this message. Will follow up
> in separate message. I can only describe the symptom, but as I wrote
> after subscribing this list over a year ago I'm comfortable and more
> than happy to help with debugging on register level, and below, but I
> still know neither driver nor hardware and if possible I would like
> to not have to learn all of the driver, so I would need to be told
> fairly specifically what to instrument.
> 
> I think someone with good knowledge of driver and hardware could give
> guidance very quickly.

I booted wireless-testing master-2011-01-05 with an AR9280 Mini PCI
card in my ThinkPad X40 today.

I normally never use wpa_supplicant. I don't accept that it would be
required for a working connection and so far noone has really
explained why that would be the case. Only ath9k (ie. neither ipw2200
nor ath5k) has ever made a difference between wpa_supplicant running
or not.

I configure manually. Module is loaded by kernel on boot. After
logging in, I run:

ip l s dev eth1 up
iw dev eth1 connect Stuge
ip a a 192.168.5.4/24 dev eth1
ip r a default via 192.168.5.1

..and that is my internet connection.


I used the connection without issues for about an hour, working
remotely and listening to a music stream, then I was disassociated,
with the PCI FATAL interrupt in the kernel log.

dmesg output is log1_ath_pci_fatal_interrupt.txt


Trying to revive the connection it seemed like no packets were being
transmitted because I could scan, but not associate again.

I then tried to start wpa_supplicant, which made four attempts at
authenticating with the (unencrypted) AP, without success.

dmesg output is log2_after_wpa_supplicant_4x_trying_to_auth.txt


I tried to rmmod and modprobe the driver, followed by

iw dev eth1 connect Stuge

but that also did not work.

dmesg output is log3_after_rmmod_modprobe.txt


I power cycled and did the above ip l s + iw connect, which made the
card sort-of associate, but not function correctly.

dmesg output is log4_after_power_cycle_and_iw_connect.txt

Running iw dev eth1 link at this time showed me *not* being
successfully connected.

I started wpa_supplicant 0.7.2 without debug messages.
Output is in log5_wpa_supplicant.txt

I ran iw dev eth1 connect Stuge

wpa_supplicant output is log6_wpa_supplicant_after_iw_connect.txt

dmesg output is log7_after_wpa_supplicant_and_iw_connect.txt


This is the connection I am currently using.


The above identifies at least two issues:

1. ath: received PCI FATAL interrupt

How can I find out more about the reason for this?


2. Unworking association without wpa_supplicant after power cycle

How can I find out more about the reason for this?


The log files are attached and available at http://stuge.se/ath9k/wl0105/
All dmesg output is incremental. boot1.txt and boot2.txt are initial
messages for each boot, but not included as attachments.

boot2.txt (after power cycle) had different timing, keyboard detected
earlier, no tty60 hash and different btrfs transaction id. I added
the Time: stamp in log4_after_power_cycle_and_iw_connect.txt.

Please help me provide further neccessary information to debug this.
Thank you!


//Peter

--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log1_ath_pci_fatal_interrupt.txt"

[  116.379476] ieee80211 phy0: device now idle
[  128.258056] ieee80211 phy0: device no longer idle - scanning
[  131.749216] eth1: authenticate with 00:02:6f:21:ea:94 (try 1)
[  131.949037] eth1: authenticate with 00:02:6f:21:ea:94 (try 2)
[  131.950969] eth1: authenticated
[  131.950993] ieee80211 phy0: device now idle
[  131.978744] ieee80211 phy0: device no longer idle - working
[  131.996384] eth1: associate with 00:02:6f:21:ea:94 (try 1)
[  131.999167] eth1: RX AssocResp from 00:02:6f:21:ea:94 (capab=0x421 status=0 aid=1)
[  131.999172] eth1: associated
[  131.999181] ieee80211 phy0: Allocated STA 00:02:6f:21:ea:94
[  131.999199] ieee80211 phy0: Inserted STA 00:02:6f:21:ea:94
[  131.999205] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=2 cWmin=7 cWmax=1023 txop=64 uapsd=0
[  131.999214] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
[  131.999220] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
[  131.999226] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
[ 1005.004039] eth1: detected beacon loss from AP - sending probe request
[ 1008.004661] eth1: detected beacon loss from AP - sending probe request
[ 1010.004664] eth1: detected beacon loss from AP - sending probe request
[ 1012.004661] eth1: detected beacon loss from AP - sending probe request
[ 1016.004663] eth1: detected beacon loss from AP - sending probe request
[ 1016.394039] eth1: cancelling probereq poll due to a received beacon
[ 1019.004016] eth1: detected beacon loss from AP - sending probe request
[ 1021.004031] eth1: detected beacon loss from AP - sending probe request
[ 1021.102510] eth1: cancelling probereq poll due to a received beacon
[ 1022.002033] eth1: detected beacon loss from AP - sending probe request
[ 1024.002038] eth1: detected beacon loss from AP - sending probe request
[ 1027.004034] eth1: detected beacon loss from AP - sending probe request
[ 1027.243583] eth1: cancelling probereq poll due to a received beacon
[ 1029.002037] eth1: detected beacon loss from AP - sending probe request
[ 1029.290442] eth1: cancelling probereq poll due to a received beacon
[ 1037.004033] eth1: detected beacon loss from AP - sending probe request
[ 1037.376311] eth1: cancelling probereq poll due to a received beacon
[ 1045.004035] eth1: detected beacon loss from AP - sending probe request
[ 1053.004038] eth1: detected beacon loss from AP - sending probe request
[ 1053.138950] eth1: cancelling probereq poll due to a received beacon
[ 1070.002042] eth1: detected beacon loss from AP - sending probe request
[ 1070.026256] eth1: cancelling probereq poll due to a received beacon
[ 1071.002034] eth1: detected beacon loss from AP - sending probe request
[ 1073.004035] eth1: detected beacon loss from AP - sending probe request
[ 1076.004665] eth1: detected beacon loss from AP - sending probe request
[ 1078.004663] eth1: detected beacon loss from AP - sending probe request
[ 1080.004661] eth1: detected beacon loss from AP - sending probe request
[ 1082.004662] eth1: detected beacon loss from AP - sending probe request
[ 1084.004662] eth1: detected beacon loss from AP - sending probe request
[ 1086.004654] eth1: detected beacon loss from AP - sending probe request
[ 1088.004674] eth1: detected beacon loss from AP - sending probe request
[ 1090.004664] eth1: detected beacon loss from AP - sending probe request
[ 1092.004659] eth1: detected beacon loss from AP - sending probe request
[ 1094.004662] eth1: detected beacon loss from AP - sending probe request
[ 1096.004662] eth1: detected beacon loss from AP - sending probe request
[ 1096.229341] eth1: cancelling probereq poll due to a received beacon
[ 1097.002034] eth1: detected beacon loss from AP - sending probe request
[ 1099.004036] eth1: detected beacon loss from AP - sending probe request
[ 1101.004034] eth1: detected beacon loss from AP - sending probe request
[ 1101.243160] eth1: cancelling probereq poll due to a received beacon
[ 1102.002041] eth1: detected beacon loss from AP - sending probe request
[ 1110.004664] eth1: detected beacon loss from AP - sending probe request
[ 1112.004661] eth1: detected beacon loss from AP - sending probe request
[ 1114.004652] eth1: detected beacon loss from AP - sending probe request
[ 1116.004654] eth1: detected beacon loss from AP - sending probe request
[ 1118.004654] eth1: detected beacon loss from AP - sending probe request
[ 1118.233488] eth1: cancelling probereq poll due to a received beacon
[ 1119.002034] eth1: detected beacon loss from AP - sending probe request
[ 1119.053983] eth1: cancelling probereq poll due to a received beacon
[ 1120.002037] eth1: detected beacon loss from AP - sending probe request
[ 1120.486930] eth1: cancelling probereq poll due to a received beacon
[ 1122.004652] eth1: detected beacon loss from AP - sending probe request
[ 1125.004027] eth1: detected beacon loss from AP - sending probe request
[ 1125.297132] eth1: cancelling probereq poll due to a received beacon
[ 1128.002028] eth1: detected beacon loss from AP - sending probe request
[ 1128.061036] eth1: cancelling probereq poll due to a received beacon
[ 1130.004652] eth1: detected beacon loss from AP - sending probe request
[ 1130.312726] eth1: cancelling probereq poll due to a received beacon
[ 1132.004658] eth1: detected beacon loss from AP - sending probe request
[ 1135.004038] eth1: detected beacon loss from AP - sending probe request
[ 1139.004040] eth1: detected beacon loss from AP - sending probe request
[ 1141.004036] eth1: detected beacon loss from AP - sending probe request
[ 1144.004661] eth1: detected beacon loss from AP - sending probe request
[ 1146.004653] eth1: detected beacon loss from AP - sending probe request
[ 1148.004664] eth1: detected beacon loss from AP - sending probe request
[ 1152.002038] eth1: detected beacon loss from AP - sending probe request
[ 1159.004048] eth1: detected beacon loss from AP - sending probe request
[ 1161.004036] eth1: detected beacon loss from AP - sending probe request
[ 1163.004039] eth1: detected beacon loss from AP - sending probe request
[ 1163.269913] eth1: cancelling probereq poll due to a received beacon
[ 1165.004053] eth1: detected beacon loss from AP - sending probe request
[ 1165.010338] eth1: cancelling probereq poll due to a received beacon
[ 1169.002037] eth1: detected beacon loss from AP - sending probe request
[ 1169.204488] eth1: cancelling probereq poll due to a received beacon
[ 1170.002032] eth1: detected beacon loss from AP - sending probe request
[ 1176.004656] eth1: detected beacon loss from AP - sending probe request
[ 1180.004669] eth1: detected beacon loss from AP - sending probe request
[ 1180.056148] eth1: cancelling probereq poll due to a received beacon
[ 1184.004662] eth1: detected beacon loss from AP - sending probe request
[ 1184.047795] eth1: cancelling probereq poll due to a received beacon
[ 1185.002035] eth1: detected beacon loss from AP - sending probe request
[ 1187.004033] eth1: detected beacon loss from AP - sending probe request
[ 1189.004036] eth1: detected beacon loss from AP - sending probe request
[ 1195.004029] eth1: detected beacon loss from AP - sending probe request
[ 1195.408589] eth1: cancelling probereq poll due to a received beacon
[ 1197.004036] eth1: detected beacon loss from AP - sending probe request
[ 1199.004036] eth1: detected beacon loss from AP - sending probe request
[ 1202.004662] eth1: detected beacon loss from AP - sending probe request
[ 1202.061495] eth1: cancelling probereq poll due to a received beacon
[ 1203.002029] eth1: detected beacon loss from AP - sending probe request
[ 1205.004037] eth1: detected beacon loss from AP - sending probe request
[ 1207.004036] eth1: detected beacon loss from AP - sending probe request
[ 1209.004037] eth1: detected beacon loss from AP - sending probe request
[ 1211.004024] eth1: detected beacon loss from AP - sending probe request
[ 1215.002037] eth1: detected beacon loss from AP - sending probe request
[ 1222.004663] eth1: detected beacon loss from AP - sending probe request
[ 1233.004037] eth1: detected beacon loss from AP - sending probe request
[ 3703.522722] ath: received PCI FATAL interrupt
[ 3705.004034] eth1: detected beacon loss from AP - sending probe request
[ 3705.505041] ieee80211 phy0: eth1: Failed to send nullfunc to AP 00:02:6f:21:ea:94 after 500ms, disconnecting.
[ 3705.506029] ieee80211 phy0: Removed STA 00:02:6f:21:ea:94
[ 3705.506041] ieee80211 phy0: Destroyed STA 00:02:6f:21:ea:94
[ 3705.506053] ieee80211 phy0: device now idle
[ 3705.518226] cfg80211: Calling CRDA for country: US
[ 3705.531607] cfg80211: Regulatory domain changed to country: US
[ 3705.531617] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 3705.531629] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[ 3705.531639] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[ 3705.531650] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 3705.531660] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 3705.531670] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 3705.531680] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[ 3705.531709] cfg80211: Calling CRDA for country: NA
[ 3729.069673] ieee80211 phy0: device no longer idle - scanning
[ 3732.667595] ieee80211 phy0: device now idle
[ 3732.675072] ieee80211 phy0: device no longer idle - working
[ 3732.685319] eth1: direct probe to 00:02:6f:21:ea:94 (try 1/3)
[ 3732.885476] eth1: direct probe to 00:02:6f:21:ea:94 (try 2/3)
[ 3733.085043] eth1: direct probe to 00:02:6f:21:ea:94 (try 3/3)
[ 3733.285038] eth1: direct probe to 00:02:6f:21:ea:94 timed out
[ 3733.286035] ieee80211 phy0: device now idle

--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log2_after_wpa_supplicant_4x_trying_to_auth.txt"

[ 3866.251301] ieee80211 phy0: device no longer idle - scanning
[ 3869.412919] eth1: direct probe to 00:02:6f:21:ea:94 (try 1/3)
[ 3869.612048] eth1: direct probe to 00:02:6f:21:ea:94 (try 2/3)
[ 3869.812043] eth1: direct probe to 00:02:6f:21:ea:94 (try 3/3)
[ 3870.012035] eth1: direct probe to 00:02:6f:21:ea:94 timed out
[ 3870.013037] ieee80211 phy0: device now idle
[ 3875.029880] ieee80211 phy0: device no longer idle - scanning
[ 3875.245414] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 3875.245468] ath: Failed to stop TX DMA!
[ 3878.196841] eth1: direct probe to 00:02:6f:21:ea:94 (try 1/3)
[ 3878.396046] eth1: direct probe to 00:02:6f:21:ea:94 (try 2/3)
[ 3878.596024] eth1: direct probe to 00:02:6f:21:ea:94 (try 3/3)
[ 3878.796062] eth1: direct probe to 00:02:6f:21:ea:94 timed out
[ 3878.797038] ieee80211 phy0: device now idle
[ 3883.814050] ieee80211 phy0: device no longer idle - scanning
[ 3884.314318] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 3884.314371] ath: Failed to stop TX DMA!
[ 3886.980998] eth1: direct probe to 00:02:6f:21:ea:94 (try 1/3)
[ 3887.181043] eth1: direct probe to 00:02:6f:21:ea:94 (try 2/3)
[ 3887.381042] eth1: direct probe to 00:02:6f:21:ea:94 (try 3/3)
[ 3887.581029] eth1: direct probe to 00:02:6f:21:ea:94 timed out
[ 3887.582032] ieee80211 phy0: device now idle
[ 3887.590413] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 3887.590465] ath: Failed to stop TX DMA!
[ 3892.602928] ieee80211 phy0: device no longer idle - scanning
[ 3895.767977] eth1: direct probe to 00:02:6f:21:ea:94 (try 1/3)
[ 3895.967048] eth1: direct probe to 00:02:6f:21:ea:94 (try 2/3)
[ 3896.167040] eth1: direct probe to 00:02:6f:21:ea:94 (try 3/3)
[ 3896.367039] eth1: direct probe to 00:02:6f:21:ea:94 timed out
[ 3896.368038] ieee80211 phy0: device now idle

--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log3_after_rmmod_modprobe.txt"

[ 3928.010276] ieee80211 phy0: device no longer idle - scanning
[ 3931.185157] ieee80211 phy0: device now idle
[ 3946.277200] ieee80211 phy0: device no longer idle - scanning
[ 3949.442729] ieee80211 phy0: device now idle
[ 3963.534723] ath9k 0000:02:02.0: PCI INT A disabled
[ 3963.534769] ath9k: Driver unloaded
[ 3970.103921] ath9k 0000:02:02.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[ 3971.667953] ath: EEPROM regdomain: 0x0
[ 3971.667959] ath: EEPROM indicates default country code should be used
[ 3971.667961] ath: doing EEPROM country->regdmn map search
[ 3971.667966] ath: country maps to regdmn code: 0x3a
[ 3971.667969] ath: Country alpha2 being used: US
[ 3971.668009] ath: Regpair used: 0x3a
[ 3971.677862] ieee80211 phy1: Selected rate control algorithm 'ath9k_rate_control'
[ 3971.678916] Registered led device: ath9k-phy1::radio
[ 3971.679244] Registered led device: ath9k-phy1::assoc
[ 3971.679557] Registered led device: ath9k-phy1::tx
[ 3971.679866] Registered led device: ath9k-phy1::rx
[ 3971.679876] ieee80211 phy1: Atheros AR9280 Rev:2 mem=0xf8800000, irq=21
[ 3971.708098] udev: renamed network interface wlan0 to eth1

--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log4_after_power_cycle_and_iw_connect.txt"

[    0.040025] Time: 20:28:45  Date: 01/07/11
[   21.240806] ieee80211 phy0: device now idle
[   24.848752] ieee80211 phy0: device no longer idle - scanning
[   28.344240] eth1: authenticate with 00:02:6f:21:ea:94 (try 1)
[   28.346255] eth1: authenticated
[   28.346300] eth1: associate with 00:02:6f:21:ea:94 (try 1)
[   28.348861] eth1: RX AssocResp from 00:02:6f:21:ea:94 (capab=0x421 status=0 aid=1)
[   28.348872] eth1: associated
[   28.348889] ieee80211 phy0: Allocated STA 00:02:6f:21:ea:94
[   28.348925] ieee80211 phy0: Inserted STA 00:02:6f:21:ea:94
[   28.348939] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=2 cWmin=7 cWmax=1023 txop=64 uapsd=0
[   28.348956] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
[   28.348970] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
[   28.348984] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
[   29.708663] eth1: detected beacon loss from AP - sending probe request
[   29.802310] eth1: cancelling probereq poll due to a received beacon
[   30.706036] eth1: detected beacon loss from AP - sending probe request
[   30.723929] eth1: cancelling probereq poll due to a received beacon
[   31.706033] eth1: detected beacon loss from AP - sending probe request
[   31.747957] eth1: cancelling probereq poll due to a received beacon
[   32.706035] eth1: detected beacon loss from AP - sending probe request
[   32.771984] eth1: cancelling probereq poll due to a received beacon
[   33.706035] eth1: detected beacon loss from AP - sending probe request
[   33.796014] eth1: cancelling probereq poll due to a received beacon
[   34.717640] net_ratelimit: 1 callbacks suppressed
[   34.717650] eth1: cancelling probereq poll due to a received beacon
[   35.706037] eth1: detected beacon loss from AP - sending probe request
[   35.741658] eth1: cancelling probereq poll due to a received beacon
[   36.706037] eth1: detected beacon loss from AP - sending probe request
[   36.765683] eth1: cancelling probereq poll due to a received beacon
[   37.706040] eth1: detected beacon loss from AP - sending probe request
[   37.789713] eth1: cancelling probereq poll due to a received beacon
[   38.706038] eth1: detected beacon loss from AP - sending probe request
[   38.711337] eth1: cancelling probereq poll due to a received beacon
[   39.706039] eth1: detected beacon loss from AP - sending probe request
[   40.759391] net_ratelimit: 2 callbacks suppressed
[   40.759401] eth1: cancelling probereq poll due to a received beacon
[   41.706040] eth1: detected beacon loss from AP - sending probe request
[   41.783412] eth1: cancelling probereq poll due to a received beacon
[   42.706038] eth1: detected beacon loss from AP - sending probe request
[   42.807437] eth1: cancelling probereq poll due to a received beacon
[   43.706034] eth1: detected beacon loss from AP - sending probe request
[   43.729068] eth1: cancelling probereq poll due to a received beacon
[   44.706037] eth1: detected beacon loss from AP - sending probe request
[   44.753088] eth1: cancelling probereq poll due to a received beacon
[   45.706036] eth1: detected beacon loss from AP - sending probe request
[   46.801148] net_ratelimit: 2 callbacks suppressed
[   46.801158] eth1: cancelling probereq poll due to a received beacon
[   47.706036] eth1: detected beacon loss from AP - sending probe request
[   47.722770] eth1: cancelling probereq poll due to a received beacon
[   48.706036] eth1: detected beacon loss from AP - sending probe request
[   48.746791] eth1: cancelling probereq poll due to a received beacon
[   49.706043] eth1: detected beacon loss from AP - sending probe request
[   49.770819] eth1: cancelling probereq poll due to a received beacon
[   50.706037] eth1: detected beacon loss from AP - sending probe request
[   50.794847] eth1: cancelling probereq poll due to a received beacon
[   51.706022] eth1: detected beacon loss from AP - sending probe request
[   52.740505] net_ratelimit: 2 callbacks suppressed
[   52.740515] eth1: cancelling probereq poll due to a received beacon
[   53.706055] eth1: detected beacon loss from AP - sending probe request
[   53.764527] eth1: cancelling probereq poll due to a received beacon
[   54.706018] eth1: detected beacon loss from AP - sending probe request
[   54.788634] eth1: cancelling probereq poll due to a received beacon
[   55.706038] eth1: detected beacon loss from AP - sending probe request
[   55.710175] eth1: cancelling probereq poll due to a received beacon
[   56.706039] eth1: detected beacon loss from AP - sending probe request
[   56.734200] eth1: cancelling probereq poll due to a received beacon
[   57.706042] eth1: detected beacon loss from AP - sending probe request
[   58.782259] net_ratelimit: 2 callbacks suppressed
[   58.782270] eth1: cancelling probereq poll due to a received beacon
[   59.706042] eth1: detected beacon loss from AP - sending probe request
[   59.806284] eth1: cancelling probereq poll due to a received beacon
[   60.706038] eth1: detected beacon loss from AP - sending probe request
[   60.727901] eth1: cancelling probereq poll due to a received beacon
[   61.706038] eth1: detected beacon loss from AP - sending probe request
[   61.751924] eth1: cancelling probereq poll due to a received beacon
[   62.706038] eth1: detected beacon loss from AP - sending probe request
[   62.775949] eth1: cancelling probereq poll due to a received beacon
[   63.706039] eth1: detected beacon loss from AP - sending probe request
[   64.721607] net_ratelimit: 2 callbacks suppressed
[   64.721616] eth1: cancelling probereq poll due to a received beacon
[   65.706044] eth1: detected beacon loss from AP - sending probe request
[   65.745633] eth1: cancelling probereq poll due to a received beacon
[   66.706056] eth1: detected beacon loss from AP - sending probe request
[   66.769958] eth1: cancelling probereq poll due to a received beacon
[   67.706038] eth1: detected beacon loss from AP - sending probe request
[   67.793680] eth1: cancelling probereq poll due to a received beacon
[   68.706032] eth1: detected beacon loss from AP - sending probe request
[   68.715308] eth1: cancelling probereq poll due to a received beacon
[   69.706039] eth1: detected beacon loss from AP - sending probe request
[   70.763925] net_ratelimit: 2 callbacks suppressed
[   70.763935] eth1: cancelling probereq poll due to a received beacon
[   71.706034] eth1: detected beacon loss from AP - sending probe request
[   71.787392] eth1: cancelling probereq poll due to a received beacon
[   72.706037] eth1: detected beacon loss from AP - sending probe request
[   72.709000] eth1: cancelling probereq poll due to a received beacon
[   73.706039] eth1: detected beacon loss from AP - sending probe request
[   73.733036] eth1: cancelling probereq poll due to a received beacon
[   74.706033] eth1: detected beacon loss from AP - sending probe request
[   74.757112] eth1: cancelling probereq poll due to a received beacon
[   75.706037] eth1: detected beacon loss from AP - sending probe request
[   76.805117] net_ratelimit: 2 callbacks suppressed
[   76.805127] eth1: cancelling probereq poll due to a received beacon
[   77.706040] eth1: detected beacon loss from AP - sending probe request
[   77.726736] eth1: cancelling probereq poll due to a received beacon
[   78.706036] eth1: detected beacon loss from AP - sending probe request
[   78.750761] eth1: cancelling probereq poll due to a received beacon
[   79.706040] eth1: detected beacon loss from AP - sending probe request
[   79.774794] eth1: cancelling probereq poll due to a received beacon
[   80.706036] eth1: detected beacon loss from AP - sending probe request
[   80.798817] eth1: cancelling probereq poll due to a received beacon
[   81.706037] eth1: detected beacon loss from AP - sending probe request
[   82.744471] net_ratelimit: 2 callbacks suppressed
[   82.744481] eth1: cancelling probereq poll due to a received beacon
[   83.706039] eth1: detected beacon loss from AP - sending probe request
[   83.768494] eth1: cancelling probereq poll due to a received beacon
[   84.706038] eth1: detected beacon loss from AP - sending probe request
[   84.792514] eth1: cancelling probereq poll due to a received beacon
[   85.706038] eth1: detected beacon loss from AP - sending probe request
[   85.714138] eth1: cancelling probereq poll due to a received beacon
[   86.706037] eth1: detected beacon loss from AP - sending probe request
[   86.738161] eth1: cancelling probereq poll due to a received beacon
[   87.706033] eth1: detected beacon loss from AP - sending probe request
[   88.786228] net_ratelimit: 2 callbacks suppressed
[   88.786239] eth1: cancelling probereq poll due to a received beacon

--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log5_wpa_supplicant.txt"

# wpa_supplicant -Dnl80211 -ieth1 -c /etc/wpa_supplicant/wpa_supplicant.conf 
Trying to authenticate with 00:02:6f:21:ea:94 (SSID='Stuge' freq=2417 MHz)
Authentication request to the driver failed
CTRL-EVENT-DISCONNECTED bssid=00:02:6f:21:ea:94 reason=2

--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log6_wpa_supplicant_after_iw_connect.txt"

Trying to authenticate with 00:02:6f:21:ea:94 (SSID='Stuge' freq=2417 MHz)
Trying to associate with 00:02:6f:21:ea:94 (SSID='Stuge' freq=2417 MHz)
Associated with 00:02:6f:21:ea:94
CTRL-EVENT-CONNECTED - Connection to 00:02:6f:21:ea:94 completed (auth) [id=1 id_str=]

--Weqbz6OltVu8XOAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log7_after_wpa_supplicant_and_iw_connect.txt"

[   89.706035] eth1: detected beacon loss from AP - sending probe request
[   89.810249] eth1: cancelling probereq poll due to a received beacon
[   90.706036] eth1: detected beacon loss from AP - sending probe request
[   90.731865] eth1: cancelling probereq poll due to a received beacon
[   91.706036] eth1: detected beacon loss from AP - sending probe request
[   91.755888] eth1: cancelling probereq poll due to a received beacon
[   92.706035] eth1: detected beacon loss from AP - sending probe request
[   92.779920] eth1: cancelling probereq poll due to a received beacon
[   93.706014] eth1: detected beacon loss from AP - sending probe request
[   94.725552] net_ratelimit: 2 callbacks suppressed
[   94.725558] eth1: cancelling probereq poll due to a received beacon
[   95.150498] eth1: deauthenticating from 00:02:6f:21:ea:94 by local choice (reason=2)
[   95.151032] ieee80211 phy0: Removed STA 00:02:6f:21:ea:94
[   95.151044] ieee80211 phy0: Destroyed STA 00:02:6f:21:ea:94
[   95.151055] ieee80211 phy0: device now idle
[   95.158416] cfg80211: Calling CRDA for country: US
[   95.175126] cfg80211: Regulatory domain changed to country: US
[   95.175137] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   95.175149] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   95.175160] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[   95.175170] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   95.175180] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   95.175190] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   95.175200] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[   95.175228] cfg80211: Calling CRDA for country: NA
[  144.165559] ieee80211 phy0: device no longer idle - scanning
[  147.671758] eth1: authenticate with 00:02:6f:21:ea:94 (try 1)
[  147.673640] eth1: authenticated
[  147.673815] eth1: associate with 00:02:6f:21:ea:94 (try 1)
[  147.676657] eth1: RX AssocResp from 00:02:6f:21:ea:94 (capab=0x421 status=0 aid=1)
[  147.676668] eth1: associated
[  147.676685] ieee80211 phy0: Allocated STA 00:02:6f:21:ea:94
[  147.676771] ieee80211 phy0: Inserted STA 00:02:6f:21:ea:94
[  147.676785] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=2 cWmin=7 cWmax=1023 txop=64 uapsd=0
[  147.676804] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
[  147.676818] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
[  147.676832] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0

--Weqbz6OltVu8XOAh--
