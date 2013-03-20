Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f177.google.com ([209.85.210.177]:38795 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab3CTQZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 12:25:33 -0400
Received: by mail-ia0-f177.google.com with SMTP id y25so1508398iay.8
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 09:25:32 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 17:25:32 +0100
Message-ID: <CANq1E4RdbwsbdpHkqszE6QJkf1FLj_6bH95tn=uuyOBw8Z6BNg@mail.gmail.com> (sfid-20130320_172537_329849_2A4FC118)
Subject: Wifi Display TLDS Setup
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I have two proprietary devices, a host (with HDMI display) and a
remote controller (with built-in display) which communicate via wifi
and _very_ likely via WifiDisplay (WFD). I am currently working on a
driver for the controller so we can use it as a remote
display/controller with linux hosts instead of the proprietary host.

However, I need some help from people with 802.11 insights how to do
the connection setup. It works like this:

I first power up both devices. Then I press a "sync" button on both
devices. The host displays a PIN which I need to enter on the remote
device. I now guess that the remote connects to the host and
establishes the connection.
Communication is done via wifi 5150-5250Mhz exclusively.

I tried finding P2P peers during a connection setup but none showed
up. Then I looked for temporary APs and I found one ESSID:
"WiiU34af2c5fa6134af2c5fa61c_STA1" (see [1]) which is created by the
host after pressing the sync button. I can connect to it, perform DHCP
query and ping the host successfully. However, I don't know how to
proceed now.
If I enter the PIN in the remote, it connects to the host and the
temporary AP vanishes and instead I see a hidden AP (see [2]) that is
WPA2 protected.

My guess is, the host uses a temporary soft-AP so remote controllers
can find it. For each controller, it opens a TDLS connection. After
the sync-period is over, it stops the soft-AP.
Why TDLS? Well, the WFD specs mandate P2P or TDLS, and I couldn't find
any P2P peers so I am going for TDLS.

Could anyone give me some hints how to create TDLS connections so I
can try this out? I couldn't find any examples for wpa_supplicant and
could really need some help. I know ath9k supports TDLS, but my card
is ath9k_htc so I'm not sure whether that will work?


Any other hints are appreciated as well!

As I was mainly working with Bluetooth in the past, I found "hcidump"
to be very supportive in this regard. However, wifi doesn't support an
HCI-like layer so I was wondering whether there are any debug filters
that show me all events that go to and come from the wifi-card? For
all upper layers I guess tools like wireshark are used?
Again, any recommendations are welcome!

And if that whole thing is a dead end, I will be trying to get
WifiDisplay to work in general on linux (probably integrated with
gstreamer). So if someone else is already working on this for linux,
I'd be very interested in this work. And I'd be interested in doing
this as linux-foundation GSoC project.


Thanks!
David


[1]:
Cell 02 - Address: 34:AF:2C:5F:A6:1C
                    Channel:36
                    Frequency:5.18 GHz (Channel 36)
                    Quality=61/70  Signal level=-49 dBm
                    Encryption key:off
                    ESSID:"WiiU34af2c5fa6134af2c5fa61c_STA1"
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=0000000001f5a69a
                    Extra: Last beacon: 3276ms ago
                    IE: Unknown:
00205769695533346166326335666136313334616632633566613631635F53544131
                    IE: Unknown: 01088C129824B048606C
                    IE: Unknown:
2D1A1C0019FFFF000000000000000000000000000000000000000000
                    IE: Unknown:
3D1624080000000000000000000000000000000000000000
                    IE: Unknown: DD05A4C0E1F500
                    IE: Unknown:
DD7EA4C0E1F4104A00011010440001021041000101101200020000105300020084103B00010310470010222102030405060708090A0B0C0D0E0F1021000842726F6164636F6D10230006536F6674415010240001301042000130105400080006A4C0E1F400011011001057696955333461663263356661363163100800020084
                    IE: Unknown: DD09001018020000040000
                    IE: Unknown:
DD180050F20201018E0002542F0027A4000043545E0063542F00

[2]:
Cell 02 Address: 34:AF:2C:5F:A6:1C
                    Channel:36
                    Frequency:5.18 GHz (Channel 36)
                    Quality=70/70  Signal level=$minus 40 dBm
                    Encryption key:on
                    ESSID:""
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=000000001d8f305d
                    Extra: Last beacon: 3300ms ago
                    IE: Unknown: 001000000000000000000000000000000000
                    IE: Unknown: 01088C129824B048606C
                    IE: Unknown: 050402030000
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : Proprietary
                        Pairwise Ciphers (1) : Proprietary
                        Authentication Suites (1) : Proprietary
                    IE: Unknown:
2D1A1C0019FFFF000000000000000000000000000000000000000000
                    IE: Unknown:
3D1624080400000000000000000000000000000000000000
                    IE: Unknown: DD0800904C0700455517
                    IE: Unknown: DD09001018020100040000
                    IE: Unknown:
DD180050F20201018E0002542F0027A4000043545E0063542F0
