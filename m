Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:50897 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754524AbcKBOd6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:33:58 -0400
To: Matteo Grandi <iu5bdp@gmail.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
References: <CAHdg3xa1uOuBoncz5YwLRmC-HWMsuVmNkWoPB=0tWavcpWNkgQ@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <aaf49f21-cd87-fb66-3fca-83114819368b@dd-wrt.com> (sfid-20161102_153403_474458_C6367370)
Date: Wed, 2 Nov 2016 15:33:54 +0100
MIME-Version: 1.0
In-Reply-To: <CAHdg3xa1uOuBoncz5YwLRmC-HWMsuVmNkWoPB=0tWavcpWNkgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: ath10k and compex WLE600V5-27
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

depends how you test. the antennas need to have the right distance from 
each other (portion of lampda)
and mimo also doesnt work well at too short distances. so place them at 
10 meters distance minimum

Am 02.11.2016 um 15:27 schrieb Matteo Grandi:
> Hello all,
> I'm using two WiFi module Compex WLE600V5-27
> http://www.compex.com.sg/product/wle600v5-27/
> capable of 2x2 MIMO on two boards (Gateworks ventana 5410) using ath10k drivers.
> The chipset is the Qualcomm-Atheros QCA9882 but I didn't find a
> firmware for this chipset, so I'm using the QCA988X.
> Everithing worked fine until I tried to plug 2 antennas in both cards
> in order to make some data-rate tests. Even if there are two antennas
> plugged in, there aren't any changes in the data-rate measured between
> using one or two antennas. Sniffing the channel I sow that the Number
> of STBC streams is 1 and iw list shows that only 1 spatial stream is
> supported (but the card is capable of managing 2 spatial streams):
>
> Wiphy phy0
>      Band 1:
>          Capabilities: 0x19e3
>              RX LDPC
>              HT20/HT40
>              Static SM Power Save
>              RX HT20 SGI
>              RX HT40 SGI
>              TX STBC
>              RX STBC 1-stream
>              Max AMSDU length: 7935 bytes
>              DSSS/CCK HT40
>          Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>          Minimum RX AMPDU time spacing: 8 usec (0x06)
>          HT TX/RX MCS rate indexes supported: 0-15
>          Frequencies:
>              * 5180 MHz [36] (17.0 dBm)
>              * 5200 MHz [40] (17.0 dBm)
> ...
>
>      Available Antennas: TX 0x3 RX 0x3
>      Configured Antennas: TX 0x3 RX 0x3
>      Supported interface modes:
>           * managed
>           * AP
>           * AP/VLAN
>           * monitor
>           * mesh point
>
>
> I tried the tests both on channel 48 HT40- and 149 HT40+.
> The RSSI measured with iw station dump lays around -40dBm
>
> Is it an issue related to the firmware in use?
> Or maybe there aren't the right conditions to have MIMO working?
>
> Thanks in advence
> All the best
>
> Matteo
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
