Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:62194 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYHXLix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2008 07:38:53 -0400
Received: by wr-out-0506.google.com with SMTP id 69so919421wri.5
        for <linux-wireless@vger.kernel.org>; Sun, 24 Aug 2008 04:38:52 -0700 (PDT)
Message-ID: <99175ee40808240438o75c18f3ayd0c98db87a7c8561@mail.gmail.com> (sfid-20080824_133910_975965_9CA5DA54)
Date: Sun, 24 Aug 2008 19:38:51 +0800
From: Chris <dchris@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: intel 4965agn 54Mbps on Linux but 130Mbps on Windows
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using compat-wireless-2008-08-06.tar.bz2 on Ubuntu Hardy (kernel
2.6.24) for my intel 4965agn card in order to connect using 802.11n to
my router (TL-WR841N from TP-LINK).
Unfortunately, I'm only able to connect in 802.11g mode under Linux :
$ iwconfig wlan1
wlan1     IEEE 802.11abgn  ESSID:"chris"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1D:0F:33:7E:EC
          Bit Rate=54 Mb/s   Tx-Power=15 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Power Management:off
          Link Quality=100/100  Signal level:-30 dBm  Noise level=-95 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

$ sudo iwlist wlan1 scan
wlan1     Scan completed :
          Cell 01 - Address: 00:1D:0F:33:7E:EC
                    ESSID:"chris"
                    Mode:Master
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=100/100  Signal level:-30 dBm  Noise level=-94 dBm
                    Encryption key:on
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown:
2D1A4C1003FFFF000000000000000000000000000000000000000000
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Extra:tsf=000000003aefe580
                    Extra: Last beacon: 12ms ago

As you can see, no bit rate greater than 54Mbps is detected. I tried
under Windows with latest intel driver and it connects at 130Mbps.
Does the Linux driver support 802.11n? If so, do you have any
suggestion to make this work here? I will be happy to provide any
information you may require.

In dmesg output, I simply get this:
[   95.465080] wlan1: authenticate with AP 00:1d:0f:33:7e:ec
[   95.467416] wlan1: authenticated
[   95.467421] wlan1: associate with AP 00:1d:0f:33:7e:ec
[   95.471491] wlan1: RX AssocResp from 00:1d:0f:33:7e:ec (capab=0x431
status=0 aid=1)
[   95.471496] wlan1: associated
[   95.471533] wlan1 (WE) : Wireless Event too big (314)

Best regards,
Chris.
