Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36730 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0LALVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 06:21:19 -0500
Received: by qyk11 with SMTP id 11so2473005qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 03:21:18 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTik5iZRnfBwD2rdsayoZ=Gj2LAfsNGkA9wd0oibK@mail.gmail.com>
References: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
	<201012011921.11151.br1@einfach.org>
	<AANLkTik5iZRnfBwD2rdsayoZ=Gj2LAfsNGkA9wd0oibK@mail.gmail.com>
Date: Wed, 1 Dec 2010 12:21:17 +0100
Message-ID: <AANLkTikyoz=wCSckLOy3=V-g+7gBf4LmpjaCbiqaE6Kb@mail.gmail.com>
Subject: Re: [linux-next] next-20101201: ath5k permanently disconnecting
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 11:56 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Wed, Dec 1, 2010 at 11:21 AM, Bruno Randolf <br1@einfach.org> wrote:
>> On Wed December 1 2010 19:09:03 Sedat Dilek wrote:
>>> Hi,
>>>
>>> I have built today a linux-next (next-20101201) kernel which includes
>>> wireless-next-2.6 up to master-2010-11-30.
[ ... ]
>>> Unfortunately, my wlan network connection is totally unstable.
[ ... ]
>>> The block looks like this:
>>> [ 4436.504059] ieee80211 phy0: wlan0: No probe response from AP
>>> 00:04:0e:e4:00:3d after 500ms, disconnecting.
>>> [ 4436.504490] cfg80211: Calling CRDA to update world regulatory domain
>>> [ 4440.677020] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
>>> [ 4440.679096] wlan0: authenticated
>>> [ 4440.679158] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
>>> [ 4440.684667] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411
>>> status=0 aid=1)
>>> [ 4440.684673] wlan0: associated
>>>
>>> My wlan device is an ath5k:
>>>
>>> $ lspci -nnvv | grep "Ethernet controller" | grep -i ath
>>> 02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
>>> 802.11abg NIC [168c:1014] (rev 01)
[ ...]
>> 1.) For identification of the chipset, please:
>> dmesg |grep "ath5.*chip"

# grep "Dec  1 09:38" /var/log/syslog | grep "ath5.*chip"
Dec  1 09:38:40 tbox kernel: [    8.233119] ath5k phy0: Atheros AR5212
chip found (MAC: 0x56, PHY: 0x41)

>> 2.) Is there a problem when you don't use encryption?

How do I setup "dont-use-encryption"? Hardware-/Software-encyrption?
For ath5k? Change WLAN setup (in router-config)?

>> 3.) git bisect might help track it down.

Hunting another bug ATM...
Rebuilding right now with ath* debug options (might take a while).

- Sedat -

>
> When does it happen?
> Normal daily usage of Internet-ing... + kernel build with -j5
> (Pentium-M, 1G RAM)...
>
> I have set now as extra (just rebuilding):
> CONFIG_ATH_DEBUG=y
> CONFIG_ATH5K_DEBUG=y
>
> # egrep 'Dec  1 09:38' /var/log/syslog | egrep -i 'ath|80211|wlan'
> Dec  1 09:38:40 tbox kernel: [    6.919633] cfg80211: Calling CRDA to
> update world regulatory domain
> Dec  1 09:38:40 tbox kernel: [    7.401522] ath5k 0000:02:02.0: PCI
> INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
> Dec  1 09:38:40 tbox kernel: [    7.401677] ath5k 0000:02:02.0:
> registered as 'phy0'
> Dec  1 09:38:40 tbox kernel: [    7.689793] ath: EEPROM regdomain: 0x61
> Dec  1 09:38:40 tbox kernel: [    7.689797] ath: EEPROM indicates we
> should expect a direct regpair map
> Dec  1 09:38:40 tbox kernel: [    7.689803] ath: Country alpha2 being used: 00
> Dec  1 09:38:40 tbox kernel: [    7.689805] ath: Regpair used: 0x61
> Dec  1 09:38:40 tbox kernel: [    8.232093] ieee80211 phy0: Selected
> rate control algorithm 'minstrel_ht'
> Dec  1 09:38:40 tbox kernel: [    8.233067] Registered led device:
> ath5k-phy0::rx
> Dec  1 09:38:40 tbox kernel: [    8.233106] Registered led device:
> ath5k-phy0::tx
> Dec  1 09:38:40 tbox kernel: [    8.233119] ath5k phy0: Atheros AR5212
> chip found (MAC: 0x56, PHY: 0x41)
> Dec  1 09:38:40 tbox kernel: [    8.233165] ath5k phy0: RF5111 5GHz
> radio found (0x17)
> Dec  1 09:38:40 tbox kernel: [    8.233202] ath5k phy0: RF2111 2GHz
> radio found (0x23)
> Dec  1 09:38:41 tbox kernel: [   16.753896] ADDRCONF(NETDEV_UP):
> wlan0: link is not ready
> Dec  1 09:38:42 tbox wpa_supplicant[972]: Trying to associate with
> 00:04:0e:e4:00:3d (SSID='myCastle-WLAN WPA (Wireless LAN)' freq=2442
> MHz)
> Dec  1 09:38:42 tbox kernel: [   21.967986] wlan0: authenticate with
> 00:04:0e:e4:00:3d (try 1)
> Dec  1 09:38:42 tbox kernel: [   21.970076] wlan0: authenticated
> Dec  1 09:38:42 tbox kernel: [   21.970094] wlan0: associate with
> 00:04:0e:e4:00:3d (try 1)
> Dec  1 09:38:42 tbox kernel: [   21.975454] wlan0: RX AssocResp from
> 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
> Dec  1 09:38:42 tbox kernel: [   21.975458] wlan0: associated
> Dec  1 09:38:42 tbox kernel: [   21.976415] ADDRCONF(NETDEV_CHANGE):
> wlan0: link becomes ready
> Dec  1 09:38:53 tbox kernel: [   32.848041] wlan0: no IPv6 routers present
> Dec  1 09:38:56 tbox kernel: [   36.320070] ieee80211 phy0: wlan0: No
> probe response from AP 00:04:0e:e4:00:3d after 500ms, disconnecting.
> Dec  1 09:38:56 tbox kernel: [   36.320961] cfg80211: Calling CRDA to
> update world regulatory domain
>
> Full syslog attached.
>
> - Sedat -
>
