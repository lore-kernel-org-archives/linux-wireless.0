Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52948 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbYLIBBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 20:01:42 -0500
Message-Id: <1228784501.31197.1288992887@webmail.messagingengine.com> (sfid-20081209_020148_555689_EBD81501)
From: "Dan E" <trg_info@mailhaven.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
 (sfid-20081208_002919_244971_30E436F9)
 <1228723993.22164.65.camel@johannes.berg>
 <1228778295.10662.1288975589@webmail.messagingengine.com>
 <1228778801.22164.156.camel@johannes.berg>
 <1228783416.25383.1288982771@webmail.messagingengine.com>
 <1228783903.22164.166.camel@johannes.berg>
Subject: Re: Userspace tools: Roadmap?
In-Reply-To: <1228783903.22164.166.camel@johannes.berg>
Date: Mon, 08 Dec 2008 20:01:41 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 09 Dec 2008 01:51:43 +0100, "Johannes Berg"
<johannes@sipsolutions.net> said:
> On Mon, 2008-12-08 at 19:43 -0500, Dan E wrote:
> 
> > When I reboot, modprobe the driver, and do 'iwconfig wlan0 channel 9
> > commit' the .config callback does run.  If I leave off the 'commit' it
> > does not.  
> 
> Strange. But .start also runs, right? Something must be turning up the
> interface.

Eh, no you are right.  It doesn't run.  iwconfig was giving me an error
message that I mistook for one of my callback printk debugging calls.  I
jumped to the wrong conclusion.

> > I'm trying to validate as many callbacks as I can before
> > moving on to the next step, enabling the interface.
> > 
> > An additional question, if I may... Is wlan0 considered a "virtual
> > interface" or does that term only apply to additional interfaces created
> > with iw?  The whole vif thing has me a little confused.
> 
> Yes, wlan0 is a virtual interface too, the first one.

So I should expect the callbacks (e.g. .add_interface and
.remove_interface) when wlan0 gets created?

I cannot thank you enough for your help here.  I'm finally starting to
feel like I can get beyond a few mental blocks I've had regarding the
underlying framework, and start concentrating on the real driver
workings.

--
Dan

-- 
http://www.fastmail.fm - I mean, what is it about a decent email service?

