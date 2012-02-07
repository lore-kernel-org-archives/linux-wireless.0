Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:42061 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab2BGIVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 03:21:24 -0500
Received: by qafk1 with SMTP id k1so4073832qaf.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 00:21:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com>
References: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com>
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Tue, 7 Feb 2012 09:20:53 +0100
Message-ID: <CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com> (sfid-20120207_092128_363067_6080FC23)
Subject: Re: Setting up an AP @ 5 GHz 802.11a - hostapd refuses [Could not
 select hw_mode and channel. (-1)]
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok I studied some more.

I found an howto http://forum.aircrack-ng.org/index.php?topic=7826.0
to edit db.txt and create a custom regulatory.bin (including the
openWrt patch to drivers/net/wireless/ath/regd.c).

I also found out about ath_info
http://madwifi-project.org/wiki/UserDocs/AthInfo and I rewrote my
regdomain:
./ath_info -v -g 4:0 -w 0xeffd0000 regdomain 0x68

I can tell these things worked since I can now fully access the 2.4
GHz channels (before I couldn't use 12 and 13):
Wiphy phy0
        Band 1:
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
                        * 2467 MHz [12] (20.0 dBm)
                        * 2472 MHz [13] (20.0 dBm)
                        * 2484 MHz [14] (disabled)

*** But why I still can't access any channel at 5 GHz? *** and what's
the meaning of (disabled)? Is this due to a hardware limitation?
In the 2.4 band, I managed to switch channel 12 and 13 from (passive
scanning) to available and channel 14 from (passive scanning) to
(disabled). Why?

This is the situation at 5 Ghz:

        Band 2:
                Frequencies:
                        * 5040 MHz [8] (disabled)
                        * 5060 MHz [12] (disabled)
                        * 5080 MHz [16] (disabled)
                        * 5180 MHz [36] (30.0 dBm) (passive scanning, no IBSS)
                        * 5200 MHz [40] (30.0 dBm) (passive scanning, no IBSS)
                        * 5220 MHz [44] (30.0 dBm) (passive scanning, no IBSS)
                        * 5240 MHz [48] (30.0 dBm) (passive scanning, no IBSS)
                        * 5260 MHz [52] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5280 MHz [56] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5300 MHz [60] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5320 MHz [64] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5500 MHz [100] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5520 MHz [104] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5540 MHz [108] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5560 MHz [112] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5580 MHz [116] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5600 MHz [120] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5620 MHz [124] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5640 MHz [128] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5660 MHz [132] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5680 MHz [136] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5700 MHz [140] (30.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5745 MHz [149] (30.0 dBm) (passive scanning, no IBSS)
                        * 5765 MHz [153] (30.0 dBm) (passive scanning, no IBSS)
                        * 5785 MHz [157] (30.0 dBm) (passive scanning, no IBSS)
                        * 5805 MHz [161] (30.0 dBm) (passive scanning, no IBSS)
                        * 5825 MHz [165] (30.0 dBm) (passive scanning, no IBSS)

Thank you,
alfonso

On Fri, Feb 3, 2012 at 7:46 PM, Alfonso Fiore <alfonso.fiore@gmail.com> wrote:
>
> Hi,
>
> I have an embedded system (ALIX) with an Atheros AR5414 chipset (802.11 a/b/g)
>
> I realized I have a wireless pollution problem at 2.4 GHz, so I
> thought to setup an 802.11a AP (5 GHz).
>
> hostapd tells me I have only 2.4 GHz channels available. Why?
> Is there a chance to use the 5 Ghz channels? As I realize it's a
> regulatory issue, I live in France.
>
> I attached output of
> - /usr/sbin/hostapd -dd  /etc/hostapd/hostapd.wlan0.conf
> - iw list
> - cat /etc/hostapd/hostapd.wlan0.conf
>
> thank you,
> alfonso
>
> # /usr/sbin/hostapd -dd  /etc/hostapd/hostapd.wlan0.conf
> Configuration file: /etc/hostapd/hostapd.wlan0.conf
> Line 9: DEPRECATED: 'debug' configuration variable is not used anymore
> eapol_version=1
> nl80211: Add own interface ifindex 3
> nl80211: New interface mon.wlan0 created: ifindex=25
> nl80211: Add own interface ifindex 25
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Added 802.11b mode based on 802.11g information
> Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
> Could not select hw_mode and channel. (-1)
> wlan0: Unable to setup interface.
> Flushing old station entries
> Deauthenticate all stations
> nl80211: Remove interface ifindex=25
> netlink: Operstate: linkmode=0, operstate=6
>
> # iw list
> Failed to read classid file: Object not found
> Wiphy phy0
>        Band 1:
>                Frequencies:
>                        * 2412 MHz [1] (20.0 dBm)
>                        * 2417 MHz [2] (20.0 dBm)
>                        * 2422 MHz [3] (20.0 dBm)
>                        * 2427 MHz [4] (20.0 dBm)
>                        * 2432 MHz [5] (20.0 dBm)
>                        * 2437 MHz [6] (20.0 dBm)
>                        * 2442 MHz [7] (20.0 dBm)
>                        * 2447 MHz [8] (20.0 dBm)
>                        * 2452 MHz [9] (20.0 dBm)
>                        * 2457 MHz [10] (20.0 dBm)
>                        * 2462 MHz [11] (20.0 dBm)
>                        * 2467 MHz [12] (20.0 dBm) (passive scanning)
>                        * 2472 MHz [13] (20.0 dBm) (passive scanning)
>                        * 2484 MHz [14] (20.0 dBm) (passive scanning)
>                Bitrates (non-HT):
>                        * 1.0 Mbps
>                        * 2.0 Mbps (short preamble supported)
>                        * 5.5 Mbps (short preamble supported)
>                        * 11.0 Mbps (short preamble supported)
>                        * 6.0 Mbps
>                        * 9.0 Mbps
>                        * 12.0 Mbps
>                        * 18.0 Mbps
>                        * 24.0 Mbps
>                        * 36.0 Mbps
>                        * 48.0 Mbps
>                        * 54.0 Mbps
>        Band 2:
>                Frequencies:
>                        * 5040 MHz [8] (disabled)
>                        * 5060 MHz [12] (disabled)
>                        * 5080 MHz [16] (disabled)
>                        * 5180 MHz [36] (30.0 dBm) (passive scanning, no IBSS)
>                        * 5200 MHz [40] (30.0 dBm) (passive scanning, no IBSS)
>                        * 5220 MHz [44] (30.0 dBm) (passive scanning, no IBSS)
>                        * 5240 MHz [48] (30.0 dBm) (passive scanning, no IBSS)
>                        * 5260 MHz [52] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5280 MHz [56] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5300 MHz [60] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5320 MHz [64] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5500 MHz [100] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5520 MHz [104] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5540 MHz [108] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5560 MHz [112] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5580 MHz [116] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5600 MHz [120] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5620 MHz [124] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5640 MHz [128] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5660 MHz [132] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5680 MHz [136] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5700 MHz [140] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)
>                        * 5745 MHz [149] (30.0 dBm) (passive scanning, no IBSS)
>                        * 5765 MHz [153] (30.0 dBm) (passive scanning, no IBSS)
>                        * 5785 MHz [157] (30.0 dBm) (passive scanning, no IBSS)
>                        * 5805 MHz [161] (30.0 dBm) (passive scanning, no IBSS)
>                        * 5825 MHz [165] (30.0 dBm) (passive scanning, no IBSS)
>                Bitrates (non-HT):
>                        * 6.0 Mbps
>                        * 9.0 Mbps
>                        * 12.0 Mbps
>                        * 18.0 Mbps
>                        * 24.0 Mbps
>                        * 36.0 Mbps
>                        * 48.0 Mbps
>                        * 54.0 Mbps
>
>
>
> # cat /etc/hostapd/hostapd.wlan0.conf
> interface=wlan0
> driver=nl80211
> logger_syslog=-1
> logger_syslog_level=2
> logger_stdout=-1
> logger_stdout_level=2
> debug=4
> #dump_file=/tmp/hostapd.dump
> #ctrl_interface=/var/run/hostapd
> #ctrl_interface_group=0
> #channel=6
> #hw_mode=g
> # let's try 5 GHz
> channel=40
> hw_mode=a
> macaddr_acl=0
> auth_algs=3
> eapol_key_index_workaround=0
> eap_server=0
> # wpa=3
> # only wpa 2
> wpa=2
> #ssid=voyage-mpd
> ssid=<<my_SSID>>
> #wpa_passphrase=voyage-mpd
> wpa_passphrase=<<my_password>>
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP
> rsn_pairwise=CCMP
> eapol_version=1
> #wme_enabled=1
> #ieee80211n=1
> #ht_capab=[HT40-][HT40+][SHORT-GI-40][TX-STBC][RX-STBC1][DSSS_CCK-40]
