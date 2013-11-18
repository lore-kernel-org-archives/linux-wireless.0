Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:61430 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab3KRNGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 08:06:20 -0500
Message-ID: <528A0F79.1040807@neratec.com> (sfid-20131118_140624_330027_DBD7F95A)
Date: Mon, 18 Nov 2013 14:00:41 +0100
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Sven Eckelmann <sven@open-mesh.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <simon@open-mesh.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [OpenWrt-Devel] ath9k: Deaf QCA9558 when setting
 rxchainmask
References: <19772470.YgPhAz9cYD@bentobox> <87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de> <CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com> <2985619.kldLYNDlSX@bentobox> <21120.58000.344447.562435@gargle.gargle.HOWL>
In-Reply-To: <21120.58000.344447.562435@gargle.gargle.HOWL>
Content-Type: multipart/mixed;
 boundary="------------080603070100040801040609"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080603070100040801040609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/13 14:58, Sujith Manoharan wrote:
> Sven Eckelmann wrote:
>> You are talking about ar9003_phy.c -> ar9003_hw_set_chain_masks? No, the
>> device is 3x3 and ah->caps.tx_chainmask & ah->caps.rx_chainmask are 7 and not
>> 5. The AR_PHY_ANALOG_SWAP := AR_PHY_SWAP_ALT_CHAIN is only done when one of
>> them would be 5. But I am not really sure what this register setting is really
>> doing. Maybe you can explain it when you think it could be related. Thanks
> "0x5" chainmask is an invalid mask for AR9300 - for all revisions, including AR9580.
>
> If a 2-stream card is required based on AR9300 for custom designs, the only
> way is to use Chain 0 and Chain 2, since there are HW limitations with Chain 1.
> In this case, a chainmask of 0x7 has to be used and the middle chain disabled in the
> driver. This is done by a few vendors who use the 5Ghz AR9580 radio but want 2x2
> instead of the usual 3x3.
>
> Sujith
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
Hi Sujith
I'm in the position where i want to use a 9390 as 2x2 instead of 3x3.
I use backports-3.12-1.
I've set the rx and tx mask in eeprom to 0x5.
Every 30 seconds there is a short disconnect.
Enabling some logging in
echo "0x0000050C" > /sys/kernel/debug/ieee80211/phy0/ath9k/debug
shows that something seems to go wrong during noise calibration. (See 
attached log).
What seems odd to me, that for IQ cal it tries to calibrate chain 1 
instead of chain 2.

Best regards
Matthias May

-- 
Matthias May
Software Engineer

Neratec Solutions AG
Postfach 83, CH-8608 Bubikon, Switzerland
Direct: +41 55 253 2074
Office: +41 55 253 2000
Fax:    +41 55 253 2070
email:  matthias.may@neratec.com
Web:   www.neratec.com


--------------080603070100040801040609
Content-Type: text/plain; charset=UTF-8;
 name="log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="log.txt"

Nov 18 13:39:45 CHD500279 kernel: [16510.563596] ath: phy11: 0: Chn 0 pmi=0x0f3a64d3;pmq=0x0dcc5afb;iqcm=0xffa7b633;
Nov 18 13:39:45 CHD500279 kernel: [16510.563608] ath: phy11: 0: Chn 2 pmi=0x00000000;pmq=0x00000000;iqcm=0x00000000;
Nov 18 13:39:45 CHD500279 kernel: [16510.563612] ath: phy11: Starting IQ Cal and Correction for Chain 0
Nov 18 13:39:45 CHD500279 kernel: [16510.563615] ath: phy11: Original: Chn 0 iq_corr_meas = 0xffa7b633
Nov 18 13:39:45 CHD500279 kernel: [16510.563619] ath: phy11: Chn 0 pwr_meas_i = 0x0f3a64d3
Nov 18 13:39:45 CHD500279 kernel: [16510.563622] ath: phy11: Chn 0 pwr_meas_q = 0x0dcc5afb
Nov 18 13:39:45 CHD500279 kernel: [16510.563625] ath: phy11: iqCorrNeg is 0x00000001
Nov 18 13:39:45 CHD500279 kernel: [16510.563628] ath: phy11: Chn 0 iCoff = 0x00000006
Nov 18 13:39:45 CHD500279 kernel: [16510.563631] ath: phy11: Chn 0 qCoff = 0x00000006
Nov 18 13:39:45 CHD500279 kernel: [16510.563635] ath: phy11: Chn 0 : iCoff = 0x6  qCoff = 0x6
Nov 18 13:39:45 CHD500279 kernel: [16510.563640] ath: phy11: Register offset (0x98dc) before update = 0x20000000
Nov 18 13:39:45 CHD500279 kernel: [16510.563649] ath: phy11: Register offset (0x98dc) QI COFF (bitfields 0x00003f80) after update = 0x20000306
Nov 18 13:39:45 CHD500279 kernel: [16510.563655] ath: phy11: Register offset (0x98dc) QQ COFF (bitfields 0x0000007f) after update = 0x20000306
Nov 18 13:39:45 CHD500279 kernel: [16510.563658] ath: phy11: IQ Cal and Correction done for Chain 0
Nov 18 13:39:45 CHD500279 kernel: [16510.563661] ath: phy11: Starting IQ Cal and Correction for Chain 1
Nov 18 13:39:45 CHD500279 kernel: [16510.563664] ath: phy11: Original: Chn 1 iq_corr_meas = 0x00000000
Nov 18 13:39:45 CHD500279 kernel: [16510.563667] ath: phy11: Chn 1 pwr_meas_i = 0x00000000
Nov 18 13:39:45 CHD500279 kernel: [16510.563670] ath: phy11: Chn 1 pwr_meas_q = 0x00000000
Nov 18 13:39:45 CHD500279 kernel: [16510.563673] ath: phy11: iqCorrNeg is 0x00000000
Nov 18 13:39:45 CHD500279 kernel: [16510.563681] ath: phy11: IQ Cal and Correction (offset 0x98dc) enabled (bit position 0x00004000). New Value 0x20004306
Nov 18 13:39:45 CHD500279 kernel: [16510.563694] ath: phy11: NF calibrated [ctl] [chain 0] is -105
Nov 18 13:39:45 CHD500279 kernel: [16510.563698] ath: phy11: NF calibrated [ctl] [chain 2] is -50
Nov 18 13:39:45 CHD500279 kernel: [16510.563701] ath: phy11: NF[2] (-50) > MAX (-100), correcting to MAX
Nov 18 13:39:45 CHD500279 kernel: [16510.563705] ath: phy11: NF calibrated [ext] [chain 0] is -105
Nov 18 13:39:45 CHD500279 kernel: [16510.563708] ath: phy11: NF calibrated [ext] [chain 2] is -50
Nov 18 13:39:45 CHD500279 kernel: [16510.563712] ath: phy11: NF[5] (-50) > MAX (-100), correcting to MAX
Nov 18 13:39:47 CHD500279 kernel: [16512.019747] wlan11: Failed to send nullfunc to AP 00:80:48:70:bd:70 after 500ms, disconnecting
Nov 18 13:39:47 CHD500279 kernel: [16512.057562] wlan11: moving STA 00:80:48:70:bd:70 to state 3
Nov 18 13:39:47 CHD500279 kernel: [16512.057569] wlan11: moving STA 00:80:48:70:bd:70 to state 2
Nov 18 13:39:47 CHD500279 kernel: [16512.057576] wlan11: moving STA 00:80:48:70:bd:70 to state 1
Nov 18 13:39:47 CHD500279 kernel: [16512.057579] wlan11: Removed STA 00:80:48:70:bd:70
Nov 18 13:39:47 CHD500279 kernel: [16512.057842] ath: phy11: NF calibrated [ctl] [chain 0] is -105
Nov 18 13:39:47 CHD500279 kernel: [16512.057847] ath: phy11: NF calibrated [ctl] [chain 2] is -50
Nov 18 13:39:47 CHD500279 kernel: [16512.057851] ath: phy11: NF[2] (-50) > MAX (-100), correcting to MAX
Nov 18 13:39:47 CHD500279 kernel: [16512.058278] ath: phy11: ch=0 f=5180 low=5180 -29 h=5180 -29
Nov 18 13:39:47 CHD500279 kernel: [16512.058282] ath: phy11: ch=1 f=5180 low=5180 -30 h=5180 -30
Nov 18 13:39:47 CHD500279 kernel: [16512.058286] ath: phy11: ch=2 f=5180 low=5180 -24 h=5180 -24
Nov 18 13:39:47 CHD500279 kernel: [16512.058301] ath: phy11: for frequency=5180, calibration correction = -29 -30 -24
Nov 18 13:39:47 CHD500279 wpa_supplicant[3216]: wlan11: CTRL-EVENT-DISCONNECTED bssid=00:80:48:70:bd:70 reason=4
Nov 18 13:39:47 CHD500279 kernel: [16512.059944] ath: phy11: Doing Tx IQ Cal for chain 0
Nov 18 13:39:47 CHD500279 kernel: [16512.059958] ath: phy11: IQ_RES[0]=0xd243f03a IQ_RES[1]=0xb6f
Nov 18 13:39:47 CHD500279 kernel: [16512.059970] ath: phy11: IQ_RES[2]=0x10fa2450 IQ_RES[3]=0xc80
Nov 18 13:39:47 CHD500279 kernel: [16512.059981] ath: phy11: IQ_RES[4]=0xcb010ffb IQ_RES[5]=0xfe20
Nov 18 13:39:47 CHD500279 kernel: [16512.059985] ath: phy11: chain 0: mag mismatch=0 phase mismatch=0
Nov 18 13:39:47 CHD500279 kernel: [16512.059989] ath: phy11: tx chain 0: mag corr=0  phase corr=7
Nov 18 13:39:47 CHD500279 kernel: [16512.059992] ath: phy11: tx chain 0: iq corr coeff=7
Nov 18 13:39:47 CHD500279 kernel: [16512.059995] ath: phy11: rx chain 0: mag corr=-3  phase corr=12
Nov 18 13:39:47 CHD500279 kernel: [16512.059999] ath: phy11: rx chain 0: iq corr coeff=fffffe8c
Nov 18 13:39:47 CHD500279 kernel: [16512.060002] ath: phy11: Doing Tx IQ Cal for chain 0
Nov 18 13:39:47 CHD500279 kernel: [16512.060015] ath: phy11: IQ_RES[0]=0xd4419038 IQ_RES[1]=0xb0f
Nov 18 13:39:47 CHD500279 kernel: [16512.060026] ath: phy11: IQ_RES[2]=0xffa4429 IQ_RES[3]=0xc00
Nov 18 13:39:47 CHD500279 kernel: [16512.060038] ath: phy11: IQ_RES[4]=0xc300fffb IQ_RES[5]=0xfe30
Nov 18 13:39:47 CHD500279 kernel: [16512.060041] ath: phy11: chain 0: mag mismatch=0 phase mismatch=0
Nov 18 13:39:47 CHD500279 kernel: [16512.060045] ath: phy11: tx chain 0: mag corr=0  phase corr=6
Nov 18 13:39:47 CHD500279 kernel: [16512.060048] ath: phy11: tx chain 0: iq corr coeff=6
Nov 18 13:39:47 CHD500279 kernel: [16512.060051] ath: phy11: rx chain 0: mag corr=-3  phase corr=12
Nov 18 13:39:47 CHD500279 kernel: [16512.060055] ath: phy11: rx chain 0: iq corr coeff=fffffe8c
Nov 18 13:39:47 CHD500279 kernel: [16512.060058] ath: phy11: Doing Tx IQ Cal for chain 0
Nov 18 13:39:47 CHD500279 kernel: [16512.060071] ath: phy11: IQ_RES[0]=0xac76206b IQ_RES[1]=0x14cf
Nov 18 13:39:47 CHD500279 kernel: [16512.060082] ath: phy11: IQ_RES[2]=0x1bf66787 IQ_RES[3]=0x15b0
Nov 18 13:39:47 CHD500279 kernel: [16512.060093] ath: phy11: IQ_RES[4]=0x6101eff5 IQ_RES[5]=0xfca1
Nov 18 13:39:47 CHD500279 kernel: [16512.060097] ath: phy11: chain 0: mag mismatch=0 phase mismatch=0
Nov 18 13:39:47 CHD500279 kernel: [16512.060100] ath: phy11: tx chain 0: mag corr=0  phase corr=5
Nov 18 13:39:47 CHD500279 kernel: [16512.060103] ath: phy11: tx chain 0: iq corr coeff=5
Nov 18 13:39:47 CHD500279 kernel: [16512.060107] ath: phy11: rx chain 0: mag corr=-4  phase corr=12
Nov 18 13:39:47 CHD500279 kernel: [16512.060110] ath: phy11: rx chain 0: iq corr coeff=fffffe0c
Nov 18 13:39:47 CHD500279 kernel: [16512.060113] ath: phy11: Doing Tx IQ Cal for chain 0
Nov 18 13:39:47 CHD500279 kernel: [16512.060126] ath: phy11: IQ_RES[0]=0xbc6d806e IQ_RES[1]=0x139f
Nov 18 13:39:47 CHD500279 kernel: [16512.060138] ath: phy11: IQ_RES[2]=0x19f696f7 IQ_RES[3]=0x1410
Nov 18 13:39:47 CHD500279 kernel: [16512.060149] ath: phy11: IQ_RES[4]=0x44019ff6 IQ_RES[5]=0xfcf1
Nov 18 13:39:47 CHD500279 kernel: [16512.060153] ath: phy11: chain 0: mag mismatch=0 phase mismatch=0
Nov 18 13:39:47 CHD500279 kernel: [16512.060156] ath: phy11: tx chain 0: mag corr=0  phase corr=3
Nov 18 13:39:47 CHD500279 kernel: [16512.060159] ath: phy11: tx chain 0: iq corr coeff=3
Nov 18 13:39:47 CHD500279 kernel: [16512.060163] ath: phy11: rx chain 0: mag corr=-5  phase corr=10
Nov 18 13:39:47 CHD500279 kernel: [16512.060166] ath: phy11: rx chain 0: iq corr coeff=fffffd8a
Nov 18 13:39:47 CHD500279 kernel: [16512.060169] ath: phy11: Doing Tx IQ Cal for chain 0
Nov 18 13:39:47 CHD500279 kernel: [16512.060182] ath: phy11: IQ_RES[0]=0xc563b06e IQ_RES[1]=0x119f
Nov 18 13:39:47 CHD500279 kernel: [16512.060193] ath: phy11: IQ_RES[2]=0x17f61659 IQ_RES[3]=0x1230
Nov 18 13:39:47 CHD500279 kernel: [16512.060204] ath: phy11: IQ_RES[4]=0x28013ff6 IQ_RES[5]=0xfd11
Nov 18 13:39:47 CHD500279 kernel: [16512.060208] ath: phy11: chain 0: mag mismatch=0 phase mismatch=0
Nov 18 13:39:47 CHD500279 kernel: [16512.060211] ath: phy11: tx chain 0: mag corr=0  phase corr=2
Nov 18 13:39:47 CHD500279 kernel: [16512.060215] ath: phy11: tx chain 0: iq corr coeff=2
Nov 18 13:39:47 CHD500279 kernel: [16512.060218] ath: phy11: rx chain 0: mag corr=-7  phase corr=10
Nov 18 13:39:47 CHD500279 kernel: [16512.060221] ath: phy11: rx chain 0: iq corr coeff=fffffc8a
Nov 18 13:39:47 CHD500279 kernel: [16512.060226] ath: phy11: Doing Tx IQ Cal for chain 2
Nov 18 13:39:47 CHD500279 kernel: [16512.060239] ath: phy11: IQ_RES[0]=0xee47c584 IQ_RES[1]=0xbe3e
Nov 18 13:39:47 CHD500279 kernel: [16512.060250] ath: phy11: IQ_RES[2]=0x51bdb7fd IQ_RES[3]=0xd5ec
Nov 18 13:39:47 CHD500279 kernel: [16512.060262] ath: phy11: IQ_RES[4]=0xc443e400 IQ_RES[5]=0xdfdc
Nov 18 13:39:47 CHD500279 kernel: [16512.060265] ath: phy11: chain 2: mag mismatch=6 phase mismatch=9
Nov 18 13:39:47 CHD500279 kernel: [16512.060269] ath: phy11: tx chain 2: mag corr=28  phase corr=-2448
Nov 18 13:39:47 CHD500279 kernel: [16512.060272] ath: phy11: tx chain 2: iq corr coeff=dc1
Nov 18 13:39:47 CHD500279 kernel: [16512.060276] ath: phy11: rx chain 2: mag corr=28  phase corr=125
Nov 18 13:39:47 CHD500279 kernel: [16512.060279] ath: phy11: rx chain 2: iq corr coeff=e3f
Nov 18 13:39:47 CHD500279 kernel: [16512.060282] ath: phy11: Doing Tx IQ Cal for chain 2
Nov 18 13:39:47 CHD500279 kernel: [16512.060295] ath: phy11: IQ_RES[0]=0xc8de3ede IQ_RES[1]=0xe9b0
Nov 18 13:39:47 CHD500279 kernel: [16512.060306] ath: phy11: IQ_RES[2]=0x926cf9f9 IQ_RES[3]=0x12e2
Nov 18 13:39:47 CHD500279 kernel: [16512.060318] ath: phy11: IQ_RES[4]=0x9abb7810 IQ_RES[5]=0x1c80
Nov 18 13:39:47 CHD500279 kernel: [16512.060321] ath: phy11: chain 2: mag mismatch=-15 phase mismatch=11
Nov 18 13:39:47 CHD500279 kernel: [16512.060325] ath: phy11: tx chain 2: mag corr=5  phase corr=-2939
Nov 18 13:39:47 CHD500279 kernel: [16512.060328] ath: phy11: tx chain 2: iq corr coeff=241
Nov 18 13:39:47 CHD500279 kernel: [16512.060332] ath: phy11: rx chain 2: mag corr=126  phase corr=22
Nov 18 13:39:47 CHD500279 kernel: [16512.060335] ath: phy11: rx chain 2: iq corr coeff=1f96
Nov 18 13:39:47 CHD500279 kernel: [16512.060338] ath: phy11: Doing Tx IQ Cal for chain 2
Nov 18 13:39:47 CHD500279 kernel: [16512.060351] ath: phy11: IQ_RES[0]=0xaa8dbd3b IQ_RES[1]=0x11d5
Nov 18 13:39:47 CHD500279 kernel: [16512.060362] ath: phy11: IQ_RES[2]=0x1f6e5f1e IQ_RES[3]=0xb71
Nov 18 13:39:47 CHD500279 kernel: [16512.060374] ath: phy11: IQ_RES[4]=0x69f3c6b0 IQ_RES[5]=0x1bb7
Nov 18 13:39:47 CHD500279 kernel: [16512.060378] ath: phy11: chain 2: mag mismatch=-346 phase mismatch=-1149
Nov 18 13:39:47 CHD500279 kernel: [16512.060381] ath: phy11: tx chain 2: mag corr=0  phase corr=32096
Nov 18 13:39:47 CHD500279 kernel: [16512.060384] ath: phy11: tx chain 2: iq corr coeff=3f
Nov 18 13:39:47 CHD500279 kernel: [16512.060388] ath: phy11: rx chain 2: mag corr=-460  phase corr=594
Nov 18 13:39:47 CHD500279 kernel: [16512.060391] ath: phy11: rx chain 2: iq corr coeff=ffffe0bf
Nov 18 13:39:47 CHD500279 kernel: [16512.060394] ath: phy11: Doing Tx IQ Cal for chain 2
Nov 18 13:39:47 CHD500279 kernel: [16512.060407] ath: phy11: IQ_RES[0]=0x4cf3afc7 IQ_RES[1]=0xea49
Nov 18 13:39:47 CHD500279 kernel: [16512.060418] ath: phy11: IQ_RES[2]=0x1424b699 IQ_RES[3]=0x7fba
Nov 18 13:39:47 CHD500279 kernel: [16512.060430] ath: phy11: IQ_RES[4]=0xf60544b2 IQ_RES[5]=0xfff0
Nov 18 13:39:47 CHD500279 kernel: [16512.060433] ath: phy11: chain 2: mag mismatch=47 phase mismatch=53
Nov 18 13:39:47 CHD500279 kernel: [16512.060437] ath: phy11: tx chain 2: mag corr=1  phase corr=-13595
Nov 18 13:39:47 CHD500279 kernel: [16512.060440] ath: phy11: tx chain 2: iq corr coeff=41
Nov 18 13:39:47 CHD500279 kernel: [16512.060444] ath: phy11: rx chain 2: mag corr=315  phase corr=-1911
Nov 18 13:39:47 CHD500279 kernel: [16512.060447] ath: phy11: rx chain 2: iq corr coeff=1f41
Nov 18 13:39:47 CHD500279 kernel: [16512.060450] ath: phy11: Doing Tx IQ Cal for chain 2
Nov 18 13:39:47 CHD500279 kernel: [16512.060463] ath: phy11: IQ_RES[0]=0x8f3a6962 IQ_RES[1]=0x2fce
Nov 18 13:39:47 CHD500279 kernel: [16512.060474] ath: phy11: IQ_RES[2]=0x22ae7536 IQ_RES[3]=0x8ca3
Nov 18 13:39:47 CHD500279 kernel: [16512.060486] ath: phy11: IQ_RES[4]=0x74bbc4d5 IQ_RES[5]=0xa353
Nov 18 13:39:47 CHD500279 kernel: [16512.060489] ath: phy11: chain 2: mag mismatch=2 phase mismatch=6
Nov 18 13:39:47 CHD500279 kernel: [16512.060493] ath: phy11: tx chain 2: mag corr=178  phase corr=-1680
Nov 18 13:39:47 CHD500279 kernel: [16512.060496] ath: phy11: tx chain 2: iq corr coeff=1f41
Nov 18 13:39:47 CHD500279 kernel: [16512.060499] ath: phy11: rx chain 2: mag corr=243  phase corr=20
Nov 18 13:39:47 CHD500279 kernel: [16512.060503] ath: phy11: rx chain 2: iq corr coeff=1f94
Nov 18 13:39:47 CHD500279 kernel: [16512.060537] ath: phy11: enabling IQ Calibration
Nov 18 13:39:47 CHD500279 kernel: [16512.060541] ath: phy11: starting IQ Mismatch Calibration
Nov 18 13:39:47 CHD500279 kernel: [16512.114132] wlan11: Destroyed STA 00:80:48:70:bd:70

--------------080603070100040801040609--
