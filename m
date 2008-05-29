Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58268 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbYE2PKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 11:10:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4TFAbSC030643
	for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 11:10:37 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4TFABqD138544
	for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 11:10:11 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4TFAB7N012234
	for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 11:10:11 -0400
Message-ID: <483EC752.1040609@optonline.net> (sfid-20080529_171043_669383_A3CE1C1A)
Date: Thu, 29 May 2008 11:10:10 -0400
From: "Jerry Quinn (ibm)" <jlquinn@optonline.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	mickflemm@gmail.com
Subject: Re: ath5k can't connect on 5424
References: <4838A467.1000700@optonline.net> <20080528002814.GF7779@tuxdriver.com>
In-Reply-To: <20080528002814.GF7779@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sat, May 24, 2008 at 07:27:35PM -0400, Jerry Quinn wrote:
>   
>> Hi.  I just installed compat-wireless 2008-05-24.
>>
>> The good news is that ath5k now loads into the kernel and can talk to the 
>> chip.  However, beyond that, the device doesn't do anything.  During 
>> modprobe ath5k, I get
>>
>>
>> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
>> PCI: Setting latency timer of device 0000:03:00.0 to 64
>> ath5k_pci 0000:03:00.0: registered as 'phy1'
>> phy1: Selected rate control algorithm 'pid'
>> ath5k phy1: Atheros AR5424 chip found (MAC: 0xa3, PHY: 0x61)
>> udev: renamed network interface wlan0 to ath0
>>
>> The pci id for the chip is 168c:1014 (rev 01).  This is an IBM Thinkpad 
>> T60p, running Debian testing with kernel 2.6.25-2-686, the latest dist 
>> kernel available.
>>
>> When I try to bring up the interface I just get a link is not ready message 
>> in the kernel log with no other info.  Also, iwlist ath0 scan gives me no 
>> results either (I did ifconfig ath0 up beforehand).
>>
>> Let me know if there's any further diagnosis I can provide to help out.
>>     
>
> You might wish to post the results of running the ath_info tool
> available from the madwifi project (sorry, I don't have the URL handy).
>
> John
>   

Mike, thanks for pointing me to the updated ath_info.

Here's the dump from my chip:

naga:~/ath_info# ./ath_info -v 0xedf00000
#DBG main: sleep_ctl reg 00000000   reset_ctl reg 00000000
 -==Device Information==-
MAC Version:  2424  (0xa0)
MAC Revision: 5424  (0xa3)
Warning: Invalid EEPROM Magic number!
Device type:  3
5GHz PHY Revision: SChip (0xa2)
2GHz PHY Revision: SChip (0xa2)

/============== EEPROM Information =============\
| EEPROM Version:   5.3 | EEPROM Size:   4 kbit |
| EEMAP:              2 | Reg. Domain:     0x62 |
|================= Capabilities ================|
| 802.11a Support:  yes | Turbo-A disabled: yes |
| 802.11b Support:  yes | Turbo-G disabled: yes |
| 802.11g Support:  yes | 2GHz XR disabled: no  |
| RFKill  Support:  yes | 5GHz XR disabled: no  |
| 32kHz   Crystal:  no  |                       |
\===============================================/

/=========================================================\
|          Calibration data common for all modes          |
|=========================================================|
|          CCK/OFDM gain delta:             1             |
|          CCK/OFDM power delta:            5             |
|          Scaled CCK delta:                5             |
|          2GHz Antenna gain:               0             |
|          5GHz Antenna gain:               0             |
|          Turbo 2W maximum dBm:           38             |
|          Target power start:          0x1bd             |
|          EAR Start:                   0x21f             |
\=========================================================/

/=========================================================\
|          Calibration data for 802.11a operation         |
|=========================================================|
| I power:              0x08 | Q power:              0x1f |
| Use fixed bias:       0x00 | Max turbo power:      0x26 |
| Max XR power:         0x18 | Switch Settling Time: 0x2d |
| Tx/Rx attenuation:    0x2e | TX end to XLNA On:    0x02 |
| TX end to XPA Off:    0x00 | TX end to XPA On:     0x0e |
| 62db Threshold:       0x0f | XLNA gain:            0x0d |
| XPD:                  0x01 | XPD gain:             0x0a |
| I gain:               0x00 | Tx/Rx margin:         0x13 |
| False detect backoff: 0x00 | Noise Floor Threshold: -54 |
| ADC desired size:      -32 | PGA desired size:      -80 |
|=========================================================|
| Antenna control   0:  0x00 | Antenna control   1:  0x01 |
| Antenna control   2:  0x26 | Antenna control   3:  0x26 |
| Antenna control   4:  0x06 | Antenna control   5:  0x06 |
| Antenna control   6:  0x02 | Antenna control   7:  0x25 |
| Antenna control   8:  0x25 | Antenna control   9:  0x05 |
| Antenna control  10:  0x05 | Antenna control  11:  0x00 |
|=========================================================|
| Octave Band 0:           5 | db 0:                    5 |
| Octave Band 1:           5 | db 1:                    5 |
| Octave Band 2:           5 | db 2:                    5 |
| Octave Band 3:           5 | db 3:                    5 |
\=========================================================/
/============== Per rate power calibration ===========\
| Freq | 6-24Mbit/s | 36Mbit/s |  48Mbit/s | 54Mbit/s |
|======|============|==========|===========|==========|
| 4920 |    12.00   |  12.00   |   12.00   |   8.00   |
|======|============|==========|===========|==========|
| 5080 |    12.00   |  12.00   |   12.00   |   8.00   |
|======|============|==========|===========|==========|
| 5170 |    16.00   |  16.00   |   14.00   |  13.00   |
|======|============|==========|===========|==========|
| 5240 |    16.00   |  16.00   |   14.00   |  13.00   |
|======|============|==========|===========|==========|
| 5260 |    17.00   |  16.00   |   14.00   |  13.00   |
|======|============|==========|===========|==========|
| 5700 |    17.00   |  16.00   |   14.00   |  13.00   |
|======|============|==========|===========|==========|
| 5745 |    16.00   |  15.00   |   14.00   |  11.00   |
|======|============|==========|===========|==========|
| 5825 |    16.00   |  15.00   |   14.00   |  11.00   |
|======|============|==========|===========|==========|
| 5360 |    18.00   |  18.00   |   18.00   |  18.00   |
|======|============|==========|===========|==========|
| 5720 |    18.00   |  18.00   |   18.00   |  18.00   |
\=====================================================/
/=================== Per channel power calibration ====================\
| Freq | pwr_0 | pwr_1 | pwr_2 | pwr_3 |pwrx3_0|pwrx3_1|pwrx3_2|max_pwr|
|      | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 5045 | 11.01 | 18.01 | 20.00 | 31.03 |  0.01 |  3.02 | 11.01 | 31.03 |
|      |  [25] |  [44] |  [48] |  [63] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 5185 |  5.00 | 18.02 | 21.02 | 25.00 | 42.02 | 46.01 | 51.01 | 25.00 |
|      |   [0] |  [24] |  [27] |  [30] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 5220 |  8.00 | 32.00 | 17.00 | 18.02 |  1.00 | 10.02 | 26.01 | 18.02 |
|      | [153] | [178] | [198] | [208] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 5435 | 21.01 |  6.03 | 32.00 | 32.00 | 34.01 | 42.02 |  1.02 | 32.00 |
|      |  [50] |  [54] |  [72] | [103] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 5535 | 22.00 | 55.01 | 17.03 |  4.01 | 18.01 | 24.02 |  2.01 |  4.01 |
|      | [171] | [171] | [173] | [177] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 5100 |  1.01 | 12.02 | 10.00 | 54.01 | 24.00 | 36.00 | 18.02 | 54.01 |
|      |  [98] | [119] | [145] | [150] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 4825 | 54.01 | 42.02 |  1.01 | 11.02 | 25.01 |  6.03 | 32.00 | 11.02 |
|      | [144] | [167] | [175] | [197] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 4890 | 18.02 | 28.02 | 34.01 | 10.02 | 13.03 | 55.01 | 21.02 | 10.02 |
|      |  [22] |  [28] |  [44] |  [54] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 5045 | 24.00 | 32.00 | 18.02 | 28.02 |  1.02 | 11.02 |  5.03 | 28.02 |
|      | [161] | [186] | [205] | [215] |  [20] |  [35] |  [63] |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 4925 | 17.03 |  5.03 | 16.00 | 36.00 | 26.01 | 42.02 |  1.02 | 36.00 |
|      |  [46] |  [60] |  [78] | [107] |  [20] |  [35] |  [63] |       |
\======================================================================/

/=========================================================\
|          Calibration data for 802.11b operation         |
|=========================================================|
| I power:              0x00 | Q power:              0x00 |
| Use fixed bias:       0x00 | Max turbo power:      0x00 |
| Max XR power:         0x00 | Switch Settling Time: 0x28 |
| Tx/Rx attenuation:    0x1c | TX end to XLNA On:    0x02 |
| TX end to XPA Off:    0x00 | TX end to XPA On:     0x07 |
| 62db Threshold:       0x1c | XLNA gain:            0x0d |
| XPD:                  0x01 | XPD gain:             0x0a |
| I gain:               0x00 | Tx/Rx margin:         0x14 |
| False detect backoff: 0x00 | Noise Floor Threshold:  -1 |
| ADC desired size:      -62 | PGA desired size:      -104 |
|=========================================================|
| Antenna control   0:  0x00 | Antenna control   1:  0x0d |
| Antenna control   2:  0x2a | Antenna control   3:  0x2a |
| Antenna control   4:  0x22 | Antenna control   5:  0x22 |
| Antenna control   6:  0x0e | Antenna control   7:  0x29 |
| Antenna control   8:  0x29 | Antenna control   9:  0x21 |
| Antenna control  10:  0x21 | Antenna control  11:  0x00 |
|=========================================================|
| Octave Band 0:           5 | db 0:                    5 |
| Octave Band 1:           5 | db 1:                    5 |
| Octave Band 2:           0 | db 2:                    0 |
| Octave Band 3:           0 | db 3:                    0 |
\=========================================================/
/=================== Per channel power calibration ====================\
| Freq | pwr_0 | pwr_1 | pwr_2 | pwr_3 |pwrx3_0|pwrx3_1|pwrx3_2|max_pwr|
|      | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 2412 |  6.00 | 22.01 | 21.02 |  6.03 | 18.01 | 31.02 | 30.01 |  6.03 |
|      | [170] | [170] | [174] | [178] |  [20] |  [35] |  [63] |       |
\======================================================================/

/=========================================================\
|          Calibration data for 802.11g operation         |
|=========================================================|
| I power:              0x00 | Q power:              0x10 |
| Use fixed bias:       0x01 | Max turbo power:      0x26 |
| Max XR power:         0x24 | Switch Settling Time: 0x28 |
| Tx/Rx attenuation:    0x1c | TX end to XLNA On:    0x02 |
| TX end to XPA Off:    0x00 | TX end to XPA On:     0x0e |
| 62db Threshold:       0x1c | XLNA gain:            0x0d |
| XPD:                  0x01 | XPD gain:             0x0a |
| I gain:               0x00 | Tx/Rx margin:         0x14 |
| False detect backoff: 0x00 | Noise Floor Threshold:  -1 |
| ADC desired size:      -40 | PGA desired size:      -105 |
|=========================================================|
| Antenna control   0:  0x00 | Antenna control   1:  0x0d |
| Antenna control   2:  0x2a | Antenna control   3:  0x2a |
| Antenna control   4:  0x22 | Antenna control   5:  0x22 |
| Antenna control   6:  0x0e | Antenna control   7:  0x29 |
| Antenna control   8:  0x29 | Antenna control   9:  0x21 |
| Antenna control  10:  0x21 | Antenna control  11:  0x05 |
|=========================================================|
| Octave Band 0:           5 | db 0:                    5 |
| Octave Band 1:           5 | db 1:                    5 |
| Octave Band 2:           0 | db 2:                    0 |
| Octave Band 3:           0 | db 3:                    0 |
\=========================================================/
/=================== Per channel power calibration ====================\
| Freq | pwr_0 | pwr_1 | pwr_2 | pwr_3 |pwrx3_0|pwrx3_1|pwrx3_2|max_pwr|
|      | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac |       |
|======|=======|=======|=======|=======|=======|=======|=======|=======|
| 2412 |  1.02 | 11.02 | 61.03 | 23.00 | 32.00 | 36.00 | 17.02 | 23.00 |
|      |  [98] | [121] | [123] | [129] |  [20] |  [35] |  [63] |       |
\======================================================================/

GPIO registers: CR 0x00018003, DO 0x00000001, DI 0x0000000b
STA_ID0: 00:16:cf:23:6f:9e
STA_ID1: 0x1b809e6f, AP: 0, IBSS: 0, KeyCache Disable: 0
TIMER0: 0x00000030, TBTT:    48, TU: 0x00070030
TIMER1: 0x0007ffff, DMAb: 65535, TU: 0x0006ffff (-49)
TIMER2: 0x01ffffff, SWBA: 65535, TU: 0x003fffff (+3735503)
TIMER3: 0x00000031, ATIM:    49, TU: 0x00070031 (+1)
TSF: 0x000000001a8bf0f6, TSFTU: 41724, TU: 0x0006a2fc
BEACON: 0x00000000
LAST_TSTP: 0x007fe01f

