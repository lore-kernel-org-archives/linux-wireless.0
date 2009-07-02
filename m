Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:41731 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbZGBOVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 10:21:07 -0400
Message-ID: <4A4CC25D.4090400@lwfinger.net>
Date: Thu, 02 Jul 2009 09:21:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Fabio A. Correa" <facorread@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: 4311 not detected at all
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com>	 <4A326771.6030301@lwfinger.net>	 <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>	 <20090618021017.19879.qmail@stuge.se>	 <ec2083b20906171932g401fab8fk15531459e1dc4d41@mail.gmail.com> <ec2083b20907020617q689f9672h383bb853ba6019d0@mail.gmail.com>
In-Reply-To: <ec2083b20907020617q689f9672h383bb853ba6019d0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabio A. Correa wrote:
> Hello All,
> 
> I recompiled the Linux kernel with ssb, phy and b43 as modules. I made
> sure those modules were loaded after login, and now the b43 driver
> properly detects the card. It seems the phy driver is not needed.
> 
> Now I have the problem that the card does not scan, and it does not
> associate to any AP.

AFAIK, the phy driver is for wired devices. Have you installed the
firmware? Please look at the output of the command

dmesg | egrep "ssb|b43|wlan0"

The other kernel modules that are needed are mac80211 and friends;
however, the Kconfig rules should ensure that mac80211 is built before
you can actually build b43.

BTW, your mailer is misconfigured. the "To:" header field is wrong,
which prevents an automatic "reply to".
