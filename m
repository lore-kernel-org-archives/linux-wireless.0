Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:34424 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZGWPBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 11:01:53 -0400
Message-ID: <4A687B85.3070309@lwfinger.net>
Date: Thu, 23 Jul 2009 10:02:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Helen Gray <helen.r.gray@gmail.com>
CC: networkmanager-list@gnome.org,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: howto ignore rfkill switch
References: <22f678c60907181747h26bcd4edyae5cc16627c35bdd@mail.gmail.com>
In-Reply-To: <22f678c60907181747h26bcd4edyae5cc16627c35bdd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helen Gray wrote:
> Hi,
> 
> I have a laptop with a dodgy rfkill switch. It switches on and off
> randomly when touch the laptop panel above it. To avoid the problem,
> I've installed a PCMCIA card but network manager shut it down when the
> switch goes off.
> 
> Is there a way to ask network manager to ignore the rfkill switch?

What driver is used by the internal card? On my system, I have an
internal BCM4311 that uses b43, and I also use several USB cards for
testing. Before the latest rewrite of rfkill, I was able to switch off
the BCM4311 without affecting the USB sticks. Now I have to unload
b43, otherwise all radios are killed. Once b43 is unloaded, the
position of the rfkill switch is irrelevant.

If you do not wish to use the internal device at all, you should
blacklist that driver.

Larry
