Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr9.hinet.net ([168.95.4.109]:53947 "EHLO msr9.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab1GPPSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:18:44 -0400
Date: Sat, 16 Jul 2011 23:15:53 +0800
From: Ali Bahar <ali@internetdog.org>
To: Stefan Assmann <sassmann@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
Message-ID: <20110716151553.GA3598@internetdog.org> (sfid-20110716_171848_215159_B932285D)
Reply-To: ali@internetdog.org
References: <4E2051F3.20103@redhat.com>
 <4E205984.5040803@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E205984.5040803@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stefan,


On Fri, Jul 15, 2011 at 10:15:16AM -0500, Larry Finger wrote:
> On 07/15/2011 09:42 AM, Stefan Assmann wrote:
> >Hi Larry,
> >
> >I'm wondering if you're looking into any issues concerning the
> >driver. The problem I'm currently facing is that the driver does not
> >recognize any network disconnects. So whenever the network goes down the
> >driver will still report it's connected and thus doesn't reconnect when
> >the network is up again.

I have seen some behaviour in my testing that is not dissimilar to
this. But I was going to tackle this in a week or two. This code's
state-tracking needs some more work, IIRC.



> >
> >Btw I'm using a 0bda:8172 usb adapter with 2.6.39.
> >Thanks for your help!
> 
> I need more details. What distro? How are you controlling the
> network? If NetworkManager, what version?
> 
> When this situation occurs, what is output to the dmesg log?
> 
> I do not see this situation on my system/device. Whenever the
> connection is dropped, NM reconnects.
> 
> There are a recent patches that might have an effect. Can you build your own kernel?

Larry,
the state flags (bup and bDriverStopped) are playing a role here, of
course. IIRC bDriverStopped still has some clean-up outstanding. I'll
look into my logs.

regards,
ali
