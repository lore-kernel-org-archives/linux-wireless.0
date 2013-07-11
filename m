Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54720 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab3GKN7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 09:59:53 -0400
Message-ID: <1373551187.8385.44.camel@cumari.coelho.fi> (sfid-20130711_155956_004524_85D7B64E)
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
From: Luciano Coelho <coelho@ti.com>
To: =?ISO-8859-1?Q?Jos=E9?= Miguel =?ISO-8859-1?Q?Gon=E7alves?=
	<jose.goncalves@inov.pt>
CC: Arik Nemtsov <arik@wizery.com>, <linux-wireless@vger.kernel.org>
Date: Thu, 11 Jul 2013 16:59:47 +0300
In-Reply-To: <51DEB436.9000300@inov.pt>
References: <51DB0ACC.7050800@inov.pt>
	     <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
	     <51DB4195.8090103@inov.pt>
	     <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>
	     <1373360959.21065.183.camel@cumari.coelho.fi>
	 <51DBD904.6020007@inov.pt>
	     <1373362817.21065.191.camel@cumari.coelho.fi>
	 <51DBF389.5060209@inov.pt>
	     <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>
	     <51DC0E7C.9080306@inov.pt>
	     <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com>
	     <51DCA3EF.8090900@inov.pt> <1373448177.8385.22.camel@cumari.coelho.fi>
	    <51DD54D4.6090502@inov.pt> <51DD8C20.7010900@inov.pt>
	   <1373476663.8385.28.camel@cumari.coelho.fi> <51DD9E6C.5060008@inov.pt>
	  <1373488063.8385.31.camel@cumari.coelho.fi> <51DEA05A.5020401@inov.pt>
	 <1373549359.8385.36.camel@cumari.coelho.fi> <51DEB436.9000300@inov.pt>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 14:33 +0100, José Miguel Gonçalves wrote:
> On 11-07-2013 14:29, Luciano Coelho wrote:
> > On Thu, 2013-07-11 at 13:08 +0100, José Miguel Gonçalves wrote:
> >>
> >> I've setup my Linuc PC as a sniffer and yes I see a lot of of authentication
> >> frames on the air when I try to associate with my open AP (Android phone).
> >>
> >> I've repeated the process with a TP-Link dongle and I see a clean 802.11
> >> association sequence.
> >>
> >> What I found strange is that I don't see "probe request" frames on the wl12xx
> >> captured frames, it starts directly with an "authentication" frame, when with the
> >> TP-Link dongle (ath9k_htc driver) the first frame sent by is a "probe request"!
> > Usually the connection will start with a probe request, but if there is
> > a response in the cache, we may skip it.  In any case, this is probably
> > happening because your sniffer is missing those frames (which again
> > points to problems with RF).
> >
> >
> >> I can provide the Wirehsark capture files. What is the best way to send them
> >> through the mailing list?
> > Cut only the portion that matters, so the file is small and gzip it.
> > Small files can be sent as attachments to the list.
> >
> 
> Here they go...

It seems that the wl1273 is not receiving the frames correctly.  What
happens in the first 3 frames is all normal, but we keep retransmitting
the auth frame as if the AP hadn't sent us an ACK.

1. wl1273 sends auth to the AP
2. the AP acks the frame
3. the AP sends an auth back to us
4. we should send an ACK and continue, but instead we retransmit
And from then on everything is screwed up.

You could try to use the calibrator's RX statistics commands to see if
you're getting lots of bad frames and such.

This could be a problem in the firmware, but my hunch is that it's RF.
What kind of antenna are you using?

BTW, you should set a proper MAC address in your NVS too (calibrator's
set_mac command).  You could first try to set it to 00:00:00:00:00:00,
which will check if the chip has a MAC in the Fuse ROM and use it from
there.  If that doesn't work, create your own and set it in the NVS.

The TP-Link log is "too clean", missing some frames, we don't see most
of the ACKs and we don't see the auth frame being sent back from the AP.

--
Luca.

