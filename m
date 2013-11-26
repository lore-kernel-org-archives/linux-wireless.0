Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:60052 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab3KZUi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 15:38:59 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so2779299bkb.6
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 12:38:57 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: p2p@posteo.de
Cc: Linux wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8188S
Date: Tue, 26 Nov 2013 21:38:46 +0100
Message-ID: <1783016.HDzIMuL15q@blech> (sfid-20131126_213904_088506_89085A41)
In-Reply-To: <67b4a51871c98531c68306862402baf4@posteo.de>
References: <a3a1cb41444ae8dd89db830ae927491f@posteo.de> <2035998.63y5xTAJxx@blech> <67b4a51871c98531c68306862402baf4@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Ms./Mr. ...?

On Tuesday, November 26, 2013 05:47:48 PM p2p@posteo.de wrote:
> Am 25.11.2013 22:57 schrieb Christian Lamparter:
> > On Monday, November 25, 2013 06:57:32 PM p2p@posteo.de wrote:
> >> I have a WLAN dongle with Realtek RTL8188S chip.
> >> I don't want to use r8712u driver with wext interface
> >> because I want to establish a wifi direct p2p connection.
> >
> > AFICT, you should be able to connect to a p2p-go peer
> > even if your device (in this case rtl8188s) only supports
> > station mode...
> >
> How do I do this?
"station mode"!

The theory is: the p2p group owner (go) peer behaves pretty much
like an Access Point. Hence, legacy devices  like the rtl81yySx
can connect to it the same way like they would connect to an
accesspoint or router. 

No "magic" driver or anything is needed. If you can connect to a
run-of-the-mill protected AP, you can connect to a running wifi-direct
network.
 
> >> Unfortunately the original Realtek driver from hp didn't
> >> work with p2p too.
> > Why, what happens in this case?
> >
> 
> I have downloaded the driver from:
> http://www.realtek.com/downloads/downloadsView.aspx?Langid=1&PNid=48&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true#RTL8188SU

this would also have worked with r8712u or r92su.
 
> Installed and loaded the module 8712u.
> 
> "iw list" doesn't list p2p-client or p2p-go.

"station mode" "station mode" and again "station mode".

"station mode" != "p2p-go" or "p2p-client". Just fire up your peer
device and let the driver connect (either via WPA2-PSK or WPS). You
don't need to deal with the console at all, this all can be done 
with the push of a GUI button (NetworkManager, wicd, ...). 

Remember: Do it like you simply want to connect to your AP.
(no p2p magic!)
 
> >> I thought RTL8192cu will work, but Larry F. told me it doesn't.
> > OK? (care to explain?)
> >
> >> He said there is a new driver in development.
> > Sort of. There's r92su, however this driver only supports what the
> > firmware is able to do (station, ad-hoc and a limited monitor mode).
> >
> >> I'm searching for information. Please can someone tell me about
> >> the project, its status, and if someone can take part.
> > Hey that's good to hear. The future of "r92su" was discussed in [0],
> > [1], ... The good news is:
> >
> 
> I followed the thread.
> It shows me that it makes no sense. I am a beginner and I only can 
> spent time for it if someone tells me for example: fill this module with 
> code for this specific function. I have good literature and I think I 
> can try to help but not lead something.

Hey that's great, that's exactly what needs to be "done". ;-)

Larry has already written a framework for realtek wifi devices. The rtl8192su
device can make use of this. You just need to lift the "firmware parser", 
"device initialization" from the other vendor driver at: [0]. And wire it into
the Larry's rtlwifi framework. 

You don't need to start from scratch either. In the git-tree of r92su, there 
is already an directory with an old rtl8192su driver [it also uses the r92su
firmware and not the one from the driver in [0], so needs to be considered].
But definitely not like the material isn't there. It just hasn't been put
together. Also, you can look at rtl8192cu and rtl8192se if you need some
guidance with rtlwifi. They should provide enough ideas to get a working
driver.

Regards,

Christian

[0] <www.edimax.com/images/Image/OpenSourceCode/Wireless/Router/AR-7284WnA/AR-7284WnA&B_SDK_6222.tar.zip>
    (See the post in the ML thread, it lists the directory of the driver and
     firmware components)
