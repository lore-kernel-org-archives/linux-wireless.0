Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:35564 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2KFM1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 07:27:45 -0500
Message-ID: <5099023E.70506@monom.org> (sfid-20121106_132758_917055_2B0438F0)
Date: Tue, 06 Nov 2012 13:27:42 +0100
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Piotr Haber <phaber@broadcom.com>
CC: Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace support
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com> <5098B858.7090802@monom.org> <5098C7FF.2060308@monom.org> <5098E488.5020206@broadcom.com> <5098EA0C.1020806@broadcom.com>
In-Reply-To: <5098EA0C.1020806@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Piotr,

On 06.11.2012 11:44, Piotr Haber wrote:
> On 11/06/12 11:20, Arend van Spriel wrote:
>> On 11/06/2012 09:19 AM, Daniel Wagner wrote:
>>> On 06.11.2012 08:12, Daniel Wagner wrote:
>>>> Hi Seth,
>>>>
>>>> I am owner of a MBA 2012 and the mainline driver is kind of 'not fun'
>>>> (read broken). Since a few days I am using it and the situation improved
>>>
>>> it = your patch set on top of 3.7-rc3
>>>
>>> (/me should not write emails right after getting up)
>>>
>>>
>>
>> Just looked at the screen shots. Only could read the last one. It seems
>> to indicate a problem in the receive path.
>>
>> Gr. AvS
> Hi Daniel,
> 
> could you describe your hardware (lspci -nn), infrastructure (iw wlanx
> link/scan) and kernel version?

Sure, forgot to include this details in the beginning.

$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Ivy Bridge DRAM Controller [8086:0154] (rev 09)
00:02.0 VGA compatible controller [0300]: Intel Corporation Device [8086:0166] (rev 09)
00:14.0 USB Controller [0c03]: Intel Corporation Panther Point USB xHCI Host Controller [8086:1e31] (rev 04)
00:16.0 Communication controller [0780]: Intel Corporation Panther Point MEI Controller #1 [8086:1e3a] (rev 04)
00:1a.0 USB Controller [0c03]: Intel Corporation Panther Point USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
00:1b.0 Audio device [0403]: Intel Corporation Panther Point High Definition Audio Controller [8086:1e20] (rev 04)
00:1c.0 PCI bridge [0604]: Intel Corporation Panther Point PCI Express Root Port 1 [8086:1e10] (rev c4)
00:1c.1 PCI bridge [0604]: Intel Corporation Panther Point PCI Express Root Port 2 [8086:1e12] (rev c4)
00:1c.4 PCI bridge [0604]: Intel Corporation Panther Point PCI Express Root Port 5 [8086:1e18] (rev c4)
00:1d.0 USB Controller [0c03]: Intel Corporation Panther Point USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
00:1f.0 ISA bridge [0601]: Intel Corporation Panther Point LPC Controller [8086:1e56] (rev 04)
00:1f.2 SATA controller [0106]: Intel Corporation Panther Point 6 port SATA AHCI Controller [8086:1e03] (rev 04)
00:1f.3 SMBus [0c05]: Intel Corporation Panther Point SMBus Controller [8086:1e22] (rev 04)
02:00.0 Network controller [0280]: Broadcom Corporation BCM43224 802.11a/b/g/n [14e4:4353] (rev 01)


$ iw wlan0 link
Connected to 10:8c:cf:b5:f7:4f (on wlan0)
        SSID: Linux Foundation
        freq: 5220
        RX: 9419107 bytes (15520 packets)
        TX: 353310 bytes (3027 packets)
        signal: -63 dBm
        tx bitrate: 72.2 MBit/s MCS 7 short GI

        bss flags:      short-slot-time
        dtim period:    0
        beacon int:     102



$ sudo iw wlan0 scan
BSS 00:0c:f6:e4:75:7e (on wlan0)
        TSF: 8817869184 usec (0d, 02:26:57)
        freq: 2462
        beacon interval: 100
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -73.00 dBm
        last seen: 3394 ms ago
        Information elements from Probe Response frame:
        SSID: SitecomE4757E
        Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
        DS Parameter set: channel 11
        Country: JP     Environment: Indoor/Outdoor
                Channels [1 - 14] @ 20 dBm
        ERP: <no flags>
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: (0x0000)
        Extended supported rates: 24.0 36.0 48.0 54.0 
        HT capabilities:
                Capabilities: 0x116e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        RX STBC 1-stream
                        Max AMSDU length: 3839 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: No restriction (0x00)
                HT RX MCS rate indexes supported: 0-7
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 11
                 * secondary channel offset: below
                 * STA channel width: any
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 1
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
        WPS:     * Version: 1.0
                 * Wi-Fi Protected Setup State: 2 (Configured)
                 * Response Type: 3 (AP)
                 * UUID: c38c440e-404a-5a97-acbd-f9b0b51bfed5
                 * Manufacturer: Sitecom
                 * Model: BR6229SN
                 * Model Number: BR6229SN
                 * Serial Number: Serial Number Here
                 * Primary Device Type: 6-0050f204-1
                 * Device name: WLR-1000
                 * Config methods: Ethernet, Label
                 * RF Bands: 0x1
BSS 10:8c:cf:b5:f7:4f (on wlan0) -- associated
        TSF: 279284657996 usec (3d, 05:34:44)
        freq: 5220
        beacon interval: 102
        capability: ESS Privacy SpectrumMgmt (0x0111)
        signal: -61.00 dBm
        last seen: 431 ms ago
        Information elements from Probe Response frame:
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        Country: ES     Environment: Indoor/Outdoor
                Channels [36 - 64] @ 23 dBm
                Channels [100 - 116] @ 23 dBm
                Channels [132 - 140] @ 30 dBm
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 44
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS b8:62:1f:e4:0e:7f (on wlan0)
        TSF: 15285338189 usec (0d, 04:14:45)
        freq: 5220
        beacon interval: 102
        capability: ESS Privacy SpectrumMgmt (0x0111)
        signal: -76.00 dBm
        last seen: 390 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x5 Bitmap[0] 0x20 (+ 3 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [36 - 64] @ 23 dBm
                Channels [100 - 116] @ 23 dBm
                Channels [132 - 140] @ 30 dBm
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 44
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS b8:62:1f:e8:21:bf (on wlan0)
        TSF: 16586969125 usec (0d, 04:36:26)
        freq: 5220
        beacon interval: 102
        capability: ESS Privacy SpectrumMgmt (0x0111)
        signal: -83.00 dBm
        last seen: 2572 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0 (+ 3 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [36 - 64] @ 23 dBm
                Channels [100 - 116] @ 23 dBm
                Channels [132 - 140] @ 30 dBm
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 44
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: non-HT mixed
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 00:1e:4a:58:61:90 (on wlan0)
        TSF: 7705607782467 usec (89d, 04:26:47)
        freq: 5520
        beacon interval: 100
        capability: ESS SpectrumMgmt (0x0101)
        signal: -79.00 dBm
        last seen: 1571 ms ago
        SSID: kubi_MeetingRooms
        Supported rates: 6.0* 9.0 12.0 18.0 24.0 36.0 48.0 54.0 
        TIM: DTIM Count 0 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 31-1023, AIFSN 3
                 * BK: CW 31-1023, AIFSN 7
                 * VI: CW 15-31, AIFSN 2, TXOP 3008 usec
                 * VO: CW 7-15, AIFSN 2, TXOP 1504 usec
BSS d8:24:bd:a7:42:d0 (on wlan0)
        TSF: 7705682534452 usec (89d, 04:28:02)
        freq: 5180
        beacon interval: 102
        capability: ESS SpectrumMgmt (0x0101)
        signal: -79.00 dBm
        last seen: 3084 ms ago
        SSID: kubi_MeetingRooms
        Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0 
        TIM: DTIM Count 0 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 36
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS d8:24:bd:da:c9:40 (on wlan0)
        TSF: 7705513642036 usec (89d, 04:25:13)
        freq: 5200
        beacon interval: 102
        capability: ESS SpectrumMgmt (0x0101)
        signal: -64.00 dBm
        last seen: 2914 ms ago
        SSID: kubi_MeetingRooms
        Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0 
        TIM: DTIM Count 1 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 40
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS d8:24:bd:e9:38:20 (on wlan0)
        TSF: 7705516044840 usec (89d, 04:25:16)
        freq: 2462
        beacon interval: 102
        capability: ESS ShortPreamble ShortSlotTime (0x0421)
        signal: -76.00 dBm
        last seen: 3415 ms ago
        Information elements from Probe Response frame:
        SSID: kubi_MeetingRooms
        Supported rates: 1.0* 2.0* 5.5* 6.0 9.0 11.0* 12.0 18.0 
        DS Parameter set: channel 11
        ERP: Use_Protection
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        Extended supported rates: 24.0 36.0 48.0 54.0 
        HT operation:
                 * primary channel: 11
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS d8:24:bd:db:36:80 (on wlan0)
        TSF: 7705515835444 usec (89d, 04:25:15)
        freq: 5180
        beacon interval: 102
        capability: ESS SpectrumMgmt (0x0101)
        signal: -51.00 dBm
        last seen: 3053 ms ago
        SSID: kubi_MeetingRooms
        Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0 
        TIM: DTIM Count 0 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 36
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 8c:b6:4f:2a:4e:a0 (on wlan0)
        TSF: 265350875173 usec (3d, 01:42:30)
        freq: 2462
        beacon interval: 102
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -70.00 dBm
        last seen: 3653 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        DS Parameter set: channel 11
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x3 Bitmap[0] 0x80 (+ 7 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 11
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: non-HT mixed
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 00:1e:4a:55:f5:70 (on wlan0)
        TSF: 7705581261196 usec (89d, 04:26:21)
        freq: 2462
        beacon interval: 100
        capability: ESS ShortPreamble ShortSlotTime (0x0421)
        signal: -78.00 dBm
        last seen: 28054 ms ago
        SSID: kubi_MeetingRooms
        Supported rates: 1.0* 2.0 5.5 6.0 9.0 11.0 12.0 18.0 
        DS Parameter set: channel 11
        TIM: DTIM Count 1 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
        ERP: Use_Protection
        Extended supported rates: 24.0 36.0 48.0 54.0 
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 31-1023, AIFSN 3
                 * BK: CW 31-1023, AIFSN 7
                 * VI: CW 15-31, AIFSN 2, TXOP 6016 usec
                 * VO: CW 7-15, AIFSN 2, TXOP 3264 usec
BSS b8:62:1f:e8:21:60 (on wlan0)
        TSF: 93501222948 usec (1d, 01:58:21)
        freq: 2412
        beacon interval: 102
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -78.00 dBm
        last seen: 4487 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        DS Parameter set: channel 1
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x4 Bitmap[0] 0x80 (+ 19 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 1
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: non-HT mixed
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 20:aa:4b:d5:f0:a9 (on wlan0)
        TSF: 10973564083 usec (0d, 03:02:53)
        freq: 2447
        beacon interval: 100
        capability: ESS Privacy ShortSlotTime (0x0411)
        signal: -77.00 dBm
        last seen: 4023 ms ago
        Information elements from Probe Response frame:
        SSID: Collabora BCN
        Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
        DS Parameter set: channel 8
        ERP: <no flags>
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 16-PTKSA-RC (0x000c)
        Extended supported rates: 6.0 9.0 12.0 48.0 
        HT capabilities:
                Capabilities: 0x18fc
                        HT20
                        SM Power Save disabled
                        RX Greenfield
                        RX HT20 SGI
                        RX HT40 SGI
                        TX STBC
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 8
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        Extended capabilities: HT Information Exchange Supported
        WPS:     * Version: 1.0
                 * Wi-Fi Protected Setup State: 2 (Configured)
                 * Selected Registrar: 0x0
                 * Response Type: 3 (AP)
                 * UUID: 28135e4d-044e-c3d8-9d3f-6b860ed1afb6
                 * Manufacturer: Cisco
                 * Model: Linksys E2500
                 * Model Number: v1.0.03
                 * Serial Number: 42
                 * Primary Device Type: 6-0050f204-1
                 * Device name: Linksys E2500
                 * Config methods: Label, PBC
                 * RF Bands: 0x3
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS be:e4:8a:f4:5c:36 (on wlan0)
        TSF: 517326589 usec (0d, 00:08:37)
        freq: 2462
        beacon interval: 100
        capability: IBSS (0x0002)
        signal: -84.00 dBm
        last seen: 24133 ms ago
        SSID: treasure01
        Supported rates: 1.0* 2.0 5.5 11.0 6.0 9.0 12.0 18.0 
        DS Parameter set: channel 11
        Extended supported rates: 24.0 36.0 48.0 54.0 
        WMM: information: 01 00
BSS 10:8c:cf:b5:e9:60 (on wlan0)
        TSF: 262876815396 usec (3d, 01:01:16)
        freq: 2412
        beacon interval: 102
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -82.00 dBm
        last seen: 4474 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        DS Parameter set: channel 1
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x1 Bitmap[0] 0x0 (+ 27 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 1
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: non-HT mixed
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS c4:0a:cb:64:93:20 (on wlan0)
        TSF: 1133067673976 usec (13d, 02:44:27)
        freq: 2412
        beacon interval: 102
        capability: ESS ShortPreamble ShortSlotTime (0x0421)
        signal: -82.00 dBm
        last seen: 28991 ms ago
        SSID: kubi
        Supported rates: 1.0* 2.0* 5.5* 6.0 9.0 11.0* 12.0 18.0 
        DS Parameter set: channel 1
        TIM: DTIM Count 1 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x2 (+ 3 octets)
        ERP: Use_Protection
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        Extended supported rates: 24.0 36.0 48.0 54.0 
        HT operation:
                 * primary channel: 1
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 00:02:cf:e2:3b:fd (on wlan0)
        TSF: 15629314173 usec (0d, 04:20:29)
        freq: 2472
        beacon interval: 100
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -90.00 dBm
        last seen: 3428 ms ago
        SSID: WLAN_0A
        Supported rates: 1.0* 2.0* 5.5* 11.0* 22.0 
        DS Parameter set: channel 13
        TIM: DTIM Count 1 DTIM Period 3 Bitmap Control 0x0 Bitmap[0] 0x0 (+ 8 octets)
        ERP: <no flags>
        Extended supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0 
BSS 00:1e:4a:33:1d:e0 (on wlan0)
        TSF: 7705496576593 usec (89d, 04:24:56)
        freq: 2412
        beacon interval: 100
        capability: ESS ShortPreamble ShortSlotTime (0x0421)
        signal: -78.00 dBm
        last seen: 24268 ms ago
        SSID: kubi_MeetingRooms
        Supported rates: 1.0* 2.0 5.5 6.0 9.0 11.0 12.0 18.0 
        DS Parameter set: channel 1
        TIM: DTIM Count 0 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
        ERP: Use_Protection
        Extended supported rates: 24.0 36.0 48.0 54.0 
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 31-1023, AIFSN 3
                 * BK: CW 31-1023, AIFSN 7
                 * VI: CW 15-31, AIFSN 2, TXOP 6016 usec
                 * VO: CW 7-15, AIFSN 2, TXOP 3264 usec
BSS d8:24:bd:b5:0e:e0 (on wlan0)
        TSF: 5464302090616 usec (63d, 05:51:42)
        freq: 2412
        beacon interval: 102
        capability: ESS ShortPreamble ShortSlotTime (0x0421)
        signal: -83.00 dBm
        last seen: 4326 ms ago
        Information elements from Probe Response frame:
        SSID: kubi_MeetingRooms
        Supported rates: 1.0* 2.0* 5.5* 6.0 9.0 11.0* 12.0 18.0 
        DS Parameter set: channel 1
        ERP: Use_Protection
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        Extended supported rates: 24.0 36.0 48.0 54.0 
        HT operation:
                 * primary channel: 1
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 30:46:9a:7f:0e:f7 (on wlan0)
        TSF: 778689641701 usec (9d, 00:18:09)
        freq: 2462
        beacon interval: 100
        capability: ESS Privacy ShortSlotTime (0x0411)
        signal: -90.00 dBm
        last seen: 24128 ms ago
        SSID: wilduri
        Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
        DS Parameter set: channel 11
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
        ERP: Barker_Preamble_Mode
        RSN:     * Version: 1
                 * Group cipher: TKIP
                 * Pairwise ciphers: CCMP TKIP
                 * Authentication suites: PSK
                 * Capabilities: 16-PTKSA-RC (0x000c)
        Extended supported rates: 6.0 9.0 12.0 48.0 
        HT capabilities:
                Capabilities: 0x187c
                        HT20
                        SM Power Save disabled
                        RX Greenfield
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 11
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 1
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WPS:     * Version: 1.0
                 * Wi-Fi Protected Setup State: 2 (Configured)
        WPA:     * Version: 1
                 * Group cipher: TKIP
                 * Pairwise ciphers: CCMP TKIP
                 * Authentication suites: PSK
                 * Capabilities: 16-PTKSA-RC (0x000c)
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 10:8c:cf:b5:f7:40 (on wlan0)
        TSF: 279281418277 usec (3d, 05:34:41)
        freq: 2412
        beacon interval: 102
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -60.00 dBm
        last seen: 4483 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        DS Parameter set: channel 1
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0 (+ 3 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 1
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: non-HT mixed
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 8c:b6:4f:2a:5a:60 (on wlan0)
        TSF: 251997720612 usec (2d, 21:59:57)
        freq: 2412
        beacon interval: 102
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -76.00 dBm
        last seen: 4449 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        DS Parameter set: channel 1
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 1
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS d8:24:bd:e8:99:20 (on wlan0)
        TSF: 7705513145141 usec (89d, 04:25:13)
        freq: 2437
        beacon interval: 102
        capability: ESS ShortPreamble ShortSlotTime (0x0421)
        signal: -65.00 dBm
        last seen: 6 ms ago
        Information elements from Probe Response frame:
        SSID: kubi_MeetingRooms
        Supported rates: 1.0* 2.0* 5.5* 6.0 9.0 11.0* 12.0 18.0 
        DS Parameter set: channel 6
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        Extended supported rates: 24.0 36.0 48.0 54.0 
        HT operation:
                 * primary channel: 6
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 5c:33:8e:e3:f6:6b (on wlan0)
        TSF: 26771968454 usec (0d, 07:26:11)
        freq: 2437
        beacon interval: 100
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -91.00 dBm
        last seen: 4144 ms ago
        SSID: Orange-602e
        Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
        DS Parameter set: channel 6
        TIM: DTIM Count 0 DTIM Period 3 Bitmap Control 0x0 Bitmap[0] 0x0
        ERP: Use_Protection
        RSN:     * Version: 1
                 * Group cipher: TKIP
                 * Pairwise ciphers: CCMP TKIP
                 * Authentication suites: PSK
                 * Capabilities: (0x0000)
        WPA:     * Version: 1
                 * Group cipher: TKIP
                 * Pairwise ciphers: CCMP TKIP
                 * Authentication suites: PSK
        Extended supported rates: 24.0 36.0 48.0 54.0 
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
        HT capabilities:
                Capabilities: 0x104c
                        HT20
                        SM Power Save disabled
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 3839 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 6
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 0
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        WPS:     * Version: 1.0
                 * Wi-Fi Protected Setup State: 2 (Configured)
                 * AP setup locked: 0x00
                 * UUID: 988b5d2e-602e-988b-5d2e-602e5d2e602e
                 * RF Bands: 0x1
BSS 10:8c:cf:b5:c4:b0 (on wlan0)
        TSF: 15281995812 usec (0d, 04:14:41)
        freq: 2437
        beacon interval: 102
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -60.00 dBm
        last seen: 4143 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        DS Parameter set: channel 6
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0xd Bitmap[0] 0x0 (+ 3 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 6
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS b8:62:1f:e4:0e:70 (on wlan0)
        TSF: 15283041222 usec (0d, 04:14:43)
        freq: 2462
        beacon interval: 102
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -75.00 dBm
        last seen: 3615 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        DS Parameter set: channel 11
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 11
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: non-HT mixed
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS b8:62:1f:e8:21:b0 (on wlan0)
        TSF: 16586760228 usec (0d, 04:36:26)
        freq: 2462
        beacon interval: 102
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -81.00 dBm
        last seen: 3612 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        DS Parameter set: channel 11
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x1 Bitmap[0] 0x0 (+ 3 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 11
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: nonmember
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 10:8c:cf:b5:c4:bf (on wlan0)
        TSF: 15282100261 usec (0d, 04:14:42)
        freq: 5180
        beacon interval: 102
        capability: ESS Privacy SpectrumMgmt (0x0111)
        signal: -70.00 dBm
        last seen: 3113 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0xc Bitmap[0] 0x0 (+ 3 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [36 - 64] @ 23 dBm
                Channels [100 - 116] @ 23 dBm
                Channels [132 - 140] @ 30 dBm
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 36
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 8c:b6:4f:2a:4e:af (on wlan0)
        TSF: 265350979621 usec (3d, 01:42:30)
        freq: 5240
        beacon interval: 102
        capability: ESS Privacy SpectrumMgmt (0x0111)
        signal: -73.00 dBm
        last seen: 2739 ms ago
        SSID: Linux Foundation
        Supported rates: 12.0* 18.0* 24.0 36.0 48.0 54.0 
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x15 Bitmap[0] 0x0 (+ 3 octets)
        Country: ES     Environment: Indoor/Outdoor
                Channels [36 - 64] @ 23 dBm
                Channels [100 - 116] @ 23 dBm
                Channels [132 - 140] @ 30 dBm
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        HT operation:
                 * primary channel: 48
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: non-HT mixed
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec

I applied the patches on top of Linus' tree:

1e207eb1c3f0e8b690401f02fe08e7b53903f010

> I was trying Seth's patches with 4313 and 43224 devices on 3.7-rc3 as
> well and did not run into anything like this.

What I did was to resume the laptop and told ConnMan me that the automatic
connect to to connect to 'Linux Foundation' network failed and then I told
ConnMan to try again to connect. That triggered the panic.  I don't have 
any logs for this. 

cheers,
daniel
