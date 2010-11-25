Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55572 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0KYFnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 00:43:49 -0500
Received: by iwn34 with SMTP id 34so506037iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 21:43:49 -0800 (PST)
MIME-Version: 1.0
From: Octav Chipara <ochipara@gmail.com>
Date: Wed, 24 Nov 2010 21:43:28 -0800
Message-ID: <AANLkTikCQPq-HVUJhDet-ZbA97nt+1uYTKgtzvK2cyd7@mail.gmail.com>
Subject: help with ath5k --- wlan0 no private ioctls
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having some problems properly configuring ath5k. I'm trying to set
the retransmission count so that the card will not perform more than a
transmission:

iwconfig wlan0 retry 1

The command succeeds, and if I run iwconfig wlan0, it shows a
transmission of 1. However, the driver behaves as if it makes multiple
retransmissions (there was no decrease in throughput -- tested using
scp and the tcpdump trace seemed to indicate the presence of multiple
retransmissions). I tried to set the value directly using iwpriv and I
get wlan0 no private ioctls.

Any help would be greatly appreciated. Below are my iwconfig and lsmod output.

Thanks,
-- Octav


wlan0     IEEE 802.11abg  ESSID:"wiisard-mesh"
          Mode:Ad-Hoc  Frequency:2.427 GHz  Cell: 8A:BF:8D:26:41:67
          Tx-Power=10 dBm
          Retry limit:0   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

wlan1     IEEE 802.11abg  Mode:Monitor  Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off

=====

Module                  Size  Used by
arc4                    1153  4
ath5k                 130104  0
ath                    13021  1 ath5k
aes_i586                7268  0
mac80211              237508  1 ath5k
pl2303                 15740  0
cfg80211              142500  3 ath5k,ath,mac80211
aes_generic            26863  1 aes_i586
compat                  4997  2 mac80211,cfg80211
usbserial              33019  1 pl2303
geode_aes               4558  0
pcmcia_core            32964  1 compat
geode_rng               1011  0
led_class               2864  1 ath5k
cs5535_gpio             2571  0
pata_cs5536             3224  0
via_rhine              19154  0
pata_amd                8766  1
mii                     4381  1 via_rhine

===

filename:
/lib/modules/2.6.32-21-386/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
version:        0.6.0 (EXPERIMENTAL)
license:        Dual BSD/GPL
description:    Support for 5xxx series of Atheros 802.11 wireless LAN cards.
author:         Nick Kossifidis
author:         Jiri Slaby
srcversion:     94B41D157F11583E198BF6A
alias:          pci:v0000168Cd0000001Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Csv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000019sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000018sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000017sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000016sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000015sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000014sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00001014sv*sd*bc*sc*i*
alias:          pci:v000010B7d00000013sv*sd*bc*sc*i*
alias:          pci:v0000A727d00000013sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000013sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000012sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000011sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000007sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000207sv*sd*bc*sc*i*
depends:        mac80211,led-class,cfg80211,ath
vermagic:       2.6.32-21-386 SMP mod_unload modversions 486
parm:           nohwcrypt:Disable hardware encryption. (bool)
parm:           all_channels:Expose all channels the device can use. (bool)
