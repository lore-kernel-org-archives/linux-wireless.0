Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35493 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032598AbeBODTh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 22:19:37 -0500
Received: by mail-yw0-f182.google.com with SMTP id d77so4176703ywb.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Feb 2018 19:19:37 -0800 (PST)
MIME-Version: 1.0
From: Guy Trailblant <guytrailblant@gmail.com>
Date: Wed, 14 Feb 2018 22:19:36 -0500
Message-ID: <CAPJ5903wayfz9KsOkyA8e7QVCLjCcsmJr_Qfvyitm_EDNy1JOw@mail.gmail.com> (sfid-20180215_041946_530005_0AA8E6AA)
Subject: World roaming ath10k fails to manually set country codes in kernel
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

TLDR: My world roaming Qualcom Atheros QCA9882 wifi card in my AP
cannot be manually configured to use any specific country's regdomain
without beacon hints, causing service denial.

Please excuse the lengthy email, but I wanted to provide as much
information as possible, including log and software configuration
snippets.

I have a Qualcomm Atheros QCA9882 running on my CentOS 7.4 system,
kernel version 3.10.0-693.17.1.el7.x86_64. I'm trying to use this
system as a 5 GHz 802.11ac access point.  The problem begins when the
driver initializes the card as world roaming from the EEPROM as seen
in dmesg:
[ 1715.577842] ath10k_pci 0000:04:00.0: irq 73 for MSI/MSI-X
[ 1715.577910] ath10k_pci 0000:04:00.0: pci irq msi oper_irq_mode 2
irq_mode 0 reset_mode 0
[ 1715.697284] ath10k_pci 0000:04:00.0: qca988x hw2.0 target
0x4100016c chip_id 0x043222ff sub 1dac:0257
[ 1715.697289] ath10k_pci 0000:04:00.0: kconfig debug 0 debugfs 1
tracing 0 dfs 0 testmode 0
[ 1715.697551] ath10k_pci 0000:04:00.0: firmware ver 10.2.4.70.54 api
5 features no-p2p,raw-mode,mfp crc32 9d340dd9
[ 1715.753300] ath10k_pci 0000:04:00.0: board_file api 1 bmi_id N/A
crc32 bebc7c08
[ 1716.965277] ath10k_pci 0000:04:00.0: htt-ver 2.1 wmi-op 5 htt-op 2
cal otp max-sta 128 raw 0 hwcrypto 1
[ 1717.022697] ath: EEPROM regdomain: 0x6a
[ 1717.022701] ath: EEPROM indicates we should expect a direct regpair map
[ 1717.022704] ath: Country alpha2 being used: 00
[ 1717.022705] ath: Regpair used: 0x6a

iw reg get shows the same:
global
country 00: DFS-UNSET
        (2402 - 2472 @ 40), (N/A, 20), (N/A)
        (2457 - 2482 @ 20), (N/A, 20), (N/A), AUTO-BW, NO-IR
        (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, NO-IR
        (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW, NO-IR
        (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW, NO-IR
        (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, NO-IR
        (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
        (57240 - 63720 @ 2160), (N/A, 0), (N/A)

global
country 00: DFS-UNSET
        (2402 - 2472 @ 40), (N/A, 20), (N/A)
        (2457 - 2482 @ 20), (N/A, 20), (N/A), AUTO-BW, NO-IR
        (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, NO-IR
        (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW, NO-IR
        (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW, NO-IR
        (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, NO-IR
        (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
        (57240 - 63720 @ 2160), (N/A, 0), (N/A)

Lastly, iw list also confirms that all 5GHz channels are no-ir as expected:
# iw list | grep '5[0-9]\{3\} MHz'
                        * 5180 MHz [36] (23.0 dBm) (no IR)
                        * 5200 MHz [40] (23.0 dBm) (no IR)
                        * 5220 MHz [44] (23.0 dBm) (no IR)
                        * 5240 MHz [48] (23.0 dBm) (no IR)
                        * 5260 MHz [52] (23.0 dBm) (no IR, radar detection)
                        * 5280 MHz [56] (23.0 dBm) (no IR, radar detection)
                        * 5300 MHz [60] (23.0 dBm) (no IR, radar detection)
                        * 5320 MHz [64] (23.0 dBm) (no IR, radar detection)
                        * 5500 MHz [100] (23.0 dBm) (no IR, radar detection)
                        * 5520 MHz [104] (23.0 dBm) (no IR, radar detection)
                        * 5540 MHz [108] (23.0 dBm) (no IR, radar detection)
                        * 5560 MHz [112] (23.0 dBm) (no IR, radar detection)
                        * 5580 MHz [116] (23.0 dBm) (no IR, radar detection)
                        * 5600 MHz [120] (23.0 dBm) (no IR, radar detection)
                        * 5620 MHz [124] (23.0 dBm) (no IR, radar detection)
                        * 5640 MHz [128] (23.0 dBm) (no IR, radar detection)
                        * 5660 MHz [132] (23.0 dBm) (no IR, radar detection)
                        * 5680 MHz [136] (23.0 dBm) (no IR, radar detection)
                        * 5700 MHz [140] (23.0 dBm) (no IR, radar detection)
                        * 5720 MHz [144] (23.0 dBm) (no IR, radar detection)
                        * 5745 MHz [149] (30.0 dBm) (no IR)
                        * 5765 MHz [153] (30.0 dBm) (no IR)
                        * 5785 MHz [157] (30.0 dBm) (no IR)
                        * 5805 MHz [161] (30.0 dBm) (no IR)
                        * 5825 MHz [165] (30.0 dBm) (no IR)
                        * 5845 MHz [169] (disabled)

I can set the country code to the US (where I'm located) seemingly successfully:
# iw reg set US
# iw reg get
global
country US: DFS-FCC
        (2402 - 2472 @ 40), (N/A, 30), (N/A)
        (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
        (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
        (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
        (5735 - 5835 @ 80), (N/A, 30), (N/A)
        (57240 - 63720 @ 2160), (N/A, 40), (N/A)

global
country US: DFS-FCC
        (2402 - 2472 @ 40), (N/A, 30), (N/A)
        (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
        (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
        (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
        (5735 - 5835 @ 80), (N/A, 30), (N/A)
        (57240 - 63720 @ 2160), (N/A, 40), (N/A)

The issue is that although iw correctly sees the manually set country
and regdomain entries, it seems like the kernel does not.  iw list
shows exactly the same output as it did before running 'iw reg set US'
with the no IR setting on all 5GHz channels.  I've also tried other
country codes like DE, GB, FI, CZ, and others with the same result.

I'm aware of beacon hints, and that works.  This can be seen when I
set hostapd to scan for available channels.  It will start and find
other AP's and enable those channels if allowed within the regdomain.
To confirm this, here is the relevant portion of my hostapd.conf file:

country_code=US
ieee80211d=0
ieee80211h=0
hw_mode=a
channel=0

After starting hostapd I'll get log entries like this:
1518657580.341076: wlp4s0: interface state UNINITIALIZED->COUNTRY_UPDATE
1518657580.341143: Previous country code US, new country code US
1518657580.341369: nl80211: Regulatory information - country=US (DFS-FCC)
1518657580.341384: nl80211: 2402-2472 @ 40 MHz 30 mBm
1518657580.341394: nl80211: 5170-5250 @ 80 MHz 23 mBm
1518657580.341404: nl80211: 5250-5330 @ 80 MHz 23 mBm (DFS)
1518657580.341412: nl80211: 5490-5730 @ 160 MHz 23 mBm (DFS)
1518657580.341422: nl80211: 5735-5835 @ 80 MHz 30 mBm
1518657580.341464: nl80211: 57240-63720 @ 2160 MHz 40 mBm
1518657580.341500: nl80211: Added 802.11b mode based on 802.11g information
1518657580.341532: ACS: Automatic channel selection started, this may take a bit
1518657580.341546: ACS: Scanning 1 / 5
1518657580.341571: wlp4s0: nl80211: scan request
1518657580.341601: nl80211: Passive scan requested
1518657580.341786: Scan requested (ret=0) - scan timeout 10 seconds
1518657580.341804: wlp4s0: interface state COUNTRY_UPDATE->ACS
1518657580.341812: wlp4s0: ACS-STARTED
1518657580.341822: Interface initialization will be completed in a
callback (ACS)
...
1518657583.349350: ACS: Survey analysis for selected bandwidth 40 MHz
1518657583.349358: ACS:  * channel 44: total interference = 0.00961333
1518657583.349367: ACS: Channel 48: not allowed as primary channel for HT40
1518657583.349373: ACS: Channel 153: not allowed as primary channel for HT40
1518657583.349380: ACS: Channel 157: not enough bandwidth
1518657583.349386: ACS: Ideal channel is 44 (5220 MHz) with total
interference factor of 0.00961333
1518657583.349393: ACS: Adjusting VHT center frequency
1518657583.349404: wlp4s0: ACS-COMPLETED freq=5220 channel=44
1518657583.349410: Disable HT capability [DSSS_CCK-40] on 5 GHz band
1518657583.349420: hw vht capab: 0x338001b2, conf vht capab: 0x318001b2
1518657583.349427: wlp4s0: interface state ACS->HT_SCAN
1518657583.349434: Scan for neighboring BSSes prior to enabling 40 MHz channel
1518657583.349442: 40 MHz affected channel range: [5210,5250] MHz
...
1518657583.650096: nl80211: Drv Event 34
(NL80211_CMD_NEW_SCAN_RESULTS) received for wlp4s0
1518657583.650108: wlp4s0: nl80211: New scan results available
1518657583.650118: nl80211: Scan included frequencies: 5220 5240
1518657583.650126: wlp4s0: Event SCAN_RESULTS (3) received
1518657583.650221: nl80211: Received scan results (12 BSSes)
1518657583.650291: HT40: control channel: 44  secondary channel: 48
1518657583.650301: Completing interface initialization
1518657583.650308: Mode: IEEE 802.11a  Channel: 44  Frequency: 5220 MHz
1518657583.650322: DFS 0 channels required radar detection
1518657583.650330: nl80211: Set freq 5220 (ht_enabled=1,
vht_enabled=1, bandwidth=40 MHz, cf1=5230 MHz, cf2=0 MHz)
1518657583.650339:   * freq=5220
1518657583.650346:   * vht_enabled=1
1518657583.650352:   * ht_enabled=1
1518657583.650358:   * bandwidth=40
1518657583.650364:   * channel_width=2
1518657583.650382:   * center_freq1=5230
1518657583.650389:   * center_freq2=0

And finally, iw list shows no-ir is lifted on those channels:
                        * 5180 MHz [36] (23.0 dBm) (no IR)
                        * 5200 MHz [40] (23.0 dBm) (no IR)
                        * 5220 MHz [44] (23.0 dBm)
                        * 5240 MHz [48] (23.0 dBm)
                        * 5260 MHz [52] (23.0 dBm) (no IR, radar detection)
                        * 5280 MHz [56] (23.0 dBm) (no IR, radar detection)
                        * 5300 MHz [60] (23.0 dBm) (no IR, radar detection)
                        * 5320 MHz [64] (23.0 dBm) (no IR, radar detection)
                        * 5500 MHz [100] (23.0 dBm) (no IR, radar detection)
                        * 5520 MHz [104] (23.0 dBm) (no IR, radar detection)
                        * 5540 MHz [108] (23.0 dBm) (no IR, radar detection)
                        * 5560 MHz [112] (23.0 dBm) (no IR, radar detection)
                        * 5580 MHz [116] (23.0 dBm) (no IR, radar detection)
                        * 5600 MHz [120] (23.0 dBm) (no IR, radar detection)
                        * 5620 MHz [124] (23.0 dBm) (no IR, radar detection)
                        * 5640 MHz [128] (23.0 dBm) (no IR, radar detection)
                        * 5660 MHz [132] (23.0 dBm) (no IR, radar detection)
                        * 5680 MHz [136] (23.0 dBm) (no IR, radar detection)
                        * 5700 MHz [140] (23.0 dBm) (no IR, radar detection)
                        * 5720 MHz [144] (23.0 dBm) (no IR, radar detection)
                        * 5745 MHz [149] (30.0 dBm) (no IR)
                        * 5765 MHz [153] (30.0 dBm)
                        * 5785 MHz [157] (30.0 dBm)
                        * 5805 MHz [161] (30.0 dBm) (no IR)
                        * 5825 MHz [165] (30.0 dBm) (no IR)
                        * 5845 MHz [169] (disabled)

There are several problems with this mechanism.
- My AP will always need to be on the same channel as another AP
because it must hear a beacon to lift the no-ir setting, even if a
frequency is allowed by the country regdomain.  Although not a huge
issue, this means there would always be some degree of interference.
- I am unable to predetermine a channel that I want to use in advance.
This prohibits me from specifying advanced tuning settings of hostapd
like vht_oper_chwidth=1 and vht_oper_centr_freq_seg0_idx=<nextchannel>
to allow for 80MHz channels because I need to manually specify what
the center frequency is based on the chosen channel.  Obviously this
is impossible if I don't know what channel will be used in advance.
- Lastly, and probably most importantly, sometimes I cannot start my
AP at all because beacons cannot be heard on a suitable channel.  Here
is what it looks like in the hostapd log when that happens.  Note that
no beacons were heard on channel 44, which is what my AP normally ends
up configured to use.

1518657583.349350: ACS: Survey analysis for selected bandwidth 40 MHz
1518657583.349367: ACS: Channel 48: not allowed as primary channel for HT40
1518657583.349373: ACS: Channel 153: not allowed as primary channel for HT40
1518657583.349380: ACS: Channel 157: not enough bandwidth

At this point, hostapd exits with a failure.

Thank you for taking the time to read through this terribly long
account.  I appreciate any advice or other assistance!
