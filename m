Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:53865 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751211Ab2GHQyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 12:54:05 -0400
Message-ID: <1341766445.20243.72.camel@hp-dhlii> (sfid-20120708_185443_714088_DFF9761B)
Subject: Re: CARL9170 driver/firmware questions
From: "David Lynch Jr." <ml@dlasys.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Date: Sun, 08 Jul 2012 12:54:05 -0400
In-Reply-To: <201207081443.03106.chunkeey@googlemail.com>
References: <CADdUxCwt35GQU2j-a4AvvJVS=h93sgBqg09CZNxTivRfbYsqzg@mail.gmail.com>
	 <201206172048.59657.chunkeey@googlemail.com>
	 <1341734893.20243.15.camel@hp-dhlii>
	 <201207081443.03106.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am moving this back to the list so everyone can benefit. 

I set both the sending and receiving AR9170 to monitor mode using 
airmon-ng start wlan3

I set the sending device to channel 40 5200Mhz
iw wlan3 set channel 40


I run 
airomon-ng --channel 40 mon0
on the receiver. 
and I am able to send and receive a packet using a RadioTap raw sockets
test program I found on the web

I separately instrumented carl9170.ko so that I could observe bot the
calls and the register IO's to initialize the AR9170 and set the
frequency. 

After that worked, I sent a custom command to the AR9170 Firmware that
called a routine similar to  void wlan_wol_connection_monitor(void)
 and void wlan_send_buffered_ba(void), in this routing I set the
ieee80211_hdr addresses 1-3 to all 0xff's as my experience with ethernet
sugested that should always work if you do not need a reply back.
i also implimented a callback function for wlan_tx_fw() in the hope that
it would report any errors.

Anyway I got no errors, but did not receive a packet. 
So i added debugging code to dump the various things in wlan_tx(), 
so that I could trap both the packets that were being sent and those
that were not to see what was different. 

When I set addr2 & addr3 to  0x00, 0x12, 0x34, 0x56, 0x78, 0x9a 
wlan_tx_fw() started actually transmitting packets. 
  
My observations regarding carlu where just in passing. 
I am not using carlu, though I might have had I started with it.
Being able to bypass the entire linux network stack and talk to the
firmware directly, would be very useful for the projects i seem to get.
I have essentially implemented a variation on carlu, using debugfs
inside the carl9170 driver.  







On Sun, 2012-07-08 at 14:43 +0200, Christian Lamparter wrote:
> On Sunday 08 July 2012 10:08:13 David Lynch Jr. wrote:
> > I worked out the wlan_tx_fw() problem. 
> > It had to do with mac address values. 
> > Either the code or the radio was silently
> > rejecting packets with all addresses as 0xff.
> 
> AFAICT, the fw doesn't care much about any MAC
> addresses. Do you sent your generated frame 
> with a device that is in pure monitor mode as
> well?
> 
> > As an aside I have also tried some stuff with carlu. 
> > And i do not seem to be getting any packets from 
> > carlu -t either
> carlu -t does a loopback test to test if the usb code
> in the firmware is doing its job. Sadly, there is not
> any support for MAC or PHY code, but the program is
> written in C and the kernel driver is also C and the
> license is the same.
> 
> Regards,
> 	Chr


