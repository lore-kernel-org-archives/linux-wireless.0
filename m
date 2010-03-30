Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:57922 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab0C3P3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 11:29:50 -0400
Received: by mail-fx0-f223.google.com with SMTP id 23so384381fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 08:29:50 -0700 (PDT)
Message-ID: <4BB218EB.2000301@googlemail.com>
Date: Tue, 30 Mar 2010 17:29:47 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	hostap@lists.shmoo.com
CC: linux-wireless@vger.kernel.org
Subject: No 80211n possible with AR9220?
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear ath9k-developers!
Dear hostapd-developers!

I cannot reach 802.11n-speeds using an Atheros-Chipset, that is said to
be supported by ath9k:
http://wireless.kernel.org/en/users/Drivers/ath9k#supported_chipsets -
see AR9220.

The long story:
I bought two brandnew Senao EMP-7605 Wireless Cards, which use the
Atheros AR9220 chipset. The two cards are each plugged into a dedicated
ALIX-Board from PCEngines and the system running is Debian Lenny with
Kernel 2.6.32.10:

# uname -a
Linux DebianLennyClient 2.6.32.10 #1 SMP Tue Mar 30 12:54:18 UTC 2010
i586 GNU/Linux

I compiled it on my own, it has the mac80211 compiled into the kernel
(no module) and of course ath9k. hostapd comes with a git-snapshot from
2010-02-20, available here:

http://hostap.epitest.fi/gitweb/gitweb.cgi?p=hostap-06.git;a=summary

I kept my hostapd.conf as simple as I could just for checking, if I can
reach functionality at all:

# cat hostapd.conf
interface=wlan0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=testsalat
hw_mode=g
channel=11
auth_algs=1


With this setup, I can do a

# iw wlan1 connect testsalat

and afterwards, a ping gets through:

# ping 192.168.55.1
PING 192.168.55.1 (192.168.55.1) 56(84) bytes of data.
64 bytes from 192.168.55.1: icmp_seq=1 ttl=64 time=258 ms
64 bytes from 192.168.55.1: icmp_seq=2 ttl=64 time=56.5 ms
64 bytes from 192.168.55.1: icmp_seq=3 ttl=64 time=54.9 ms

So I can reach main functionality. If now I go ahead an set up 802.11n,
it stops working at all. My hostapd.conf is still the same as mentioned
above with these additions:

wmm_enabled=1
wmm_ac_bk_cwmin=4
wmm_ac_bk_cwmax=10
wmm_ac_bk_aifs=7
wmm_ac_bk_txop_limit=0
wmm_ac_bk_acm=0
wmm_ac_be_aifs=3
wmm_ac_be_cwmin=4
wmm_ac_be_cwmax=10
wmm_ac_be_txop_limit=0
wmm_ac_be_acm=0
wmm_ac_vi_aifs=2
wmm_ac_vi_cwmin=3
wmm_ac_vi_cwmax=4
wmm_ac_vi_txop_limit=94
wmm_ac_vi_acm=0
wmm_ac_vo_aifs=2
wmm_ac_vo_cwmin=2
wmm_ac_vo_cwmax=3
wmm_ac_vo_txop_limit=47
wmm_ac_vo_acm=0
ieee80211n=1
ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]

The capabilities have been taken from this output:

# iw list
Wiphy phy0
    Band 1:
        Capabilities: 0x104e
            HT20/HT40
            SM Power Save disabled
            RX HT40 SGI
            No RX STBC
            Max AMSDU length: 7935 bytes
            DSSS/CCK HT40
        Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
        Minimum RX AMPDU time spacing: 8 usec (0x06)
        HT TX/RX MCS rate indexes supported: 0-15
        Frequencies:
            * 2412 MHz [1] (20.0 dBm)
            * 2417 MHz [2] (20.0 dBm)
            * 2422 MHz [3] (20.0 dBm)
            * 2427 MHz [4] (20.0 dBm)
            * 2432 MHz [5] (20.0 dBm)
            * 2437 MHz [6] (20.0 dBm)
            * 2442 MHz [7] (20.0 dBm)
            * 2447 MHz [8] (20.0 dBm)
            * 2452 MHz [9] (20.0 dBm)
            * 2457 MHz [10] (20.0 dBm)
            * 2462 MHz [11] (20.0 dBm)
            * 2467 MHz [12] (disabled)
            * 2472 MHz [13] (disabled)
            * 2484 MHz [14] (disabled)
        Bitrates (non-HT):
            * 1.0 Mbps
            * 2.0 Mbps (short preamble supported)
            * 5.5 Mbps (short preamble supported)
            * 11.0 Mbps (short preamble supported)
            * 6.0 Mbps
            * 9.0 Mbps
            * 12.0 Mbps
            * 18.0 Mbps
            * 24.0 Mbps
            * 36.0 Mbps
            * 48.0 Mbps
            * 54.0 Mbps
    Band 2:
        Capabilities: 0x104e
            HT20/HT40
            SM Power Save disabled
            RX HT40 SGI
            No RX STBC
            Max AMSDU length: 7935 bytes
            DSSS/CCK HT40
        Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
        Minimum RX AMPDU time spacing: 8 usec (0x06)
        HT TX/RX MCS rate indexes supported: 0-15
        Frequencies:
            * 5180 MHz [36] (20.0 dBm) (passive scanning, no IBSS)
            * 5200 MHz [40] (20.0 dBm) (passive scanning, no IBSS)
            * 5220 MHz [44] (20.0 dBm) (passive scanning, no IBSS)
            * 5240 MHz [48] (20.0 dBm) (passive scanning, no IBSS)
            * 5260 MHz [52] (disabled)
            * 5280 MHz [56] (disabled)
            * 5300 MHz [60] (disabled)
            * 5320 MHz [64] (disabled)
            * 5500 MHz [100] (disabled)
            * 5520 MHz [104] (disabled)
            * 5540 MHz [108] (disabled)
            * 5560 MHz [112] (disabled)
            * 5580 MHz [116] (disabled)
            * 5600 MHz [120] (disabled)
            * 5620 MHz [124] (disabled)
            * 5640 MHz [128] (disabled)
            * 5660 MHz [132] (disabled)
            * 5680 MHz [136] (disabled)
            * 5700 MHz [140] (disabled)
            * 5745 MHz [149] (20.0 dBm) (passive scanning, no IBSS)
            * 5765 MHz [153] (20.0 dBm) (passive scanning, no IBSS)
            * 5785 MHz [157] (20.0 dBm) (passive scanning, no IBSS)
            * 5805 MHz [161] (20.0 dBm) (passive scanning, no IBSS)
            * 5825 MHz [165] (20.0 dBm) (passive scanning, no IBSS)
        Bitrates (non-HT):
            * 6.0 Mbps
            * 9.0 Mbps
            * 12.0 Mbps
            * 18.0 Mbps
            * 24.0 Mbps
            * 36.0 Mbps
            * 48.0 Mbps
            * 54.0 Mbps
    max # scan SSIDs: 4
    Fragmentation threshold: 2346
    RTS threshold: 2347
    Supported interface modes:
         * IBSS
         * managed
         * AP
         * AP/VLAN
         * monitor
         * mesh point
    Supported commands:
         * new_interface
         * set_interface
         * new_key
         * new_beacon
         * new_station
         * set_bss
         * authenticate
         * associate
         * deauthenticate
         * disassociate
         * join_ibss
         * set_wiphy_netns
         * connect
         * disconnect

According to my understanding, this should do quite well, but as soon as
I add "ieee80211n=1" to my hostapd.conf, I can't even get a ping
through. The client associates, as told by the debug output of hostapd,
but it's not able to ping. This is independant of using wpa_supplicant
or iw to associate. So I am not able to test the performance of 802.11n
on these cards at all. In addition, I am always connected with 1 Mbit/s,
which shouldn't be correct either:

# iw dev wlan1 link
Connected to 00:0e:8e:24:52:2f (on wlan1)
    SSID: testsalat
    freq: 2462
    RX: 40496 bytes (404 packets)
    TX: 3046 bytes (38 packets)
    signal: -48 dBm
    tx bitrate: 1.0 MBit/s

This is my dmesg from boot-time:

# dmesg | grep ath
[    7.526966] ath: EEPROM regdomain: 0x37
[    7.526981] ath: EEPROM indicates we should expect a direct regpair map
[    7.527000] ath: Country alpha2 being used: AT
[    7.527014] ath: Regpair used: 0x37
[    8.321933] phy0: Selected rate control algorithm 'ath9k_rate_control'
[    8.335132] Registered led device: ath9k-phy0::radio
[    8.337203] Registered led device: ath9k-phy0::assoc
[    8.339262] Registered led device: ath9k-phy0::tx
[    8.341078] Registered led device: ath9k-phy0::rx

Are all of these observations due to bugs or am I misconfiguring my
system somehow? If you need more debugging output, just tell me!

Kind regards,
Dennis
