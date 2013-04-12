Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:49889 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3DLAD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 20:03:29 -0400
Received: by mail-vb0-f54.google.com with SMTP id w16so1730339vbf.27
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 17:03:28 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Apr 2013 20:03:28 -0400
Message-ID: <CAPutgu8mCmfmsEq0jkqtAN25oUBmCxZLW-kTZrsPKFpCfdJU2A@mail.gmail.com> (sfid-20130412_020332_719144_52D3DC18)
Subject: Centrino Ultimate-N 6300 AGN rfkill always Soft blocked
From: schwaahed <schwaahed@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have an HP Elitebook 8460w laptop containing a Centrino Ultimate-N
6300 AGN (linux-3.8.6 iwlwifi module -  firmware version 9.221.4.1
build 25532)

I am unable to remove the softblock on the chip with rfkill. For the
most part my wifi chip stays soft blocked. The only time I can manage
to get it unblocked is when the wlan0 interface is hard blocked.

I am able to:
- soft block the interface
- hard block the interface
- hard block and softblock the interface

I am not able to:
- soft unblock and hard unblock simultaneously.

I needed to do a fresh install of Gentoo Linux on a new hard drive. I
don't have access to the old hard drive at the moment, but wifi did
work on this older install of gentoo linux.. I am using the iwlwifi
driver and firmware that are part of Gentoo.

After I couldn't get wifi working I installed Windows 7 and the wifi
works fine when I boot into Windows 7.

I have looked many places for a solution and other people have run
accross this problem but none of their solutions work for me.

Here are some of the things that I have tried that have resolved this
problem for others, but not for me:

- unload and reload the iwlwifi module
- disable rfkill and bluetooth in the kernel
- boot with the hardware wifi switch off
- boot with the hardware wifi switch on

I have these kernels installed and ready to run on the new harddrive
they all exhibit this same behavior:

linux-3.6.11-r2
linux-3.7.10
linux-3.7.10-r1
linux-3.8.5
linux-3.8.6

I started out with linux-3.8.5 on this new harddrive. Wifi was working
fine with linux-3.7.10-r1 on the old harddrive (same machine). If
anyone has any insight into how I might solve this problem I would
really appreciate a push in the right direction.

Thanks
- Darwin


Below I've given a record of some of the commands I've tried to use to
unblock rfkill and some info about my system:


# iwconfig

wlan0     IEEE 802.11abgn  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=off
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

# ifconfig wlan0 up

SIOCSIFFLAGS: Operation not possible due to RF-kill

# rfkill list all

0: phy0: Wireless LAN
Soft blocked: yes
Hard blocked: no

# rfkill unblock all
# rfkill list all

0: phy0: Wireless LAN
Soft blocked: yes
Hard blocked: no

PRESS HARDWARE WIFI BUTTON, LED CHANGES TO ORANGE-OFF

# rfkill list all

0: phy0: Wireless LAN
Soft blocked: yes
Hard blocked: yes

# rfkill unblock 0
# rfkill list all

0: phy0: Wireless LAN
Soft blocked: no
Hard blocked: yes

PRESS HARDWARE WIFI BUTTON, LED CHANGES TO WHITE-ON

# rfkill list all

0: phy0: Wireless LAN
Soft blocked: yes
Hard blocked: no


PRESS HARDWARE WIFI BUTTON, LED CHANGES TO ORANGE-OFF

# rfkill list all

0: phy0: Wireless LAN
Soft blocked: yes
Hard blocked: yes

PRESS HARDWARE WIFI BUTTON, LED CHANGES TO WHITE-ON

# rfkill list all

0: phy0: Wireless LAN
Soft blocked: yes
Hard blocked: no


portion of dmesg output

[    3.636945] iwlwifi 0000:25:00.0: loaded firmware version 9.221.4.1
build 25532
[    3.666672] cfg80211: World regulatory domain updated:
[    3.666676] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    3.666680] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    3.666735] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    3.666738] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    3.666780] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    3.666784] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
...
[    3.671565] iwlwifi 0000:25:00.0: CONFIG_IWLWIFI_DEBUG enabled
[    3.671569] iwlwifi 0000:25:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[    3.671571] iwlwifi 0000:25:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[    3.671574] iwlwifi 0000:25:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    3.671576] iwlwifi 0000:25:00.0: CONFIG_IWLWIFI_P2P enabled
[    3.671579] iwlwifi 0000:25:00.0: Detected Intel(R) Centrino(R)
Ultimate-N 6300 AGN, REV=0x74
[    3.671651] iwlwifi 0000:25:00.0: L1 Disabled; Enabling L0S
[    3.671787] iwlwifi 0000:25:00.0: RF_KILL bit toggled to enable radio.
[    3.693396] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'


# lsmod

Module                  Size  Used by
iptable_nat             2858  0
nf_nat_ipv4             3703  1 iptable_nat
nf_nat                 15405  2 nf_nat_ipv4,iptable_nat
snd_hda_codec_hdmi     28108  1
iwldvm                233069  0
mac80211              524815  1 iwldvm
snd_hda_codec_idt      60778  1
radeon                912449  1
iwlwifi               161962  1 iwldvm
i2c_algo_bit            5681  1 radeon
snd_hda_intel          34488  0
drm_kms_helper         33940  1 radeon
snd_hda_codec         106132  3
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel
ttm                    70693  1 radeon
snd_hwdep               6010  1 snd_hda_codec
snd_pcm                81985  3 snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel
kvm                   422194  0
snd_page_alloc          8204  2 snd_pcm,snd_hda_intel
cfg80211              493526  3 iwlwifi,mac80211,iwldvm
snd_timer              19874  1 snd_pcm
drm                   252792  3 ttm,drm_kms_helper,radeon
agpgart                31743  2 drm,ttm
snd                    58279  7
snd_hwdep,snd_timer,snd_hda_codec_hdmi,snd_hda_codec_idt,snd_pcm,snd_hda_codec,snd_hda_intel
xhci_hcd               87398  0
firewire_ohci          32771  0
soundcore               1090  1 snd
rfkill                 17656  3 cfg80211
firewire_core          56164  1 firewire_ohci
