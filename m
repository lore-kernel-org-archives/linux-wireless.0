Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40319 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2KSCjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 21:39:16 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so97586pad.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Nov 2012 18:39:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAAOJK0u4CH31Kl5v1RPAzyrZCgQAAEAAAAPHUAOFX2ZxCslfE3J6mUdcBAAAAAA==@gmail.com>
References: <!&!AAAAAAAAAAAYAAAAAAAAAOJK0u4CH31Kl5v1RPAzyrZCgQAAEAAAAPZ+jv3Bp7FBumOZuSWcpNUBAAAAAA==@gmail.com>
	<!&!AAAAAAAAAAAYAAAAAAAAAOJK0u4CH31Kl5v1RPAzyrZCgQAAEAAAAPHUAOFX2ZxCslfE3J6mUdcBAAAAAA==@gmail.com>
Date: Sun, 18 Nov 2012 18:39:15 -0800
Message-ID: <CAJ-Vmo=g4SD01b+jwpKXAw5mGrTdyXV7MGZJMMxVEK26q1kT1Q@mail.gmail.com> (sfid-20121119_033920_189432_297BFB6B)
Subject: Re: WLAN UB-5 AR5414 (5GHz)
From: Adrian Chadd <adrian@freebsd.org>
To: Walter Robert Ditzler <ditwal001@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default regdomain 0x0 is giving you a "world" regulatory
configuration, which ends up disabling IBSS/hostap for 5GHz mode (ie,
all channels are passive.)



Adrian


On 18 November 2012 17:56, Walter Robert Ditzler <ditwal001@gmail.com> wrote:
> hi there,
>
> i can't get the WLAN UB-5 AR5414 (5GHz) to run. i tried:
>
> ***
> ifconfig wlan0 down
> iw dev wlan0 del
> iw phy phy0 interface add wlan0 type adhoc
> iwconfig wlan0 mode ad-hoc essid xxxh ap 00:00:00:78:9a:bc channel 48
> ifconfig mesh0 10.10.10.2 up
> ***
>
> and i tried with hostapd
>
> **
> interface=wlan0
> driver=nl80211
> ssid=xxx
> hw_mode=a
> channel=48
> ***
>
> nothing happend. i also cant get a dump oft he card. my hardware is alix2d2,
> debian 6.0.6, kernel 3.6.5, cf install with flashybrid.
>
> thanks a lot for help,
>
> walter.
>
>
>
> *** iwconfig
> root@srv-ldeb-mesh01:~# iwconfig
> ip_vti0   no wireless extensions.
>
> gre0      no wireless extensions.
>
> wlan0     IEEE 802.11a  Mode:Master  Tx-Power=0 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:on
>
> lo        no wireless extensions.
>
> eth0      no wireless extensions.
>
> eth1      no wireless extensions.
>
> wlan1     IEEE 802.11abgn  Mode:Master  Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:on
>
> tunl0     no wireless extensions.
> ***
>
> *** iw list
> root@srv-ldeb-mesh01:~# iw list
> Wiphy phy1
>         Band 1:
>                 Frequencies:
>                         * 5040 MHz [8] (disabled)
>                         * 5060 MHz [12] (disabled)
>                         * 5080 MHz [16] (disabled)
>                         * 5180 MHz [36] (20.0 dBm) (passive scanning, no
> IBSS)
>                         * 5200 MHz [40] (20.0 dBm) (passive scanning, no
> IBSS)
>                         * 5220 MHz [44] (20.0 dBm) (passive scanning, no
> IBSS)
>                         * 5240 MHz [48] (20.0 dBm) (passive scanning, no
> IBSS)
>                         * 5260 MHz [52] (disabled)
>                         * 5280 MHz [56] (disabled)
>                         * 5300 MHz [60] (disabled)
>                         * 5320 MHz [64] (disabled)
>                         * 5500 MHz [100] (disabled)
>                         * 5520 MHz [104] (disabled)
>                         * 5540 MHz [108] (disabled)
>                         * 5560 MHz [112] (disabled)
>                         * 5580 MHz [116] (disabled)
>                         * 5600 MHz [120] (disabled)
>                         * 5620 MHz [124] (disabled)
>                         * 5640 MHz [128] (disabled)
>                         * 5660 MHz [132] (disabled)
>                         * 5680 MHz [136] (disabled)
>                         * 5700 MHz [140] (disabled)
>                         * 5745 MHz [149] (20.0 dBm) (passive scanning, no
> IBSS)
>                         * 5765 MHz [153] (20.0 dBm) (passive scanning, no
> IBSS)
>                         * 5785 MHz [157] (20.0 dBm) (passive scanning, no
> IBSS)
>                         * 5805 MHz [161] (20.0 dBm) (passive scanning, no
> IBSS)
>                         * 5825 MHz [165] (20.0 dBm) (passive scanning, no
> IBSS)
>                 Bitrates (non-HT):
>                         * 6.0 Mbps
>                         * 9.0 Mbps
>                         * 12.0 Mbps
> ***
>
> *** dmesg |grep ath
> root@srv-ldeb-mesh01:~# dmesg |grep ath
> [    5.429666] openvswitch: Open vSwitch switching datapath
> [   14.617030]  [<c104e3ff>] ? warn_slowpath_common+0xf2/0x132
> [   14.617218]  [<c104e561>] ? warn_slowpath_fmt+0x5d/0x7d
> [   17.049225] ath: EEPROM regdomain: 0x0
> [   17.049250] ath: EEPROM indicates default country code should be used
> [   17.049263] ath: doing EEPROM country->regdmn map search
> [   17.049284] ath: country maps to regdmn code: 0x3a
> [   17.049299] ath: Country alpha2 being used: US
> [   17.049313] ath: Regpair used: 0x3a
> [   17.186484] ieee80211 phy0: Selected rate control algorithm
> 'ath9k_rate_control'
> [   17.188842] Registered led device: ath9k-phy0
> [   17.232418] ath5k 0000:00:0e.0: registered as 'phy1'
> [   18.047742] ath: EEPROM regdomain: 0x0
> [   18.047767] ath: EEPROM indicates default country code should be used
> [   18.047780] ath: doing EEPROM country->regdmn map search
> [   18.047801] ath: country maps to regdmn code: 0x3a
> [   18.047816] ath: Country alpha2 being used: US
> [   18.047830] ath: Regpair used: 0x3a
> [   18.051916] ath5k: phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> root@srv-ldeb-mesh01:~#
> ***
