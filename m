Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-01.mandic.com.br ([200.225.81.132]:58585 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab2E0BCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 21:02:54 -0400
Received: from unknown (HELO cesarb-inspiron.home.cesarb.net) (zcncxNmDysja2tXBptWToZWJlF6Wp6IuYnI=@[200.157.204.20])
          (envelope-sender <cesarb@cesarb.net>)
          by smtp-01.mandic.com.br (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 27 May 2012 00:56:10 -0000
Message-ID: <4FC17BA8.2050606@cesarb.net> (sfid-20120527_030308_122290_604E4002)
Date: Sat, 26 May 2012 21:56:08 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ilw@linux.intel.com
Subject: iwlwifi: GF was set with SGI:SISO
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have twice now seen a problem with iwlwifi where rate control gets 
"stuck" (the tx bitrate as shown by "iw dev wlan0 link" does not change 
anymore), while spamming the kernel log with "iwlwifi 0000:03:00.0: GF 
was set with SGI:SISO".

The first time, it was stuck at 48 Mbit/s. This time, it got stuck at 81 
Mbit/s MCS 4 40MHz (long GI) [*]. But this time, I went to 
/sys/kernel/debug/ieee80211/phy0/netdev:wlan0/stations and got a copy of 
the rate_* files.

What I believe is happening is the following scenario:

1. My Galaxy Nexus decides to connect using the 5 GHz band, which makes 
the AP (a Linksys E3200) set the BSS to "HT protection: 20 MHz", "non-GF 
present: 1", and "OBSS non-GF present: 1".
2. My laptop, which is using the 5 GHz band, decides it can use SGI with 
a single stream (non-greenfield mode).
3. My Galaxy Nexus decides the 5 GHz signal is weak, and switches to the 
2.4 GHz band (separate SSID). After a time, the AP sets the 5 GHz BSS to 
"HT protection: no", "non-GF present: 0", and "OBSS non-GF present: 0".
4. The iwlwifi rate control gets confused by the change (since now it 
can use greenfield mode, which AFAIK cannot use SGI with a single 
spatial stream).

Unfortunately, I do not know enough of the iwl-agn-rs code to find where 
it got confused.


[*] While I was writing this email, it happened again, this time stuck 
at "120.0 MBit/s MCS 5 40Mhz short GI". I had connected the phone to 5 
GHz to get the "iw scan" output, but forgot and put it in a place with a 
weaker signal. I did not capture any debugfs output this time; the files 
below are still for when it got stuck at MCS 4.


uname -a:
Linux cesarb-inspiron.home.cesarb.net 3.3.6-3.fc16.x86_64 #1 SMP Wed May 
16 21:43:01 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

fgrep iwlwifi /var/log/messages:
May 26 07:53:59 cesarb-inspiron kernel: [   34.751962] iwlwifi 
0000:03:00.0: pci_resource_len = 0x00002000
May 26 07:53:59 cesarb-inspiron kernel: [   34.751965] iwlwifi 
0000:03:00.0: pci_resource_base = ffffc900110ac000
May 26 07:53:59 cesarb-inspiron kernel: [   34.751968] iwlwifi 
0000:03:00.0: HW Revision ID = 0x35
May 26 07:53:59 cesarb-inspiron kernel: [   34.752211] iwlwifi 
0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
May 26 07:53:59 cesarb-inspiron kernel: [   34.752214] iwlwifi 
0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
May 26 07:53:59 cesarb-inspiron kernel: [   34.752217] iwlwifi 
0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
May 26 07:53:59 cesarb-inspiron kernel: [   34.752219] iwlwifi 
0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
May 26 07:53:59 cesarb-inspiron kernel: [   34.752221] iwlwifi 
0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
May 26 07:53:59 cesarb-inspiron kernel: [   34.752250] iwlwifi 
0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
May 26 07:53:59 cesarb-inspiron kernel: [   34.752404] iwlwifi 
0000:03:00.0: L1 Enabled; Disabling L0S
May 26 07:53:59 cesarb-inspiron kernel: [   34.770981] iwlwifi 
0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
May 26 07:53:59 cesarb-inspiron kernel: [   34.770985] iwlwifi 
0000:03:00.0: Device SKU: 0x1F0
May 26 07:53:59 cesarb-inspiron kernel: [   34.771512] iwlwifi 
0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
May 26 07:53:59 cesarb-inspiron kernel: [   35.560569] iwlwifi 
0000:03:00.0: loaded firmware version 9.221.4.1 build 25532
May 26 07:53:59 cesarb-inspiron NetworkManager[1050]: <info> (wlan0): 
new 802.11 WiFi device (driver: 'iwlwifi' ifindex: 3)
May 26 07:53:59 cesarb-inspiron kernel: [   42.864904] iwlwifi 
0000:03:00.0: L1 Enabled; Disabling L0S
May 26 07:53:59 cesarb-inspiron kernel: [   42.871601] iwlwifi 
0000:03:00.0: Radio type=0x1-0x3-0x1
May 26 07:53:59 cesarb-inspiron kernel: [   43.102977] iwlwifi 
0000:03:00.0: L1 Enabled; Disabling L0S
May 26 07:53:59 cesarb-inspiron kernel: [   43.109620] iwlwifi 
0000:03:00.0: Radio type=0x1-0x3-0x1
May 26 13:30:45 cesarb-inspiron kernel: [20234.675926] iwlwifi 
0000:03:00.0: GF was set with SGI:SISO
May 26 13:30:50 cesarb-inspiron kernel: [20239.683577] iwlwifi 
0000:03:00.0: GF was set with SGI:SISO
May 26 13:31:07 cesarb-inspiron kernel: [20256.262701] iwlwifi 
0000:03:00.0: GF was set with SGI:SISO
[...]

lspci -k:
03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6200 
(rev 35)
	Subsystem: Intel Corporation Centrino Advanced-N 6200 2x2 AGN
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi

rate_scale_data:
Bit Rate= 229 Mb/s

rate_scale_table:
sta_id 0
failed=0 success=0 rate=0FF0
fixed rate 0x0
valid_tx_ant ANT_B,ANT_C
lq type HT
  SISO 40MHz SGI GF enabled
last tx rate=0x8D04
general:flags=0x0 mimo-d=0 s-ant0x2 d-ant=0x6
agg:time_limit=4000 dist_start_th=3 frame_cnt_limit=63
Start idx [0]=0x0 [1]=0x0 [2]=0x0 [3]=0x0
  rate[0] 0x8D04 36mbps (16QAM 3/4)
  rate[1] 0x8D04 36mbps (16QAM 3/4)
  rate[2] 0x8D03 24mbps (16QAM 1/2)
  rate[3] 0x8D03 24mbps (16QAM 1/2)
  rate[4] 0x8D03 24mbps (16QAM 1/2)
  rate[5] 0x8007 18mbps (QPSK 3/4)
  rate[6] 0x10005 12mbps (QPSK 1/2)
  rate[7] 0x800F 9mbps (BPSK 1/2)
  rate[8] 0x1000D 6mbps (BPSK 1/2)
  rate[9] 0x800D 6mbps (BPSK 1/2)
  rate[10] 0x1000D 6mbps (BPSK 1/2)
  rate[11] 0x800D 6mbps (BPSK 1/2)
  rate[12] 0x1000D 6mbps (BPSK 1/2)
  rate[13] 0x800D 6mbps (BPSK 1/2)
  rate[14] 0x1000D 6mbps (BPSK 1/2)
  rate[15] 0x800D 6mbps (BPSK 1/2)

rate_stats_table:
* type=3 SGI=1 HT40=1 DUP=0 GF=1
rate=0x8D04
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=2 success=2 %=12800
counter=0 success=0 %=-1
counter=13 success=9 %=8861
counter=8 success=8 %=12800
counter=9 success=8 %=11377
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=0 success=0 %=-1
x type=3 SGI=0 HT40=1 DUP=0 GF=1
rate=0x8901
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=3 success=3 %=12800
counter=0 success=0 %=-1
counter=11 success=4 %=4654
counter=6 success=0 %=0
counter=62 success=61 %=12593
counter=62 success=62 %=12800
counter=0 success=0 %=-1
counter=0 success=0 %=-1
counter=0 success=0 %=-1

iw scan, non-GF:
	freq: 5805
	beacon interval: 100
	capability: ESS Privacy (0x0011)
	signal: -68.00 dBm
	last seen: 95 ms ago
	Information elements from Probe Response frame:
	SSID: [...]
	Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC (0x000c)
	HT capabilities:
		Capabilities: 0x8fe
			HT20/HT40
			SM Power Save disabled
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 32767 bytes (exponent: 0x002)
		Minimum RX AMPDU time spacing: 16 usec (0x07)
		HT RX MCS rate indexes supported: 0-15, 32
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 161
		 * secondary channel offset: below
		 * STA channel width: any
		 * RIFS: 1
		 * HT protection: 20 MHz
		 * non-GF present: 1
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec

iw scan, GF:
	freq: 5805
	beacon interval: 100
	capability: ESS Privacy (0x0011)
	signal: -61.00 dBm
	last seen: 95 ms ago
	Information elements from Probe Response frame:
	SSID: [...]
	Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC (0x000c)
	HT capabilities:
		Capabilities: 0x8fe
			HT20/HT40
			SM Power Save disabled
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 32767 bytes (exponent: 0x002)
		Minimum RX AMPDU time spacing: 16 usec (0x07)
		HT RX MCS rate indexes supported: 0-15, 32
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 161
		 * secondary channel offset: below
		 * STA channel width: any
		 * RIFS: 1
		 * HT protection: no
		 * non-GF present: 0
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec


-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
