Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr3.hinet.net ([168.95.4.103]:34608 "EHLO msr3.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1GRI3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 04:29:50 -0400
Date: Mon, 18 Jul 2011 16:27:09 +0800
From: Ali Bahar <ali@internetdog.org>
To: Stefan Assmann <sassmann@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
Message-ID: <20110718082709.GA8390@internetdog.org> (sfid-20110718_102954_232368_E68244B5)
Reply-To: ali@internetdog.org
References: <4E2051F3.20103@redhat.com>
 <4E205984.5040803@lwfinger.net>
 <4E23E56C.9000202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E23E56C.9000202@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan,

I'd like to reproduce this problem. So I'd appreciate some specifics,
as asked below.


On Mon, Jul 18, 2011 at 09:49:00AM +0200, Stefan Assmann wrote:
> On 15.07.2011 17:15, Larry Finger wrote:
> > On 07/15/2011 09:42 AM, Stefan Assmann wrote:

> >> driver. The problem I'm currently facing is that the driver does not
> >> recognize any network disconnects. So whenever the network goes down the
> >> driver will still report it's connected and thus doesn't reconnect when
> >> the network is up again.


> The system is a headless debian squeeze with a self build vanilla 2.6.39
> kernel. The network is handled by debian scripts I just added the following
> to /etc/network/interfaces:
> auto wlan0
> iface wlan0 inet dhcp
> wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
> 
> No NM involved.

So wpa_supplicant is controlling (and presumably monitoring) the
connection.
How are you seeing that (to quote the above) "the network goes down"
and that the driver reports that "it's connected"? 
(Typically, I use only ifconfig and iwconfig, but those don't monitor
the connection.)


 
> > When this situation occurs, what is output to the dmesg log?
> 
> Sorry, I don't have the output at hand but IIRC basically nothing special
> occurred in dmesg. The interface even keeps it's IP although the wireless
> was long gone.

So ifconfig shows the IP#. I'm assuming that it no longer shows a
state of "UP".
This'd seem an inane question, but I must ask: What exactly do you
mean by the wireless being "gone"? Which GUI/utility/effect do you
see? Is it a powered-down AP, roaming, iwconfig's output, or what?


 

> Ccing Ali Bahar to this reply, since he has seen something similar.

To clarify: I just meant that I've seen quite a number of similar
inconsistencies in my testing as well as in my analysis of the code.
So, when I read your post, it came as no surprise to me. These'll get
fixed ... uh, let's hope soon! ;-)

