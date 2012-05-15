Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57358 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab2EOPEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 11:04:15 -0400
Received: by eaak11 with SMTP id k11so835229eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 08:04:13 -0700 (PDT)
Date: Tue, 15 May 2012 17:04:05 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce : freeze after connecting to network with FW Power
 Save on
Message-ID: <20120515170405.7f6510f2@destiny.ordissimo> (sfid-20120515_170419_283725_7E5BA4BD)
In-Reply-To: <4FB26D6B.2030005@lwfinger.net>
References: <20120515152951.7cc4f84b@destiny.ordissimo>
	<4FB26D6B.2030005@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 May 2012 09:51:23 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :

> On 05/15/2012 08:29 AM, Anisse Astier wrote:
> > Hi,
> >
> > With the rtl8192ce driver, I get freezes a few seconds after connecting
> > to a network. (see PCI id below) Machine is unusable after hang. I'm
> > using the linville/wireless-next git tree.
> >
> > I've been playing with the different options, and noticed that setting
> > fwlps=0 fixes the issue.
> >
> > I've tried to get more messages with netconsole, but once the lockup
> > happens I'm unable to get any debug message (regardless of the log level
> > of the driver).
> >
> > Regards,
> >
> > Anisse
> >
> >
> > 06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
> > 	Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8212]
> > 	Flags: bus master, fast devsel, latency 0, IRQ 17
> > 	I/O ports at 3000 [size=256]
> > 	Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
> > 	Capabilities: [40] Power Management version 3
> > 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> > 	Capabilities: [70] Express Endpoint, MSI 00
> > 	Capabilities: [100] Advanced Error Reporting
> > 	Capabilities: [140] Virtual Channel
> > 	Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
> > 	Kernel driver in use: rtl8192ce
> 
> I have been doing long-term tests with that same card for about one week with no 
> dropouts and no freezes. I am running wireless-testing, not wireless-next; 
> however, I have all the rtlwifi and friends patches applied. I think it is safe 

I'll try wireless-testing then. Are all rtlwifi patches in
wireless-testing ?

(This problem was also reproduced with 3.2.X)


> to say that I cannot duplicate your results, and that we need to explore the 
> rest of your system to see what is different.
> 
> Is your system 32- or 64-bit? How many cores in your CPU? Have you tried 
32 bits, SoC is an AMD E1-1200, with 2 cores.

> connecting to more than one AP? What is the make and model of the AP that needs 
I've tried two different APs, with and without keys (open and WPA2)

> to have power save turned off? What is the mode of operation?
One is a Linksys WRT54GL with dd-wrt(WPA2), the other(Open) is a
carrier's set top box/router (Freebox).

> 
> I am using a 64-bit system with a dual-core CPU. My main AP is a Netgear 
> WNDR3300 running standard firmware and is encrypted using WPA2-TKIP (AES). The 
> mode is 802.11n at up to 270 Mbps; however, I have also tested using a Linksys 
> WRT54GL running openWRT Kamakaze firmware. That one is 802.11g at up to 54 Mbps.
> 
> Larry

Anisse
