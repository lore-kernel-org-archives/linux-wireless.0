Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:35869 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3GKRe5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 13:34:57 -0400
Message-ID: <51DEECAE.8080100@inov.pt> (sfid-20130711_193500_670425_29B541CD)
Date: Thu, 11 Jul 2013 18:34:38 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>      <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>      <51DB4195.8090103@inov.pt>      <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>      <1373360959.21065.183.camel@cumari.coelho.fi>  <51DBD904.6020007@inov.pt>      <1373362817.21065.191.camel@cumari.coelho.fi>  <51DBF389.5060209@inov.pt>      <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>      <51DC0E7C.9080306@inov.pt>      <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com>      <51DCA3EF.8090900@inov.pt> <1373448177.8385.22.camel@cumari.coelho.fi>     <51DD54D4.6090502@inov.pt> <51DD8C20.7010900@inov.pt>    <1373476663.8385.28.camel@cumari.coelho.fi> <51DD9E6C.5060008@inov.pt>   <1373488063.8385.31.camel@cumari.coelho.fi> <51DEA05A.5020401@inov.pt>  <1373549359.8385.36.camel@cumari.coelho.fi> <51DEB436.9000300@inov.pt> <1373551187.8385.44.camel@cumari.coelho.fi>
In-Reply-To: <1373551187.8385.44.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-07-2013 14:59, Luciano Coelho wrote:
> It seems that the wl1273 is not receiving the frames correctly.  What
> happens in the first 3 frames is all normal, but we keep retransmitting
> the auth frame as if the AP hadn't sent us an ACK.
>
> 1. wl1273 sends auth to the AP
> 2. the AP acks the frame
> 3. the AP sends an auth back to us
> 4. we should send an ACK and continue, but instead we retransmit
> And from then on everything is screwed up.
>
> You could try to use the calibrator's RX statistics commands to see if
> you're getting lots of bad frames and such.
>
> This could be a problem in the firmware, but my hunch is that it's RF.
> What kind of antenna are you using?

A standard omni-directional antenna with a 4dBi gain. After I've read your email I 
tried to change the antenna and immediately I got associated with the AP! But it 
was only from a brief period. After that I've made some more tests and I was not 
able to associate again. So it really seems that I've some kind of RF problem with 
my module :-( BTW, my module has dual-band and I've tested in both 2.4 GHz and 5 
GHz bands (with appropriate antennas), both without success.

>
> BTW, you should set a proper MAC address in your NVS too (calibrator's
> set_mac command).  You could first try to set it to 00:00:00:00:00:00,
> which will check if the chip has a MAC in the Fuse ROM and use it from
> there.  If that doesn't work, create your own and set it in the NVS.

I've already verified that the module doen not have a MAC built in. So I leaved 
the "DE:AD:BE:EF:00:00" MAC set, which is as good as another one (for tests), and 
a good reminder that I must add an EEPROM with a MAC address built in to my design.

>
> The TP-Link log is "too clean", missing some frames, we don't see most
> of the ACKs and we don't see the auth frame being sent back from the AP.
>
>

I've captured both files with display filter "wlan.addr == <MAC>". For instance, 
for the log with the wl1273 based module, I used "wlan.addr == DE:AD:BE:EF:00:00". 
It seemed to me the appropriate filter to extract all the traffic related with 
that station, don't you agree?

José Gonçalves
