Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35251 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbeEOMaR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 08:30:17 -0400
Received: by mail-lf0-f45.google.com with SMTP id y72-v6so23108517lfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 05:30:16 -0700 (PDT)
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Research + questions on brcmfmac and support for monitor mode
Message-ID: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com> (sfid-20180515_143022_278962_8A435D19)
Date: Tue, 15 May 2018 14:29:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm interested in adding support for monitor mode to the brcmfmac. I did
some early research on firmware capabilities & behavior using various
firmwares I could find for my devices: 43602a1, 4366b1, 4366c0 (BCM4366
and BCM4366E).

I was doing my tests by starting monitor mode with SET_MONITOR ioctl +
value 3 and dumping msgbuf RX header + skb data.

The good news is that almost every firmware has some minimal support for
monitor mode. Unfortunately implementing it may be (a big?) problem.

The basic concept is simple. Once we set SET_MONITOR to 3, firmware
starts passing up monitor mode frames to the driver.



The first problem I see is identifying monitor mode frames in order to
make brcmfmac pass them to the monitor interface. Monitor frames have
msg.ifidx set to 0 which makes them indistinguishable from main
interface frames by simply looking at that index field. There is nothing
in the msg.rsvd0, compl_hdr.status, rx_status_0 or rx_status_1 fields.

Now, some new firmwares have flags set to 0x0002 (instead of 0x0001) for
monitor frames. This is very helpful but it only applies to the really
recent images.

My first question is: is there any reliable way of filtering monitor
frames for older firmwares? We could try to reserve ifidx 0 for monitor
mode purposes, but I'm afraid I'd require hacking quite some code. Is
there any better & simpler solution?



The second problem is monitor frame format. Older firmwares were simply
passing 802.11 frames to the driver. It means passing frame control
field, duration, AP MAC, src MAC, dst MAC, sequence + data. There was no
info about signal, noise, etc. passed. New firmwares seem to be
including radiotap header which makes things much nicer.

The second question: is there a reliable way of telling what format uses
monitor packet passed by a firmware? Is it maybe strictly related to the
flags set to 0x0002 (instead of 0x0001)?



I was hoping that maybe looking at fw-reported capabilities will give me
any hint regarding that but I'm afraid I'm out of luck. Below is a list
of firmwares I tested and summary of each of them.

Note: as every firmware reports following capabilities:
802.11d 802.11h ampdu ampdu_rx ampdu_tx amsdurx amsdutx anqpo ap bcm_dcs
bsstrans cac cqa dfrts dwds led mfp p2po probresp_mac_filter pspretend
psr psta radio_pwrsave rm rxchain_pwrsave sta stbc-rx-1ss stbc-tx
traffic-mgmt traffic-mgmt-dwm vht-prop-rates wds wet wet_tunnel wme wnm
I omitted them below.

*****

1) brcmfmac43602-pcie.ap.bin from linux-firmware.git
Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269

Monitor frames without raiotap

flags: 0x0001

Extra caps: mbss4 ndoe proptxstatus

*****

2) brcmfmac4366b-pcie.bin from linux-firmware.git
Firmware version = wl0: Jan  8 2016 12:54:07 version 10.10.69.3309 (r610991) FWID 01-c47a91a4

Monitor frames without raiotap

flags: 0x0001

Extra caps: ccx mbss8 multi-user-beamformer proptxstatus
single-user-beamformee single-user-beamformer toe txpwrcache

*****

3) 4366b1 development branch (from Arend)
Firmware version = wl0: Oct  6 2016 10:17:32 version 10.10 (TOB) (r663589) FWID 01-6c5a1687

Monitor frames without raiotap

flags: 0x0001

Extra caps: bgdfs ccx mbss8 multi-user-beamformer proptxstatus
single-user-beamformee single-user-beamformer toe txpwrcache

*****

4) brcmfmac4366c-pcie.bin.k3
Firmware version = wl0: Aug 19 2016 15:22:35 version 10.10.69.74 (r629731 WLTEST) FWID 01-5c0166fa

Monitor frames without raiotap

flags: 0x0001

Extra caps: bgdfs ccx cptlv-4 mbss8 multi-user-beamformee
multi-user-beamformer single-user-beamformee single-user-beamformer toe
txpwrcache

*****

5) brcmfmac4366c-pcie.bin.ea9500
Firmware version = wl0: Aug 23 2016 17:19:51 version 10.10.69.69 (r625687) FWID 01-8438621f

Monitor frames without raiotap

flags: 0x0001

Extra caps: bgdfs ccx mbss8 multi-user-beamformee multi-user-beamformer
proptxstatus single-user-beamformee single-user-beamformer toe
txpwrcache

*****

6) brcmfmac4366c-pcie.bin.ac88u
Firmware version = wl0: Sep 12 2016 13:26:44 version 10.10.69.6908 (r658761) FWID 01-fed440e1

Monitor frames without raiotap

flags: 0x0001

Extra caps: bgdfs ccx cptlv-4 mbss8 multi-user-beamformee
multi-user-beamformer proptxstatus single-user-beamformee
single-user-beamformer toe txpwrcache

*****

7) brcmfmac4366c-pcie.bin.asus-dhd24
Firmware version = wl0: Nov  7 2017 12:23:08 version 10.10.69.69017 (r730013) FWID 01-e258597c

Monitor frames include radiotap header

flags: 0x0002

Extra caps: bgdfs ccx cptlv-4 mbss8 multi-user-beamformee
multi-user-beamformer proptxstatus single-user-beamformee
single-user-beamformer toe txpwrcache

*****

8) 4366c0 fw from FW_EA9500v2_EA9500S_2.1.1.183171_prod.img
Firmware version = wl0: Aug  2 2017 18:45:13 version 10.10.122.20 (r683106) FWID 01-91326ac8

Monitor frames include radiotap header

flags: 0x0002

Extra caps: 160 bgdfs ccx dyn160 mbss8 multi-user-beamformee
multi-user-beamformer proptxstatus single-user-beamformee
single-user-beamformer toe txpwrcache

*****

9) 4366c0 fw from GT-AC5300_3.0.0.4_382_15984-gf481f58_cferom_ubi_0824.w
Firmware version = wl0: Aug 17 2017 08:13:19 version 10.10.122.20 (r683106) FWID 01-bbb1a4c

Monitor frames include radiotap header

flags: 0x0002

Extra caps: 160 bgdfs ccx cptlv-4 dyn160 mbss8 multi-user-beamformee
multi-user-beamformer proptxstatus single-user-beamformee
single-user-beamformer toe txpwrcache

*****

10) 4366c0 fw from ArcherC5400X(US)_171023.bin
Firmware version = wl0: Sep 14 2017 14:10:23 version 10.10.122.20 (r683106) FWID 01-9f0e64f9

Monitor frames include radiotap header

flags: 0x0002

Extra caps: 160 bgdfs ccx dyn160 mbss8 multi-user-beamformee
multi-user-beamformer proptxstatus single-user-beamformee
single-user-beamformer toe txpwrcache
