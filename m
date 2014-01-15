Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:14808 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaAOH6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 02:58:20 -0500
Message-ID: <52D63EBB.7020607@neratec.com> (sfid-20140115_085826_055486_66DDAC97)
Date: Wed, 15 Jan 2014 08:54:35 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>	<1384665016-12022-5-git-send-email-sujith@msujith.org>	<52CE934D.1020400@neratec.com>	<21198.40916.260973.48444@gargle.gargle.HOWL>	<52CEA5A3.2040308@neratec.com>	<21198.43395.235654.597422@gargle.gargle.HOWL>	<52CEAB24.5090700@neratec.com>	<52D3F962.1010302@neratec.com>	<21204.319.492595.58625@gargle.gargle.HOWL>	<52D402C3.3070606@neratec.com>	<21204.1991.201080.986559@gargle.gargle.HOWL>	<21204.2384.710460.402183@gargle.gargle.HOWL> <21204.3832.404821.109119@gargle.gargle.HOWL>
In-Reply-To: <21204.3832.404821.109119@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/13/2014 05:06 PM, Sujith Manoharan wrote:
> Sujith Manoharan wrote:
>>> I used this patch:
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>>> index 5bf3243..c85be42 100644
>>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>> @@ -1088,6 +1088,9 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
>>>   
>>>   	ath9k_process_rssi(common, hw, rx_stats, rx_status);
>>>   
>>> +	printk("NOISE/RSSI/SIGNAL for %pM: %d/%d/%d\n",
>>> +	       hdr->addr3, ah->noise, rx_stats->rs_rssi, rx_status->signal);
>>> +
>>>   	rx_status->band = ah->curchan->chan->band;
>>>   	rx_status->freq = ah->curchan->chan->center_freq;
>>>   	rx_status->antenna = rx_stats->rs_antenna;
> With this patch, can you please post the kernel log with debug=0x749 ?
>
> Sujith
Here it is. I have copied only fragment where it happens. I am using 
15ms beacon period.
With longer intervals you might not see the problem.
Look around
kernel: [ 1177.032695]


br,
Wojtek

Jan 15 08:43:43 wlanTS kernel: [ 1176.519552] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/22/-65
Jan 15 08:43:43 wlanTS kernel: [ 1176.534913] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:43 wlanTS kernel: [ 1176.550273] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:43 wlanTS kernel: [ 1176.565632] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:43 wlanTS kernel: [ 1176.580992] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:43 wlanTS kernel: [ 1176.596353] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:43 wlanTS kernel: [ 1176.611713] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:44 wlanTS kernel: [ 1176.627074] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/22/-65
Jan 15 08:43:44 wlanTS kernel: [ 1176.642433] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/24/-63
Jan 15 08:43:44 wlanTS kernel: [ 1176.657792] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/24/-63
Jan 15 08:43:44 wlanTS kernel: [ 1176.673150] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/22/-65
Jan 15 08:43:44 wlanTS kernel: [ 1176.688514] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/24/-63
Jan 15 08:43:44 wlanTS kernel: [ 1176.703875] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/24/-63
Jan 15 08:43:44 wlanTS kernel: [ 1176.719233] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:44 wlanTS kernel: [ 1176.734593] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/22/-65
Jan 15 08:43:44 wlanTS kernel: [ 1176.749953] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:44 wlanTS kernel: [ 1176.765314] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/27/-60
Jan 15 08:43:44 wlanTS kernel: [ 1176.780674] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/27/-60
Jan 15 08:43:44 wlanTS kernel: [ 1176.796034] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:44 wlanTS kernel: [ 1176.811393] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/24/-63
Jan 15 08:43:44 wlanTS kernel: [ 1176.826751] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/21/-66
Jan 15 08:43:44 wlanTS kernel: [ 1176.842112] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/21/-66
Jan 15 08:43:44 wlanTS kernel: [ 1176.857476] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/21/-66
Jan 15 08:43:44 wlanTS kernel: [ 1176.872834] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/23/-64
Jan 15 08:43:44 wlanTS kernel: [ 1176.888194] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/22/-65
Jan 15 08:43:44 wlanTS kernel: [ 1176.889133] ath: phy0: listenTime=962 
OFDM:0 errs=27/s CCK:0 errs=0/s ofdm_turn=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.889145] ath: phy0: Calibration 
@4295186483 finished:   ani, caldone: true
Jan 15 08:43:44 wlanTS kernel: [ 1176.897977] ath: phy0: Set HW RX 
filter: 0x417
Jan 15 08:43:44 wlanTS kernel: [ 1176.898018] ath: phy0: Set channel: 
5180 MHz width: 1
Jan 15 08:43:44 wlanTS kernel: [ 1176.898026] ath: phy0: Stopping ANI
Jan 15 08:43:44 wlanTS kernel: [ 1176.898056] ath: phy0: Disable MIB 
counters
Jan 15 08:43:44 wlanTS kernel: [ 1176.898073] ath: phy0: Reset to 5180 
MHz, HT40: 0 fastcc: 0
Jan 15 08:43:44 wlanTS kernel: [ 1176.898077] ath: phy0: NF calibrated 
[ctl] [chain 0] is -101
Jan 15 08:43:44 wlanTS kernel: [ 1176.898078] ath: phy0: NF calibrated 
[ctl] [chain 1] is -101
Jan 15 08:43:44 wlanTS kernel: [ 1176.899023] ath: phy0: ver 448.4 
opmode 2 chan 5180 Mhz
Jan 15 08:43:44 wlanTS kernel: [ 1176.899030] ath: phy0: ah->misc_mode 
0x10000004
Jan 15 08:43:44 wlanTS kernel: [ 1176.900520] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900525] ath: phy0: 
IQ_RES[0]=0xdc759033 IQ_RES[1]=0x118f
Jan 15 08:43:44 wlanTS kernel: [ 1176.900530] ath: phy0: 
IQ_RES[2]=0x7fca76c IQ_RES[3]=0x14b0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900535] ath: phy0: 
IQ_RES[4]=0x4d012004 IQ_RES[5]=0xfda1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900537] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900538] ath: phy0: tx chain 0: mag 
corr=2  phase corr=4
Jan 15 08:43:44 wlanTS kernel: [ 1176.900539] ath: phy0: tx chain 0: iq 
corr coeff=104
Jan 15 08:43:44 wlanTS kernel: [ 1176.900540] ath: phy0: rx chain 0: mag 
corr=-1  phase corr=10
Jan 15 08:43:44 wlanTS kernel: [ 1176.900541] ath: phy0: rx chain 0: iq 
corr coeff=ffffff8a
Jan 15 08:43:44 wlanTS kernel: [ 1176.900542] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900548] ath: phy0: 
IQ_RES[0]=0xdd712034 IQ_RES[1]=0x10ff
Jan 15 08:43:44 wlanTS kernel: [ 1176.900553] ath: phy0: 
IQ_RES[2]=0x6fcc728 IQ_RES[3]=0x13f0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900558] ath: phy0: 
IQ_RES[4]=0x41011003 IQ_RES[5]=0xfdc1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900559] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900560] ath: phy0: tx chain 0: mag 
corr=3  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1176.900561] ath: phy0: tx chain 0: iq 
corr coeff=183
Jan 15 08:43:44 wlanTS kernel: [ 1176.900562] ath: phy0: rx chain 0: mag 
corr=-2  phase corr=11
Jan 15 08:43:44 wlanTS kernel: [ 1176.900563] ath: phy0: rx chain 0: iq 
corr coeff=ffffff0b
Jan 15 08:43:44 wlanTS kernel: [ 1176.900564] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900570] ath: phy0: 
IQ_RES[0]=0xde67702f IQ_RES[1]=0xfef
Jan 15 08:43:44 wlanTS kernel: [ 1176.900575] ath: phy0: 
IQ_RES[2]=0x7fd168c IQ_RES[3]=0x1210
Jan 15 08:43:44 wlanTS kernel: [ 1176.900580] ath: phy0: 
IQ_RES[4]=0x24011001 IQ_RES[5]=0xfde1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900581] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900582] ath: phy0: tx chain 0: mag 
corr=2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1176.900583] ath: phy0: tx chain 0: iq 
corr coeff=103
Jan 15 08:43:44 wlanTS kernel: [ 1176.900584] ath: phy0: rx chain 0: mag 
corr=-1  phase corr=9
Jan 15 08:43:44 wlanTS kernel: [ 1176.900585] ath: phy0: rx chain 0: iq 
corr coeff=ffffff89
Jan 15 08:43:44 wlanTS kernel: [ 1176.900586] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900592] ath: phy0: 
IQ_RES[0]=0xdc603031 IQ_RES[1]=0xecf
Jan 15 08:43:44 wlanTS kernel: [ 1176.900597] ath: phy0: 
IQ_RES[2]=0x5fc4617 IQ_RES[3]=0x10c0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900602] ath: phy0: 
IQ_RES[4]=0xe00d001 IQ_RES[5]=0xfdf1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900603] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900604] ath: phy0: tx chain 0: mag 
corr=3  phase corr=2
Jan 15 08:43:44 wlanTS kernel: [ 1176.900605] ath: phy0: tx chain 0: iq 
corr coeff=182
Jan 15 08:43:44 wlanTS kernel: [ 1176.900606] ath: phy0: rx chain 0: mag 
corr=-3  phase corr=12
Jan 15 08:43:44 wlanTS kernel: [ 1176.900607] ath: phy0: rx chain 0: iq 
corr coeff=fffffe8c
Jan 15 08:43:44 wlanTS kernel: [ 1176.900608] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900614] ath: phy0: 
IQ_RES[0]=0xe458502b IQ_RES[1]=0xd4f
Jan 15 08:43:44 wlanTS kernel: [ 1176.900619] ath: phy0: 
IQ_RES[2]=0x4fb8594 IQ_RES[3]=0xf30
Jan 15 08:43:44 wlanTS kernel: [ 1176.900624] ath: phy0: 
IQ_RES[4]=0xf4007001 IQ_RES[5]=0xfe40
Jan 15 08:43:44 wlanTS kernel: [ 1176.900625] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900626] ath: phy0: tx chain 0: mag 
corr=3  phase corr=1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900627] ath: phy0: tx chain 0: iq 
corr coeff=181
Jan 15 08:43:44 wlanTS kernel: [ 1176.900628] ath: phy0: rx chain 0: mag 
corr=-3  phase corr=11
Jan 15 08:43:44 wlanTS kernel: [ 1176.900629] ath: phy0: rx chain 0: iq 
corr coeff=fffffe8b
Jan 15 08:43:44 wlanTS kernel: [ 1176.900631] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900637] ath: phy0: 
IQ_RES[0]=0x135af03d IQ_RES[1]=0xe50
Jan 15 08:43:44 wlanTS kernel: [ 1176.900642] ath: phy0: 
IQ_RES[2]=0x130415be IQ_RES[3]=0x11b0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900647] ath: phy0: 
IQ_RES[4]=0x1e028006 IQ_RES[5]=0xfe91
Jan 15 08:43:44 wlanTS kernel: [ 1176.900648] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900649] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1176.900650] ath: phy0: tx chain 1: iq 
corr coeff=ffffff03
Jan 15 08:43:44 wlanTS kernel: [ 1176.900651] ath: phy0: rx chain 1: mag 
corr=-4  phase corr=-8
Jan 15 08:43:44 wlanTS kernel: [ 1176.900652] ath: phy0: rx chain 1: iq 
corr coeff=fffffdf8
Jan 15 08:43:44 wlanTS kernel: [ 1176.900653] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900659] ath: phy0: 
IQ_RES[0]=0x15576038 IQ_RES[1]=0xdb0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900664] ath: phy0: 
IQ_RES[2]=0x1303e585 IQ_RES[3]=0x10f0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900669] ath: phy0: 
IQ_RES[4]=0x12026006 IQ_RES[5]=0xfea1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900670] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900671] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1176.900672] ath: phy0: tx chain 1: iq 
corr coeff=ffffff03
Jan 15 08:43:44 wlanTS kernel: [ 1176.900673] ath: phy0: rx chain 1: mag 
corr=-3  phase corr=-10
Jan 15 08:43:44 wlanTS kernel: [ 1176.900674] ath: phy0: rx chain 1: iq 
corr coeff=fffffe76
Jan 15 08:43:44 wlanTS kernel: [ 1176.900675] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900681] ath: phy0: 
IQ_RES[0]=0xe4e803a IQ_RES[1]=0xc80
Jan 15 08:43:44 wlanTS kernel: [ 1176.900686] ath: phy0: 
IQ_RES[2]=0x1103e4f8 IQ_RES[3]=0xf20
Jan 15 08:43:44 wlanTS kernel: [ 1176.900691] ath: phy0: 
IQ_RES[4]=0xf4023004 IQ_RES[5]=0xfec0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900692] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900693] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=2
Jan 15 08:43:44 wlanTS kernel: [ 1176.900694] ath: phy0: tx chain 1: iq 
corr coeff=ffffff02
Jan 15 08:43:44 wlanTS kernel: [ 1176.900695] ath: phy0: rx chain 1: mag 
corr=-5  phase corr=-8
Jan 15 08:43:44 wlanTS kernel: [ 1176.900696] ath: phy0: rx chain 1: iq 
corr coeff=fffffd78
Jan 15 08:43:44 wlanTS kernel: [ 1176.900697] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900703] ath: phy0: 
IQ_RES[0]=0xe48903a IQ_RES[1]=0xc40
Jan 15 08:43:44 wlanTS kernel: [ 1176.900708] ath: phy0: 
IQ_RES[2]=0xf02b498 IQ_RES[3]=0xdf0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900713] ath: phy0: 
IQ_RES[4]=0xe101f002 IQ_RES[5]=0xfeb0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900714] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900715] ath: phy0: tx chain 1: mag 
corr=-1  phase corr=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900716] ath: phy0: tx chain 1: iq 
corr coeff=ffffff80
Jan 15 08:43:44 wlanTS kernel: [ 1176.900717] ath: phy0: rx chain 1: mag 
corr=-6  phase corr=-7
Jan 15 08:43:44 wlanTS kernel: [ 1176.900718] ath: phy0: rx chain 1: iq 
corr coeff=fffffcf9
Jan 15 08:43:44 wlanTS kernel: [ 1176.900719] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900725] ath: phy0: 
IQ_RES[0]=0x1442a03f IQ_RES[1]=0xbc0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900730] ath: phy0: 
IQ_RES[2]=0xe019439 IQ_RES[3]=0xce0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900735] ath: phy0: 
IQ_RES[4]=0xcf01a001 IQ_RES[5]=0xfe90
Jan 15 08:43:44 wlanTS kernel: [ 1176.900736] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900737] ath: phy0: tx chain 1: mag 
corr=-1  phase corr=-1
Jan 15 08:43:44 wlanTS kernel: [ 1176.900738] ath: phy0: tx chain 1: iq 
corr coeff=ffffff7f
Jan 15 08:43:44 wlanTS kernel: [ 1176.900739] ath: phy0: rx chain 1: mag 
corr=-7  phase corr=-8
Jan 15 08:43:44 wlanTS kernel: [ 1176.900740] ath: phy0: rx chain 1: iq 
corr coeff=fffffc78
Jan 15 08:43:44 wlanTS kernel: [ 1176.900755] ath: phy0: enabling IQ 
Calibration
Jan 15 08:43:44 wlanTS kernel: [ 1176.900757] ath: phy0: starting IQ 
Mismatch Calibration
Jan 15 08:43:44 wlanTS kernel: [ 1176.900772] ath: phy0: Enabled BB 
Watchdog timeout (25 ms)
Jan 15 08:43:44 wlanTS kernel: [ 1176.900811] ath: phy0: Enable MIB counters
Jan 15 08:43:44 wlanTS kernel: [ 1176.900817] ath: phy0: Restore 
history: opmode 2 chan 5180 Mhz is_scanning=0 ofdm:0 cck:0
Jan 15 08:43:44 wlanTS kernel: [ 1176.900818] ath: phy0: **** ofdmlevel 
0=>3, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1176.900819] ath: phy0: **** ccklevel 
0=>2, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1176.900830] ath: phy0: Starting ANI
Jan 15 08:43:44 wlanTS kernel: [ 1176.903551] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/24/-63
Jan 15 08:43:44 wlanTS kernel: [ 1176.903564] ath: phy0: bmiss: 10 
sleep: 15360
Jan 15 08:43:44 wlanTS kernel: [ 1176.903570] ath: phy0: next DTIM 121328640
Jan 15 08:43:44 wlanTS kernel: [ 1176.903572] ath: phy0: next beacon 
121328640
Jan 15 08:43:44 wlanTS kernel: [ 1176.903573] ath: phy0: beacon period 15360
Jan 15 08:43:44 wlanTS kernel: [ 1176.903574] ath: phy0: DTIM period 15360
Jan 15 08:43:44 wlanTS kernel: [ 1176.910321] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/43/-44
Jan 15 08:43:44 wlanTS kernel: [ 1176.918915] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/25/-62
Jan 15 08:43:44 wlanTS kernel: [ 1176.925343] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/39/-48
Jan 15 08:43:44 wlanTS kernel: [ 1176.926844] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/25/-62
Jan 15 08:43:44 wlanTS kernel: [ 1176.926863] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/40/-47
Jan 15 08:43:44 wlanTS kernel: [ 1176.934585] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/27/-60
Jan 15 08:43:44 wlanTS kernel: [ 1176.941041] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/40/-47
Jan 15 08:43:44 wlanTS kernel: [ 1176.949635] NOISE/RSSI/SIGNAL for 
04:f0:21:04:57:19: -87/21/-66
Jan 15 08:43:44 wlanTS kernel: [ 1176.953133] ath: phy0: Set channel: 
5200 MHz width: 0
Jan 15 08:43:44 wlanTS kernel: [ 1176.953141] ath: phy0: Stopping ANI
Jan 15 08:43:44 wlanTS kernel: [ 1176.953170] ath: phy0: Disable MIB 
counters
Jan 15 08:43:44 wlanTS kernel: [ 1176.953187] ath: phy0: Reset to 5200 
MHz, HT40: 0 fastcc: 1
Jan 15 08:43:44 wlanTS kernel: [ 1176.953191] ath: phy0: NF calibrated 
[ctl] [chain 0] is -101
Jan 15 08:43:44 wlanTS kernel: [ 1176.953192] ath: phy0: NF calibrated 
[ctl] [chain 1] is -101
Jan 15 08:43:44 wlanTS kernel: [ 1176.953196] ath: phy0: 
FastChannelChange for 5180 -> 5200
Jan 15 08:43:44 wlanTS kernel: [ 1176.953966] ath: phy0: Enable MIB counters
Jan 15 08:43:44 wlanTS kernel: [ 1176.953972] ath: phy0: **** ofdmlevel 
3=>3, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1176.953973] ath: phy0: **** ccklevel 
2=>2, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1177.009141] ath: phy0: Set channel: 
5180 MHz width: 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.009149] ath: phy0: Stopping ANI
Jan 15 08:43:44 wlanTS kernel: [ 1177.009187] ath: phy0: Disable MIB 
counters
Jan 15 08:43:44 wlanTS kernel: [ 1177.009204] ath: phy0: Reset to 5180 
MHz, HT40: 0 fastcc: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.009217] ath: phy0: NF calibrated 
[ctl] [chain 0] is -100
Jan 15 08:43:44 wlanTS kernel: [ 1177.009218] ath: phy0: NF calibrated 
[ctl] [chain 1] is -100
Jan 15 08:43:44 wlanTS kernel: [ 1177.010223] ath: phy0: ver 448.4 
opmode 2 chan 5180 Mhz
Jan 15 08:43:44 wlanTS kernel: [ 1177.010231] ath: phy0: ah->misc_mode 
0x10000004
Jan 15 08:43:44 wlanTS kernel: [ 1177.011710] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011716] ath: phy0: 
IQ_RES[0]=0xe175d037 IQ_RES[1]=0x119f
Jan 15 08:43:44 wlanTS kernel: [ 1177.011721] ath: phy0: 
IQ_RES[2]=0x9fc9771 IQ_RES[3]=0x14d0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011726] ath: phy0: 
IQ_RES[4]=0x4d011004 IQ_RES[5]=0xfdb1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011728] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011729] ath: phy0: tx chain 0: mag 
corr=2  phase corr=4
Jan 15 08:43:44 wlanTS kernel: [ 1177.011730] ath: phy0: tx chain 0: iq 
corr coeff=104
Jan 15 08:43:44 wlanTS kernel: [ 1177.011732] ath: phy0: rx chain 0: mag 
corr=-1  phase corr=9
Jan 15 08:43:44 wlanTS kernel: [ 1177.011733] ath: phy0: rx chain 0: iq 
corr coeff=ffffff89
Jan 15 08:43:44 wlanTS kernel: [ 1177.011734] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011740] ath: phy0: 
IQ_RES[0]=0xe071f035 IQ_RES[1]=0x10ff
Jan 15 08:43:44 wlanTS kernel: [ 1177.011745] ath: phy0: 
IQ_RES[2]=0x7fc6730 IQ_RES[3]=0x1400
Jan 15 08:43:44 wlanTS kernel: [ 1177.011750] ath: phy0: 
IQ_RES[4]=0x41010004 IQ_RES[5]=0xfdc1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011751] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011753] ath: phy0: tx chain 0: mag 
corr=2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.011754] ath: phy0: tx chain 0: iq 
corr coeff=103
Jan 15 08:43:44 wlanTS kernel: [ 1177.011755] ath: phy0: rx chain 0: mag 
corr=-2  phase corr=10
Jan 15 08:43:44 wlanTS kernel: [ 1177.011756] ath: phy0: rx chain 0: iq 
corr coeff=ffffff0a
Jan 15 08:43:44 wlanTS kernel: [ 1177.011757] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011763] ath: phy0: 
IQ_RES[0]=0xdf68202d IQ_RES[1]=0xfcf
Jan 15 08:43:44 wlanTS kernel: [ 1177.011768] ath: phy0: 
IQ_RES[2]=0x5fd468f IQ_RES[3]=0x1210
Jan 15 08:43:44 wlanTS kernel: [ 1177.011773] ath: phy0: 
IQ_RES[4]=0x2500f002 IQ_RES[5]=0xfe01
Jan 15 08:43:44 wlanTS kernel: [ 1177.011775] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011776] ath: phy0: tx chain 0: mag 
corr=2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.011777] ath: phy0: tx chain 0: iq 
corr coeff=103
Jan 15 08:43:44 wlanTS kernel: [ 1177.011778] ath: phy0: rx chain 0: mag 
corr=-1  phase corr=10
Jan 15 08:43:44 wlanTS kernel: [ 1177.011779] ath: phy0: rx chain 0: iq 
corr coeff=ffffff8a
Jan 15 08:43:44 wlanTS kernel: [ 1177.011780] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011786] ath: phy0: 
IQ_RES[0]=0xdf60802d IQ_RES[1]=0xe8f
Jan 15 08:43:44 wlanTS kernel: [ 1177.011791] ath: phy0: 
IQ_RES[2]=0x3fc3613 IQ_RES[3]=0x10b0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011797] ath: phy0: 
IQ_RES[4]=0xd00b003 IQ_RES[5]=0xfe11
Jan 15 08:43:44 wlanTS kernel: [ 1177.011798] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011799] ath: phy0: tx chain 0: mag 
corr=4  phase corr=2
Jan 15 08:43:44 wlanTS kernel: [ 1177.011800] ath: phy0: tx chain 0: iq 
corr coeff=202
Jan 15 08:43:44 wlanTS kernel: [ 1177.011801] ath: phy0: rx chain 0: mag 
corr=-2  phase corr=13
Jan 15 08:43:44 wlanTS kernel: [ 1177.011803] ath: phy0: rx chain 0: iq 
corr coeff=ffffff0d
Jan 15 08:43:44 wlanTS kernel: [ 1177.011804] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011809] ath: phy0: 
IQ_RES[0]=0xe658302e IQ_RES[1]=0xd2f
Jan 15 08:43:44 wlanTS kernel: [ 1177.011815] ath: phy0: 
IQ_RES[2]=0x6fb9592 IQ_RES[3]=0xf50
Jan 15 08:43:44 wlanTS kernel: [ 1177.011820] ath: phy0: 
IQ_RES[4]=0xf5007001 IQ_RES[5]=0xfe20
Jan 15 08:43:44 wlanTS kernel: [ 1177.011821] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011822] ath: phy0: tx chain 0: mag 
corr=2  phase corr=1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011823] ath: phy0: tx chain 0: iq 
corr coeff=101
Jan 15 08:43:44 wlanTS kernel: [ 1177.011825] ath: phy0: rx chain 0: mag 
corr=-3  phase corr=9
Jan 15 08:43:44 wlanTS kernel: [ 1177.011826] ath: phy0: rx chain 0: iq 
corr coeff=fffffe89
Jan 15 08:43:44 wlanTS kernel: [ 1177.011828] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011834] ath: phy0: 
IQ_RES[0]=0x145b003d IQ_RES[1]=0xe70
Jan 15 08:43:44 wlanTS kernel: [ 1177.011839] ath: phy0: 
IQ_RES[2]=0x1403e5be IQ_RES[3]=0x11c0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011844] ath: phy0: 
IQ_RES[4]=0x1e029006 IQ_RES[5]=0xfe81
Jan 15 08:43:44 wlanTS kernel: [ 1177.011845] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011846] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.011847] ath: phy0: tx chain 1: iq 
corr coeff=ffffff03
Jan 15 08:43:44 wlanTS kernel: [ 1177.011849] ath: phy0: rx chain 1: mag 
corr=-4  phase corr=-9
Jan 15 08:43:44 wlanTS kernel: [ 1177.011850] ath: phy0: rx chain 1: iq 
corr coeff=fffffdf7
Jan 15 08:43:44 wlanTS kernel: [ 1177.011851] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011857] ath: phy0: 
IQ_RES[0]=0x1457b03a IQ_RES[1]=0xdf0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011862] ath: phy0: 
IQ_RES[2]=0x1403e58a IQ_RES[3]=0x1110
Jan 15 08:43:44 wlanTS kernel: [ 1177.011867] ath: phy0: 
IQ_RES[4]=0x12028005 IQ_RES[5]=0xfe91
Jan 15 08:43:44 wlanTS kernel: [ 1177.011868] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011870] ath: phy0: tx chain 1: mag 
corr=-3  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.011871] ath: phy0: tx chain 1: iq 
corr coeff=fffffe83
Jan 15 08:43:44 wlanTS kernel: [ 1177.011872] ath: phy0: rx chain 1: mag 
corr=-4  phase corr=-10
Jan 15 08:43:44 wlanTS kernel: [ 1177.011873] ath: phy0: rx chain 1: iq 
corr coeff=fffffdf6
Jan 15 08:43:44 wlanTS kernel: [ 1177.011874] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011880] ath: phy0: 
IQ_RES[0]=0xe4ed039 IQ_RES[1]=0xca0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011885] ath: phy0: 
IQ_RES[2]=0x1103d4fb IQ_RES[3]=0xf40
Jan 15 08:43:44 wlanTS kernel: [ 1177.011890] ath: phy0: 
IQ_RES[4]=0xf6024004 IQ_RES[5]=0xfec0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011892] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011893] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=2
Jan 15 08:43:44 wlanTS kernel: [ 1177.011894] ath: phy0: tx chain 1: iq 
corr coeff=ffffff02
Jan 15 08:43:44 wlanTS kernel: [ 1177.011895] ath: phy0: rx chain 1: mag 
corr=-5  phase corr=-8
Jan 15 08:43:44 wlanTS kernel: [ 1177.011896] ath: phy0: rx chain 1: iq 
corr coeff=fffffd78
Jan 15 08:43:44 wlanTS kernel: [ 1177.011897] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011903] ath: phy0: 
IQ_RES[0]=0xb48a03c IQ_RES[1]=0xc60
Jan 15 08:43:44 wlanTS kernel: [ 1177.011908] ath: phy0: 
IQ_RES[2]=0x1002a499 IQ_RES[3]=0xdf0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011914] ath: phy0: 
IQ_RES[4]=0xe301f002 IQ_RES[5]=0xfeb0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011915] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011916] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011917] ath: phy0: tx chain 1: iq 
corr coeff=ffffff01
Jan 15 08:43:44 wlanTS kernel: [ 1177.011918] ath: phy0: rx chain 1: mag 
corr=-6  phase corr=-6
Jan 15 08:43:44 wlanTS kernel: [ 1177.011920] ath: phy0: rx chain 1: iq 
corr coeff=fffffcfa
Jan 15 08:43:44 wlanTS kernel: [ 1177.011921] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.011926] ath: phy0: 
IQ_RES[0]=0x1242f03c IQ_RES[1]=0xbd0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011932] ath: phy0: 
IQ_RES[2]=0x1001b43f IQ_RES[3]=0xce0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011937] ath: phy0: 
IQ_RES[4]=0xcf01a001 IQ_RES[5]=0xfea0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011938] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011939] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.011940] ath: phy0: tx chain 1: iq 
corr coeff=ffffff00
Jan 15 08:43:44 wlanTS kernel: [ 1177.011942] ath: phy0: rx chain 1: mag 
corr=-6  phase corr=-9
Jan 15 08:43:44 wlanTS kernel: [ 1177.011943] ath: phy0: rx chain 1: iq 
corr coeff=fffffcf7
Jan 15 08:43:44 wlanTS kernel: [ 1177.011959] ath: phy0: enabling IQ 
Calibration
Jan 15 08:43:44 wlanTS kernel: [ 1177.011961] ath: phy0: starting IQ 
Mismatch Calibration
Jan 15 08:43:44 wlanTS kernel: [ 1177.011975] ath: phy0: Enabled BB 
Watchdog timeout (25 ms)
Jan 15 08:43:44 wlanTS kernel: [ 1177.012015] ath: phy0: Enable MIB counters
Jan 15 08:43:44 wlanTS kernel: [ 1177.012021] ath: phy0: Restore 
history: opmode 2 chan 5180 Mhz is_scanning=0 ofdm:3 cck:2
Jan 15 08:43:44 wlanTS kernel: [ 1177.012022] ath: phy0: **** ofdmlevel 
3=>3, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1177.012024] ath: phy0: **** ccklevel 
2=>2, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1177.012033] ath: phy0: Starting ANI
Jan 15 08:43:44 wlanTS kernel: [ 1177.012045] ath: phy0: Set HW RX 
filter: 0x607
Jan 15 08:43:44 wlanTS kernel: [ 1177.012071] ath: phy0: Set HW Key
Jan 15 08:43:44 wlanTS kernel: [ 1177.012551] ath: phy0: Set HW Key
Jan 15 08:43:44 wlanTS kernel: [ 1177.012636] ath: phy0: BSSID 
00:00:00:00:00:00 Changed ASSOC 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.012639] ath: phy0: ah->misc_mode 
0x10000004
Jan 15 08:43:44 wlanTS kernel: [ 1177.012647] ath: phy0: Stopping ANI
Jan 15 08:43:44 wlanTS kernel: [ 1177.012649] ath: phy0: Configure tx 
[queue/halq] [0/0], aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.012653] ath: phy0: Configure tx 
[queue/halq] [1/1], aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.012657] ath: phy0: Configure tx 
[queue/halq] [2/2], aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.012661] ath: phy0: Configure tx 
[queue/halq] [3/3], aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.012666] ath: phy0: Set channel: 
5180 MHz width: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.012672] ath: phy0: Stopping ANI
Jan 15 08:43:44 wlanTS kernel: [ 1177.012701] ath: phy0: Disable MIB 
counters
Jan 15 08:43:44 wlanTS kernel: [ 1177.012721] ath: phy0: Reset to 5180 
MHz, HT40: 0 fastcc: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.012723] ath: phy0: NF did not 
complete in calibration window
Jan 15 08:43:44 wlanTS kernel: [ 1177.013672] ath: phy0: ver 448.4 
opmode 2 chan 5180 Mhz
Jan 15 08:43:44 wlanTS kernel: [ 1177.013681] ath: phy0: ah->misc_mode 
0x10000004
Jan 15 08:43:44 wlanTS kernel: [ 1177.015164] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015170] ath: phy0: 
IQ_RES[0]=0xdc75803a IQ_RES[1]=0x118f
Jan 15 08:43:44 wlanTS kernel: [ 1177.015175] ath: phy0: 
IQ_RES[2]=0x7fc6770 IQ_RES[3]=0x14b0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015180] ath: phy0: 
IQ_RES[4]=0x4d012004 IQ_RES[5]=0xfdb1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015182] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015183] ath: phy0: tx chain 0: mag 
corr=3  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.015184] ath: phy0: tx chain 0: iq 
corr coeff=183
Jan 15 08:43:44 wlanTS kernel: [ 1177.015186] ath: phy0: rx chain 0: mag 
corr=-2  phase corr=11
Jan 15 08:43:44 wlanTS kernel: [ 1177.015187] ath: phy0: rx chain 0: iq 
corr coeff=ffffff0b
Jan 15 08:43:44 wlanTS kernel: [ 1177.015188] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015194] ath: phy0: 
IQ_RES[0]=0xdf715032 IQ_RES[1]=0x10ff
Jan 15 08:43:44 wlanTS kernel: [ 1177.015199] ath: phy0: 
IQ_RES[2]=0x8fc7731 IQ_RES[3]=0x1400
Jan 15 08:43:44 wlanTS kernel: [ 1177.015204] ath: phy0: 
IQ_RES[4]=0x41010003 IQ_RES[5]=0xfdc1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015206] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015207] ath: phy0: tx chain 0: mag 
corr=2  phase corr=4
Jan 15 08:43:44 wlanTS kernel: [ 1177.015208] ath: phy0: tx chain 0: iq 
corr coeff=104
Jan 15 08:43:44 wlanTS kernel: [ 1177.015209] ath: phy0: rx chain 0: mag 
corr=-1  phase corr=9
Jan 15 08:43:44 wlanTS kernel: [ 1177.015210] ath: phy0: rx chain 0: iq 
corr coeff=ffffff89
Jan 15 08:43:44 wlanTS kernel: [ 1177.015211] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015217] ath: phy0: 
IQ_RES[0]=0xde67d02d IQ_RES[1]=0xfaf
Jan 15 08:43:44 wlanTS kernel: [ 1177.015222] ath: phy0: 
IQ_RES[2]=0x6fd168f IQ_RES[3]=0x1210
Jan 15 08:43:44 wlanTS kernel: [ 1177.015228] ath: phy0: 
IQ_RES[4]=0x24010002 IQ_RES[5]=0xfde1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015229] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015230] ath: phy0: tx chain 0: mag 
corr=2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.015231] ath: phy0: tx chain 0: iq 
corr coeff=103
Jan 15 08:43:44 wlanTS kernel: [ 1177.015232] ath: phy0: rx chain 0: mag 
corr=-1  phase corr=10
Jan 15 08:43:44 wlanTS kernel: [ 1177.015234] ath: phy0: rx chain 0: iq 
corr coeff=ffffff8a
Jan 15 08:43:44 wlanTS kernel: [ 1177.015235] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015241] ath: phy0: 
IQ_RES[0]=0xde609030 IQ_RES[1]=0xeff
Jan 15 08:43:44 wlanTS kernel: [ 1177.015246] ath: phy0: 
IQ_RES[2]=0x5fc6614 IQ_RES[3]=0x10b0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015251] ath: phy0: 
IQ_RES[4]=0xd00b002 IQ_RES[5]=0xfe11
Jan 15 08:43:44 wlanTS kernel: [ 1177.015252] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015253] ath: phy0: tx chain 0: mag 
corr=3  phase corr=2
Jan 15 08:43:44 wlanTS kernel: [ 1177.015255] ath: phy0: tx chain 0: iq 
corr coeff=182
Jan 15 08:43:44 wlanTS kernel: [ 1177.015256] ath: phy0: rx chain 0: mag 
corr=-2  phase corr=12
Jan 15 08:43:44 wlanTS kernel: [ 1177.015257] ath: phy0: rx chain 0: iq 
corr coeff=ffffff0c
Jan 15 08:43:44 wlanTS kernel: [ 1177.015258] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015264] ath: phy0: 
IQ_RES[0]=0xe758102d IQ_RES[1]=0xd2f
Jan 15 08:43:44 wlanTS kernel: [ 1177.015269] ath: phy0: 
IQ_RES[2]=0x4fb5596 IQ_RES[3]=0xf40
Jan 15 08:43:44 wlanTS kernel: [ 1177.015274] ath: phy0: 
IQ_RES[4]=0xf5006001 IQ_RES[5]=0xfe20
Jan 15 08:43:44 wlanTS kernel: [ 1177.015275] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015277] ath: phy0: tx chain 0: mag 
corr=3  phase corr=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015278] ath: phy0: tx chain 0: iq 
corr coeff=180
Jan 15 08:43:44 wlanTS kernel: [ 1177.015279] ath: phy0: rx chain 0: mag 
corr=-4  phase corr=10
Jan 15 08:43:44 wlanTS kernel: [ 1177.015280] ath: phy0: rx chain 0: iq 
corr coeff=fffffe0a
Jan 15 08:43:44 wlanTS kernel: [ 1177.015282] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015288] ath: phy0: 
IQ_RES[0]=0x135ad03e IQ_RES[1]=0xe70
Jan 15 08:43:44 wlanTS kernel: [ 1177.015293] ath: phy0: 
IQ_RES[2]=0x1403f5bf IQ_RES[3]=0x11b0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015298] ath: phy0: 
IQ_RES[4]=0x1d027005 IQ_RES[5]=0xfe91
Jan 15 08:43:44 wlanTS kernel: [ 1177.015299] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015301] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.015302] ath: phy0: tx chain 1: iq 
corr coeff=ffffff03
Jan 15 08:43:44 wlanTS kernel: [ 1177.015303] ath: phy0: rx chain 1: mag 
corr=-4  phase corr=-9
Jan 15 08:43:44 wlanTS kernel: [ 1177.015304] ath: phy0: rx chain 1: iq 
corr coeff=fffffdf7
Jan 15 08:43:44 wlanTS kernel: [ 1177.015305] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015311] ath: phy0: 
IQ_RES[0]=0x14576038 IQ_RES[1]=0xdb0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015316] ath: phy0: 
IQ_RES[2]=0x1303f587 IQ_RES[3]=0x1110
Jan 15 08:43:44 wlanTS kernel: [ 1177.015321] ath: phy0: 
IQ_RES[4]=0x13027005 IQ_RES[5]=0xfea1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015323] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015324] ath: phy0: tx chain 1: mag 
corr=-3  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.015325] ath: phy0: tx chain 1: iq 
corr coeff=fffffe83
Jan 15 08:43:44 wlanTS kernel: [ 1177.015326] ath: phy0: rx chain 1: mag 
corr=-4  phase corr=-10
Jan 15 08:43:44 wlanTS kernel: [ 1177.015327] ath: phy0: rx chain 1: iq 
corr coeff=fffffdf6
Jan 15 08:43:44 wlanTS kernel: [ 1177.015329] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015334] ath: phy0: 
IQ_RES[0]=0xe4eb037 IQ_RES[1]=0xc80
Jan 15 08:43:44 wlanTS kernel: [ 1177.015339] ath: phy0: 
IQ_RES[2]=0x1103d4f9 IQ_RES[3]=0xf30
Jan 15 08:43:44 wlanTS kernel: [ 1177.015345] ath: phy0: 
IQ_RES[4]=0xf4023002 IQ_RES[5]=0xfec0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015346] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015347] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015348] ath: phy0: tx chain 1: iq 
corr coeff=ffffff00
Jan 15 08:43:44 wlanTS kernel: [ 1177.015349] ath: phy0: rx chain 1: mag 
corr=-5  phase corr=-8
Jan 15 08:43:44 wlanTS kernel: [ 1177.015351] ath: phy0: rx chain 1: iq 
corr coeff=fffffd78
Jan 15 08:43:44 wlanTS kernel: [ 1177.015352] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015358] ath: phy0: 
IQ_RES[0]=0xe48403b IQ_RES[1]=0xc30
Jan 15 08:43:44 wlanTS kernel: [ 1177.015363] ath: phy0: 
IQ_RES[2]=0xf02b494 IQ_RES[3]=0xde0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015368] ath: phy0: 
IQ_RES[4]=0xe101f001 IQ_RES[5]=0xfeb0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015369] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015370] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015371] ath: phy0: tx chain 1: iq 
corr coeff=ffffff00
Jan 15 08:43:44 wlanTS kernel: [ 1177.015373] ath: phy0: rx chain 1: mag 
corr=-6  phase corr=-7
Jan 15 08:43:44 wlanTS kernel: [ 1177.015374] ath: phy0: rx chain 1: iq 
corr coeff=fffffcf9
Jan 15 08:43:44 wlanTS kernel: [ 1177.015375] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015381] ath: phy0: 
IQ_RES[0]=0x1342a03c IQ_RES[1]=0xbd0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015386] ath: phy0: 
IQ_RES[2]=0x10019439 IQ_RES[3]=0xce0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015391] ath: phy0: 
IQ_RES[4]=0xd001b001 IQ_RES[5]=0xfea0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015392] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015394] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015395] ath: phy0: tx chain 1: iq 
corr coeff=ffffff00
Jan 15 08:43:44 wlanTS kernel: [ 1177.015396] ath: phy0: rx chain 1: mag 
corr=-6  phase corr=-10
Jan 15 08:43:44 wlanTS kernel: [ 1177.015397] ath: phy0: rx chain 1: iq 
corr coeff=fffffcf6
Jan 15 08:43:44 wlanTS kernel: [ 1177.015413] ath: phy0: enabling IQ 
Calibration
Jan 15 08:43:44 wlanTS kernel: [ 1177.015415] ath: phy0: starting IQ 
Mismatch Calibration
Jan 15 08:43:44 wlanTS kernel: [ 1177.015430] ath: phy0: Enabled BB 
Watchdog timeout (25 ms)
Jan 15 08:43:44 wlanTS kernel: [ 1177.015470] ath: phy0: Enable MIB counters
Jan 15 08:43:44 wlanTS kernel: [ 1177.015476] ath: phy0: Restore 
history: opmode 2 chan 5180 Mhz is_scanning=0 ofdm:3 cck:2
Jan 15 08:43:44 wlanTS kernel: [ 1177.015477] ath: phy0: **** ofdmlevel 
3=>3, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1177.015479] ath: phy0: **** ccklevel 
2=>2, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1177.015560] wlan0: authenticate with 
04:f0:21:04:56:9e
Jan 15 08:43:44 wlanTS kernel: [ 1177.015567] ath: phy0: Set channel: 
5180 MHz width: 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.015573] ath: phy0: Stopping ANI
Jan 15 08:43:44 wlanTS kernel: [ 1177.015602] ath: phy0: Disable MIB 
counters
Jan 15 08:43:44 wlanTS kernel: [ 1177.015619] ath: phy0: Reset to 5180 
MHz, HT40: 0 fastcc: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.015621] ath: phy0: NF did not 
complete in calibration window
Jan 15 08:43:44 wlanTS kernel: [ 1177.016566] ath: phy0: ver 448.4 
opmode 2 chan 5180 Mhz
Jan 15 08:43:44 wlanTS kernel: [ 1177.016573] ath: phy0: ah->misc_mode 
0x10000004
Jan 15 08:43:44 wlanTS kernel: [ 1177.018056] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018062] ath: phy0: 
IQ_RES[0]=0xe1757038 IQ_RES[1]=0x117f
Jan 15 08:43:44 wlanTS kernel: [ 1177.018067] ath: phy0: 
IQ_RES[2]=0x8fcd773 IQ_RES[3]=0x14c0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018072] ath: phy0: 
IQ_RES[4]=0x4e013005 IQ_RES[5]=0xfd91
Jan 15 08:43:44 wlanTS kernel: [ 1177.018074] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018075] ath: phy0: tx chain 0: mag 
corr=2  phase corr=4
Jan 15 08:43:44 wlanTS kernel: [ 1177.018076] ath: phy0: tx chain 0: iq 
corr coeff=104
Jan 15 08:43:44 wlanTS kernel: [ 1177.018077] ath: phy0: rx chain 0: mag 
corr=-1  phase corr=10
Jan 15 08:43:44 wlanTS kernel: [ 1177.018078] ath: phy0: rx chain 0: iq 
corr coeff=ffffff8a
Jan 15 08:43:44 wlanTS kernel: [ 1177.018079] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018085] ath: phy0: 
IQ_RES[0]=0xdf717030 IQ_RES[1]=0x10ef
Jan 15 08:43:44 wlanTS kernel: [ 1177.018090] ath: phy0: 
IQ_RES[2]=0x7fcc72e IQ_RES[3]=0x1400
Jan 15 08:43:44 wlanTS kernel: [ 1177.018095] ath: phy0: 
IQ_RES[4]=0x41011003 IQ_RES[5]=0xfdc1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018097] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018098] ath: phy0: tx chain 0: mag 
corr=2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.018099] ath: phy0: tx chain 0: iq 
corr coeff=103
Jan 15 08:43:44 wlanTS kernel: [ 1177.018100] ath: phy0: rx chain 0: mag 
corr=-1  phase corr=9
Jan 15 08:43:44 wlanTS kernel: [ 1177.018101] ath: phy0: rx chain 0: iq 
corr coeff=ffffff89
Jan 15 08:43:44 wlanTS kernel: [ 1177.018102] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018108] ath: phy0: 
IQ_RES[0]=0xdd67902e IQ_RES[1]=0xfcf
Jan 15 08:43:44 wlanTS kernel: [ 1177.018113] ath: phy0: 
IQ_RES[2]=0x6fd168d IQ_RES[3]=0x1220
Jan 15 08:43:44 wlanTS kernel: [ 1177.018118] ath: phy0: 
IQ_RES[4]=0x24011001 IQ_RES[5]=0xfde1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018119] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018120] ath: phy0: tx chain 0: mag 
corr=2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.018122] ath: phy0: tx chain 0: iq 
corr coeff=103
Jan 15 08:43:44 wlanTS kernel: [ 1177.018123] ath: phy0: rx chain 0: mag 
corr=-2  phase corr=10
Jan 15 08:43:44 wlanTS kernel: [ 1177.018124] ath: phy0: rx chain 0: iq 
corr coeff=ffffff0a
Jan 15 08:43:44 wlanTS kernel: [ 1177.018125] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018131] ath: phy0: 
IQ_RES[0]=0xdc60a030 IQ_RES[1]=0xeaf
Jan 15 08:43:44 wlanTS kernel: [ 1177.018136] ath: phy0: 
IQ_RES[2]=0x5fc661b IQ_RES[3]=0x10b0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018141] ath: phy0: 
IQ_RES[4]=0xd00d000 IQ_RES[5]=0xfe01
Jan 15 08:43:44 wlanTS kernel: [ 1177.018143] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018145] ath: phy0: tx chain 0: mag 
corr=2  phase corr=2
Jan 15 08:43:44 wlanTS kernel: [ 1177.018146] ath: phy0: tx chain 0: iq 
corr coeff=102
Jan 15 08:43:44 wlanTS kernel: [ 1177.018148] ath: phy0: rx chain 0: mag 
corr=-3  phase corr=11
Jan 15 08:43:44 wlanTS kernel: [ 1177.018150] ath: phy0: rx chain 0: iq 
corr coeff=fffffe8b
Jan 15 08:43:44 wlanTS kernel: [ 1177.018152] ath: phy0: Doing Tx IQ Cal 
for chain 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018159] ath: phy0: 
IQ_RES[0]=0xe258a030 IQ_RES[1]=0xd7f
Jan 15 08:43:44 wlanTS kernel: [ 1177.018165] ath: phy0: 
IQ_RES[2]=0x7fb659b IQ_RES[3]=0xf30
Jan 15 08:43:44 wlanTS kernel: [ 1177.018171] ath: phy0: 
IQ_RES[4]=0xf5007002 IQ_RES[5]=0xfe20
Jan 15 08:43:44 wlanTS kernel: [ 1177.018173] ath: phy0: chain 0: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018175] ath: phy0: tx chain 0: mag 
corr=2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.018177] ath: phy0: tx chain 0: iq 
corr coeff=103
Jan 15 08:43:44 wlanTS kernel: [ 1177.018179] ath: phy0: rx chain 0: mag 
corr=-3  phase corr=11
Jan 15 08:43:44 wlanTS kernel: [ 1177.018180] ath: phy0: rx chain 0: iq 
corr coeff=fffffe8b
Jan 15 08:43:44 wlanTS kernel: [ 1177.018183] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018190] ath: phy0: 
IQ_RES[0]=0x145ae03e IQ_RES[1]=0xe90
Jan 15 08:43:44 wlanTS kernel: [ 1177.018196] ath: phy0: 
IQ_RES[2]=0x140405c6 IQ_RES[3]=0x11c0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018202] ath: phy0: 
IQ_RES[4]=0x20028005 IQ_RES[5]=0xfe81
Jan 15 08:43:44 wlanTS kernel: [ 1177.018204] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018206] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=2
Jan 15 08:43:44 wlanTS kernel: [ 1177.018208] ath: phy0: tx chain 1: iq 
corr coeff=ffffff02
Jan 15 08:43:44 wlanTS kernel: [ 1177.018210] ath: phy0: rx chain 1: mag 
corr=-4  phase corr=-9
Jan 15 08:43:44 wlanTS kernel: [ 1177.018212] ath: phy0: rx chain 1: iq 
corr coeff=fffffdf7
Jan 15 08:43:44 wlanTS kernel: [ 1177.018214] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018221] ath: phy0: 
IQ_RES[0]=0x1357c03a IQ_RES[1]=0xdf0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018227] ath: phy0: 
IQ_RES[2]=0x1304058f IQ_RES[3]=0x1120
Jan 15 08:43:44 wlanTS kernel: [ 1177.018233] ath: phy0: 
IQ_RES[4]=0x14027005 IQ_RES[5]=0xfea1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018235] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018237] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=3
Jan 15 08:43:44 wlanTS kernel: [ 1177.018239] ath: phy0: tx chain 1: iq 
corr coeff=ffffff03
Jan 15 08:43:44 wlanTS kernel: [ 1177.018241] ath: phy0: rx chain 1: mag 
corr=-4  phase corr=-9
Jan 15 08:43:44 wlanTS kernel: [ 1177.018243] ath: phy0: rx chain 1: iq 
corr coeff=fffffdf7
Jan 15 08:43:44 wlanTS kernel: [ 1177.018244] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018251] ath: phy0: 
IQ_RES[0]=0xd4ea03a IQ_RES[1]=0xc90
Jan 15 08:43:44 wlanTS kernel: [ 1177.018256] ath: phy0: 
IQ_RES[2]=0x1103f4f7 IQ_RES[3]=0xf30
Jan 15 08:43:44 wlanTS kernel: [ 1177.018261] ath: phy0: 
IQ_RES[4]=0xf5025003 IQ_RES[5]=0xfec0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018262] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018263] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018264] ath: phy0: tx chain 1: iq 
corr coeff=ffffff01
Jan 15 08:43:44 wlanTS kernel: [ 1177.018266] ath: phy0: rx chain 1: mag 
corr=-5  phase corr=-7
Jan 15 08:43:44 wlanTS kernel: [ 1177.018267] ath: phy0: rx chain 1: iq 
corr coeff=fffffd79
Jan 15 08:43:44 wlanTS kernel: [ 1177.018268] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018274] ath: phy0: 
IQ_RES[0]=0xb48703c IQ_RES[1]=0xc60
Jan 15 08:43:44 wlanTS kernel: [ 1177.018279] ath: phy0: 
IQ_RES[2]=0x1002a498 IQ_RES[3]=0xdf0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018284] ath: phy0: 
IQ_RES[4]=0xe201f001 IQ_RES[5]=0xfeb0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018285] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018286] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018287] ath: phy0: tx chain 1: iq 
corr coeff=ffffff00
Jan 15 08:43:44 wlanTS kernel: [ 1177.018288] ath: phy0: rx chain 1: mag 
corr=-6  phase corr=-7
Jan 15 08:43:44 wlanTS kernel: [ 1177.018289] ath: phy0: rx chain 1: iq 
corr coeff=fffffcf9
Jan 15 08:43:44 wlanTS kernel: [ 1177.018290] ath: phy0: Doing Tx IQ Cal 
for chain 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018296] ath: phy0: 
IQ_RES[0]=0x1242d03a IQ_RES[1]=0xbe0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018301] ath: phy0: 
IQ_RES[2]=0x1001c43c IQ_RES[3]=0xcd0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018306] ath: phy0: 
IQ_RES[4]=0xd101b002 IQ_RES[5]=0xfea0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018308] ath: phy0: chain 1: mag 
mismatch=0 phase mismatch=0
Jan 15 08:43:44 wlanTS kernel: [ 1177.018309] ath: phy0: tx chain 1: mag 
corr=-2  phase corr=1
Jan 15 08:43:44 wlanTS kernel: [ 1177.018310] ath: phy0: tx chain 1: iq 
corr coeff=ffffff01
Jan 15 08:43:44 wlanTS kernel: [ 1177.018311] ath: phy0: rx chain 1: mag 
corr=-6  phase corr=-9
Jan 15 08:43:44 wlanTS kernel: [ 1177.018312] ath: phy0: rx chain 1: iq 
corr coeff=fffffcf7
Jan 15 08:43:44 wlanTS kernel: [ 1177.018328] ath: phy0: enabling IQ 
Calibration
Jan 15 08:43:44 wlanTS kernel: [ 1177.018330] ath: phy0: starting IQ 
Mismatch Calibration
Jan 15 08:43:44 wlanTS kernel: [ 1177.018344] ath: phy0: Enabled BB 
Watchdog timeout (25 ms)
Jan 15 08:43:44 wlanTS kernel: [ 1177.018384] ath: phy0: Enable MIB counters
Jan 15 08:43:44 wlanTS kernel: [ 1177.018390] ath: phy0: Restore 
history: opmode 2 chan 5180 Mhz is_scanning=0 ofdm:3 cck:2
Jan 15 08:43:44 wlanTS kernel: [ 1177.018391] ath: phy0: **** ofdmlevel 
3=>3, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1177.018392] ath: phy0: **** ccklevel 
2=>2, rssi=23[lo=7 hi=40]
Jan 15 08:43:44 wlanTS kernel: [ 1177.018444] ath: phy0: Caching beacon 
data for BSS: 04:f0:21:04:56:9e
Jan 15 08:43:44 wlanTS kernel: [ 1177.018447] ath: phy0: STA is not yet 
associated..skipping beacon config
Jan 15 08:43:44 wlanTS kernel: [ 1177.018486] wlan0: send auth to 
04:f0:21:04:56:9e (try 1/3)
Jan 15 08:43:44 wlanTS kernel: [ 1177.018574] cfg80211: All devices are 
disconnected, going to restore regulatory settings
Jan 15 08:43:44 wlanTS kernel: [ 1177.018577] cfg80211: Restoring 
regulatory settings
Jan 15 08:43:44 wlanTS kernel: [ 1177.018580] cfg80211: Kicking the queue
Jan 15 08:43:44 wlanTS kernel: [ 1177.018582] cfg80211: Calling CRDA to 
update world regulatory domain
Jan 15 08:43:44 wlanTS kernel: [ 1177.019709] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/52/-35
Jan 15 08:43:44 wlanTS kernel: [ 1177.019748] wlan0: authenticated
Jan 15 08:43:44 wlanTS kernel: [ 1177.021122] wlan0: associate with 
04:f0:21:04:56:9e (try 1/3)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022060] cfg80211: Updating 
information on frequency 2412 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022063] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022065] cfg80211: Updating 
information on frequency 2417 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022066] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022067] cfg80211: Updating 
information on frequency 2422 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022069] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022070] cfg80211: Updating 
information on frequency 2427 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022071] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022073] cfg80211: Updating 
information on frequency 2432 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022074] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022075] cfg80211: Updating 
information on frequency 2437 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022077] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022078] cfg80211: Updating 
information on frequency 2442 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022079] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022080] cfg80211: Updating 
information on frequency 2447 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022082] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022083] cfg80211: Updating 
information on frequency 2452 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022084] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022085] cfg80211: Updating 
information on frequency 2457 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022087] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022088] cfg80211: Updating 
information on frequency 2462 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022089] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022090] cfg80211: Disabling freq 
2467 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022092] cfg80211: Disabling freq 
2472 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022093] cfg80211: Disabling freq 
2484 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022094] cfg80211: Updating 
information on frequency 5180 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022095] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022097] cfg80211: Updating 
information on frequency 5200 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022098] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022099] cfg80211: Updating 
information on frequency 5220 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022100] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022102] cfg80211: Updating 
information on frequency 5240 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022103] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022104] cfg80211: Updating 
information on frequency 5260 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022106] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022107] cfg80211: Updating 
information on frequency 5280 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022108] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022109] cfg80211: Updating 
information on frequency 5300 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022111] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022112] cfg80211: Updating 
information on frequency 5320 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022113] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022114] cfg80211: Updating 
information on frequency 5500 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022116] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022117] cfg80211: Updating 
information on frequency 5520 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022118] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022119] cfg80211: Updating 
information on frequency 5540 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022121] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022122] cfg80211: Updating 
information on frequency 5560 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022123] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022125] cfg80211: Updating 
information on frequency 5580 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022126] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022127] cfg80211: Disabling freq 
5600 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022128] cfg80211: Disabling freq 
5620 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022129] cfg80211: Disabling freq 
5640 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022130] cfg80211: Updating 
information on frequency 5660 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022132] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022133] cfg80211: Updating 
information on frequency 5680 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022134] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022135] cfg80211: Updating 
information on frequency 5700 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022137] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022138] cfg80211: Updating 
information on frequency 5745 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022139] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022141] cfg80211: Updating 
information on frequency 5765 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022142] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022143] cfg80211: Updating 
information on frequency 5785 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022144] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022146] cfg80211: Updating 
information on frequency 5805 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022147] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022148] cfg80211: Updating 
information on frequency 5825 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022149] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022154] cfg80211: Updating 
information on frequency 2412 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022155] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022156] cfg80211: Updating 
information on frequency 2417 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022158] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022159] cfg80211: Updating 
information on frequency 2422 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022160] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022161] cfg80211: Updating 
information on frequency 2427 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022163] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022164] cfg80211: Updating 
information on frequency 2432 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022165] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022167] cfg80211: Updating 
information on frequency 2437 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022168] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022169] cfg80211: Updating 
information on frequency 2442 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022170] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022172] cfg80211: Updating 
information on frequency 2447 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022173] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022174] cfg80211: Updating 
information on frequency 2452 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022176] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022177] cfg80211: Updating 
information on frequency 2457 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022178] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022179] cfg80211: Updating 
information on frequency 2462 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022181] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022182] cfg80211: Disabling freq 
2467 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022183] cfg80211: Disabling freq 
2472 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022184] cfg80211: Disabling freq 
2484 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022185] cfg80211: Updating 
information on frequency 5180 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022186] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022188] cfg80211: Updating 
information on frequency 5200 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022189] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022190] cfg80211: Updating 
information on frequency 5220 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022191] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022193] cfg80211: Updating 
information on frequency 5240 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022194] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022195] cfg80211: Updating 
information on frequency 5260 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022197] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022198] cfg80211: Updating 
information on frequency 5280 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022199] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022200] cfg80211: Updating 
information on frequency 5300 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022202] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022203] cfg80211: Updating 
information on frequency 5320 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022204] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022206] cfg80211: Updating 
information on frequency 5500 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022207] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022208] cfg80211: Updating 
information on frequency 5520 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022209] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022211] cfg80211: Updating 
information on frequency 5540 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022212] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022213] cfg80211: Updating 
information on frequency 5560 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022215] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022216] cfg80211: Updating 
information on frequency 5580 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022217] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022218] cfg80211: Disabling freq 
5600 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022219] cfg80211: Disabling freq 
5620 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022220] cfg80211: Disabling freq 
5640 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022221] cfg80211: Updating 
information on frequency 5660 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022223] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022224] cfg80211: Updating 
information on frequency 5680 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022225] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022226] cfg80211: Updating 
information on frequency 5700 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022228] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022229] cfg80211: Updating 
information on frequency 5745 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022230] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022231] cfg80211: Updating 
information on frequency 5765 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022233] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022234] cfg80211: Updating 
information on frequency 5785 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022235] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022236] cfg80211: Updating 
information on frequency 5805 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022238] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022239] cfg80211: Updating 
information on frequency 5825 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022240] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022243] cfg80211: Updating 
information on frequency 2412 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022245] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022246] cfg80211: Updating 
information on frequency 2417 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022247] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022249] cfg80211: Updating 
information on frequency 2422 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022250] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022251] cfg80211: Updating 
information on frequency 2427 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022253] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022254] cfg80211: Updating 
information on frequency 2432 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022255] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022256] cfg80211: Updating 
information on frequency 2437 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022258] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022259] cfg80211: Updating 
information on frequency 2442 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022260] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022261] cfg80211: Updating 
information on frequency 2447 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022263] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022264] cfg80211: Updating 
information on frequency 2452 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022265] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022266] cfg80211: Updating 
information on frequency 2457 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022268] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022269] cfg80211: Updating 
information on frequency 2462 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022270] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022271] cfg80211: Disabling freq 
2467 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022272] cfg80211: Disabling freq 
2472 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022273] cfg80211: Disabling freq 
2484 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022275] cfg80211: Updating 
information on frequency 5180 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022276] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022277] cfg80211: Updating 
information on frequency 5200 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022279] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022280] cfg80211: Updating 
information on frequency 5220 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022281] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022282] cfg80211: Updating 
information on frequency 5240 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022284] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022285] cfg80211: Updating 
information on frequency 5260 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022286] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022287] cfg80211: Updating 
information on frequency 5280 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022289] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022290] cfg80211: Updating 
information on frequency 5300 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022291] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022292] cfg80211: Updating 
information on frequency 5320 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022294] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022295] cfg80211: Updating 
information on frequency 5500 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022296] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022298] cfg80211: Updating 
information on frequency 5520 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022299] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022300] cfg80211: Updating 
information on frequency 5540 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022302] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022303] cfg80211: Updating 
information on frequency 5560 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022304] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022305] cfg80211: Updating 
information on frequency 5580 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022307] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022308] cfg80211: Disabling freq 
5600 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022309] cfg80211: Disabling freq 
5620 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022310] cfg80211: Disabling freq 
5640 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022311] cfg80211: Updating 
information on frequency 5660 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022312] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022313] cfg80211: Updating 
information on frequency 5680 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022315] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022316] cfg80211: Updating 
information on frequency 5700 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022317] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022319] cfg80211: Updating 
information on frequency 5745 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022320] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022321] cfg80211: Updating 
information on frequency 5765 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022322] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022324] cfg80211: Updating 
information on frequency 5785 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022325] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022326] cfg80211: Updating 
information on frequency 5805 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022327] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022329] cfg80211: Updating 
information on frequency 5825 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022330] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022333] cfg80211: Updating 
information on frequency 2412 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022334] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022335] cfg80211: Updating 
information on frequency 2417 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022337] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022338] cfg80211: Updating 
information on frequency 2422 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022339] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022341] cfg80211: Updating 
information on frequency 2427 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022342] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022343] cfg80211: Updating 
information on frequency 2432 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022344] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022346] cfg80211: Updating 
information on frequency 2437 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022347] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022348] cfg80211: Updating 
information on frequency 2442 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022350] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022351] cfg80211: Updating 
information on frequency 2447 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022352] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022353] cfg80211: Updating 
information on frequency 2452 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022355] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022356] cfg80211: Updating 
information on frequency 2457 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022357] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022358] cfg80211: Updating 
information on frequency 2462 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022360] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022361] cfg80211: Disabling freq 
2467 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022362] cfg80211: Disabling freq 
2472 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022363] cfg80211: Disabling freq 
2484 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022364] cfg80211: Updating 
information on frequency 5180 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022365] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022367] cfg80211: Updating 
information on frequency 5200 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022368] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022369] cfg80211: Updating 
information on frequency 5220 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022370] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022372] cfg80211: Updating 
information on frequency 5240 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022373] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022374] cfg80211: Updating 
information on frequency 5260 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022376] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022377] cfg80211: Updating 
information on frequency 5280 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022378] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022379] cfg80211: Updating 
information on frequency 5300 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022381] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022382] cfg80211: Updating 
information on frequency 5320 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022383] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022384] cfg80211: Updating 
information on frequency 5500 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022386] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022387] cfg80211: Updating 
information on frequency 5520 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022388] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022390] cfg80211: Updating 
information on frequency 5540 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022391] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022392] cfg80211: Updating 
information on frequency 5560 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022393] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022395] cfg80211: Updating 
information on frequency 5580 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022396] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022397] cfg80211: Disabling freq 
5600 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022398] cfg80211: Disabling freq 
5620 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022399] cfg80211: Disabling freq 
5640 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022400] cfg80211: Updating 
information on frequency 5660 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022401] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022403] cfg80211: Updating 
information on frequency 5680 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022404] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022405] cfg80211: Updating 
information on frequency 5700 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022406] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022408] cfg80211: Updating 
information on frequency 5745 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022409] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022410] cfg80211: Updating 
information on frequency 5765 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022411] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022413] cfg80211: Updating 
information on frequency 5785 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022414] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022415] cfg80211: Updating 
information on frequency 5805 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022416] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022418] cfg80211: Updating 
information on frequency 5825 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022419] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022422] cfg80211: Updating 
information on frequency 2412 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022423] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022424] cfg80211: Updating 
information on frequency 2417 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022426] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022427] cfg80211: Updating 
information on frequency 2422 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022428] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022430] cfg80211: Updating 
information on frequency 2427 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022431] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022432] cfg80211: Updating 
information on frequency 2432 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022433] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022435] cfg80211: Updating 
information on frequency 2437 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022436] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022437] cfg80211: Updating 
information on frequency 2442 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022438] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022440] cfg80211: Updating 
information on frequency 2447 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022441] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022442] cfg80211: Updating 
information on frequency 2452 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022443] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022445] cfg80211: Updating 
information on frequency 2457 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022446] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022447] cfg80211: Updating 
information on frequency 2462 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022448] cfg80211: 2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022449] cfg80211: Disabling freq 
2467 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022450] cfg80211: Disabling freq 
2472 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022452] cfg80211: Disabling freq 
2484 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022453] cfg80211: Updating 
information on frequency 5180 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022454] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022455] cfg80211: Updating 
information on frequency 5200 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022457] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022458] cfg80211: Updating 
information on frequency 5220 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022459] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022460] cfg80211: Updating 
information on frequency 5240 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022462] cfg80211: 5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022463] cfg80211: Updating 
information on frequency 5260 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022464] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022465] cfg80211: Updating 
information on frequency 5280 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022467] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022468] cfg80211: Updating 
information on frequency 5300 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022469] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022470] cfg80211: Updating 
information on frequency 5320 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022472] cfg80211: 5250000 KHz - 
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022473] cfg80211: Updating 
information on frequency 5500 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022474] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022475] cfg80211: Updating 
information on frequency 5520 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022477] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022478] cfg80211: Updating 
information on frequency 5540 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022479] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022480] cfg80211: Updating 
information on frequency 5560 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022482] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022483] cfg80211: Updating 
information on frequency 5580 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022484] cfg80211: 5490000 KHz - 
5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022485] cfg80211: Disabling freq 
5600 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022486] cfg80211: Disabling freq 
5620 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022487] cfg80211: Disabling freq 
5640 MHz
Jan 15 08:43:44 wlanTS kernel: [ 1177.022488] cfg80211: Updating 
information on frequency 5660 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022490] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022491] cfg80211: Updating 
information on frequency 5680 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022492] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022494] cfg80211: Updating 
information on frequency 5700 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022495] cfg80211: 5650000 KHz - 
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022496] cfg80211: Updating 
information on frequency 5745 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022497] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022499] cfg80211: Updating 
information on frequency 5765 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022500] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022501] cfg80211: Updating 
information on frequency 5785 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022502] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022504] cfg80211: Updating 
information on frequency 5805 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022505] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022506] cfg80211: Updating 
information on frequency 5825 MHz with regulatory rule:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022507] cfg80211: 5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022523] cfg80211: World regulatory 
domain updated:
Jan 15 08:43:44 wlanTS kernel: [ 1177.022525] cfg80211:  DFS Master 
region: unset
Jan 15 08:43:44 wlanTS kernel: [ 1177.022526] cfg80211: (start_freq - 
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022527] cfg80211:   (2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022529] cfg80211:   (2457000 KHz - 
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022530] cfg80211:   (2474000 KHz - 
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022531] cfg80211:   (5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.022533] cfg80211:   (5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 15 08:43:44 wlanTS kernel: [ 1177.023036] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/54/-33
Jan 15 08:43:44 wlanTS kernel: [ 1177.023052] wlan0: RX AssocResp from 
04:f0:21:04:56:9e (capab=0x11 status=0 aid=1)
Jan 15 08:43:44 wlanTS kernel: [ 1177.023060] ath: phy0: Configure tx 
[queue/halq] [2/2], aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.023066] ath: phy0: Configure tx 
[queue/halq] [3/3], aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
Jan 15 08:43:44 wlanTS kernel: [ 1177.023070] ath: phy0: Configure tx 
[queue/halq] [1/1], aifs: 2, cw_min: 7, cw_max: 15, txop: 94
Jan 15 08:43:44 wlanTS kernel: [ 1177.023074] ath: phy0: Configure tx 
[queue/halq] [0/0], aifs: 2, cw_min: 3, cw_max: 7, txop: 47
Jan 15 08:43:44 wlanTS kernel: [ 1177.023078] ath: phy0: BSSID 
04:f0:21:04:56:9e Changed ASSOC 1
Jan 15 08:43:44 wlanTS kernel: [ 1177.023079] ath: phy0: Primary Station 
interface: 00:14:5a:02:30:96, BSSID: 04:f0:21:04:56:9e
Jan 15 08:43:44 wlanTS kernel: [ 1177.023080] ath: phy0: ah->misc_mode 
0x10000004
Jan 15 08:43:44 wlanTS kernel: [ 1177.023097] ath: phy0: Starting ANI
Jan 15 08:43:44 wlanTS kernel: [ 1177.023103] wlan0: associated
Jan 15 08:43:44 wlanTS kernel: [ 1177.023130] cfg80211: Calling CRDA for 
country: XA
Jan 15 08:43:44 wlanTS kernel: [ 1177.026210] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/53/-34
Jan 15 08:43:44 wlanTS kernel: [ 1177.028515] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/55/-32
Jan 15 08:43:44 wlanTS kernel: [ 1177.028768] ath: phy0: Set HW Key
Jan 15 08:43:44 wlanTS kernel: [ 1177.028827] ath: phy0: Set HW Key
Jan 15 08:43:44 wlanTS kernel: [ 1177.032695] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/53/-34
Jan 15 08:43:44 wlanTS kernel: [ 1177.032710] ath: phy0: bmiss: 10 
sleep: 15360
Jan 15 08:43:44 wlanTS kernel: [ 1177.032716] ath: phy0: next DTIM 106306560
Jan 15 08:43:44 wlanTS kernel: [ 1177.032717] ath: phy0: next beacon 
106306560
Jan 15 08:43:44 wlanTS kernel: [ 1177.032718] ath: phy0: beacon period 15360
Jan 15 08:43:44 wlanTS kernel: [ 1177.032719] ath: phy0: DTIM period 15360
Jan 15 08:43:44 wlanTS kernel: [ 1177.032749] cfg80211: Found new beacon 
on frequency: 5180 MHz (Ch 36) on phy0
Jan 15 08:43:44 wlanTS kernel: [ 1177.032758] cfg80211: Pending 
regulatory request, waiting for it to be processed...
Jan 15 08:43:44 wlanTS kernel: [ 1177.048561] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/39/-48
Jan 15 08:43:44 wlanTS kernel: [ 1177.063921] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/37/-50
Jan 15 08:43:44 wlanTS kernel: [ 1177.079283] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/33/-54
Jan 15 08:43:44 wlanTS kernel: [ 1177.094642] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/34/-53
Jan 15 08:43:44 wlanTS kernel: [ 1177.110001] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/31/-56
Jan 15 08:43:44 wlanTS kernel: [ 1177.125360] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/31/-56
Jan 15 08:43:44 wlanTS kernel: [ 1177.140722] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/31/-56
Jan 15 08:43:44 wlanTS kernel: [ 1177.156083] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/31/-56
Jan 15 08:43:44 wlanTS kernel: [ 1177.171442] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/31/-56
Jan 15 08:43:44 wlanTS kernel: [ 1177.186802] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/32/-55
Jan 15 08:43:44 wlanTS kernel: [ 1177.202162] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/32/-55
Jan 15 08:43:44 wlanTS kernel: [ 1177.217522] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/36/-51
Jan 15 08:43:44 wlanTS kernel: [ 1177.232883] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/35/-52
Jan 15 08:43:44 wlanTS kernel: [ 1177.248243] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/36/-51
Jan 15 08:43:44 wlanTS kernel: [ 1177.263602] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/38/-49
Jan 15 08:43:44 wlanTS kernel: [ 1177.278963] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/39/-48
Jan 15 08:43:44 wlanTS kernel: [ 1177.294323] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/41/-46
Jan 15 08:43:44 wlanTS kernel: [ 1177.295113] NOISE/RSSI/SIGNAL for 
00:14:5a:02:10:2d: -87/42/-45
Jan 15 08:43:44 wlanTS kernel: [ 1177.309684] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/42/-45
Jan 15 08:43:44 wlanTS kernel: [ 1177.325044] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/41/-46
Jan 15 08:43:44 wlanTS kernel: [ 1177.340404] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/40/-47
Jan 15 08:43:44 wlanTS kernel: [ 1177.355763] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/39/-48
Jan 15 08:43:44 wlanTS kernel: [ 1177.371124] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/37/-50
Jan 15 08:43:44 wlanTS kernel: [ 1177.386484] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/35/-52
Jan 15 08:43:44 wlanTS kernel: [ 1177.394873] NOISE/RSSI/SIGNAL for 
00:14:5a:02:10:2d: -87/35/-52
Jan 15 08:43:44 wlanTS kernel: [ 1177.401844] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/36/-51
Jan 15 08:43:44 wlanTS kernel: [ 1177.417203] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/33/-54
Jan 15 08:43:44 wlanTS kernel: [ 1177.432564] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/33/-54
Jan 15 08:43:44 wlanTS kernel: [ 1177.447924] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/30/-57
Jan 15 08:43:44 wlanTS kernel: [ 1177.463285] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/30/-57
Jan 15 08:43:44 wlanTS kernel: [ 1177.478645] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/29/-58
Jan 15 08:43:44 wlanTS kernel: [ 1177.494005] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/29/-58
Jan 15 08:43:44 wlanTS kernel: [ 1177.509363] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/32/-55
Jan 15 08:43:44 wlanTS kernel: [ 1177.524724] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/29/-58
Jan 15 08:43:44 wlanTS kernel: [ 1177.540085] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/32/-55
Jan 15 08:43:44 wlanTS kernel: [ 1177.555446] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/32/-55
Jan 15 08:43:44 wlanTS kernel: [ 1177.570805] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/33/-54
Jan 15 08:43:44 wlanTS kernel: [ 1177.586164] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/35/-52
Jan 15 08:43:44 wlanTS kernel: [ 1177.601525] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/34/-53
Jan 15 08:43:45 wlanTS kernel: [ 1177.616885] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/38/-49
Jan 15 08:43:45 wlanTS kernel: [ 1177.632244] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/39/-48
Jan 15 08:43:45 wlanTS kernel: [ 1177.647606] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/41/-46
Jan 15 08:43:45 wlanTS kernel: [ 1177.662965] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/40/-47
Jan 15 08:43:45 wlanTS kernel: [ 1177.678326] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/39/-48
Jan 15 08:43:45 wlanTS kernel: [ 1177.693686] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/39/-48
Jan 15 08:43:45 wlanTS kernel: [ 1177.705891] NOISE/RSSI/SIGNAL for 
00:14:5a:02:10:2d: -87/41/-46
Jan 15 08:43:45 wlanTS kernel: [ 1177.709046] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/40/-47
Jan 15 08:43:45 wlanTS kernel: [ 1177.724405] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/38/-49
Jan 15 08:43:45 wlanTS kernel: [ 1177.739766] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/39/-48
Jan 15 08:43:45 wlanTS kernel: [ 1177.755126] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/41/-46
Jan 15 08:43:45 wlanTS kernel: [ 1177.770486] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/41/-46
Jan 15 08:43:45 wlanTS kernel: [ 1177.785847] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/40/-47
Jan 15 08:43:45 wlanTS kernel: [ 1177.801206] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/40/-47
Jan 15 08:43:45 wlanTS kernel: [ 1177.816566] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/35/-52
Jan 15 08:43:45 wlanTS kernel: [ 1177.831932] NOISE/RSSI/SIGNAL for 
04:f0:21:04:56:9e: -87/36/-51


