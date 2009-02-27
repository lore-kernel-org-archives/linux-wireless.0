Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43509 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZB0QQl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 11:16:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [PATCH v2] mac80211: Call commit() on channel setting
Date: Fri, 27 Feb 2009 17:14:54 +0100
Cc: linux-wireless@vger.kernel.org
References: <20090226234307.51520@gmx.net> <200902271503.13308.mb@bu3sch.de> <20090227153418.254900@gmx.net>
In-Reply-To: <20090227153418.254900@gmx.net>
MIME-Version: 1.0
Message-Id: <200902271714.54181.mb@bu3sch.de> (sfid-20090227_171644_873701_B369FD51)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 February 2009 16:34:18 Alina Friedrichsen wrote:
> > Could you explain what commit is supposed to to after the channel switch?
> > To me it's not clear what the difference in functionality is.
> > What do you expect to happen on the commit call after the channel change.
> 
> I think after all changes which affect the selected network a rejoin should be done.
> 
> For example you have at channel 4 a AP with the SSID "test" und at channel 11 an other AP with the same SSID, too.
> 
> If you now first say set_ssid("test") and then set_channel(11), we first join the network at channel 4 and then we switch the hardware low-level to channel 11. So we hang now in channel 4 with the BSSID of the network in channel 4 and nothing works anymore.

I think this is desired behavior. We voluntarily associated with the "test" AP on channel 4.
Who says that we want to assoc to the "test" ssid on channel 11? This is a policy decision and such policy
doesn't belong into the kernel. Userspace can initiate a reassociation after the channel change,
if the AP switch is desired.
There are good reasons to leave roaming decisions in userspace, because these decisions are simply very
complex and would put lots of policy into the kernel or require lots of kernel API.

> I think the order of the commands should not affect the result on the end and the driver should never hang in an broken/undefined state if it can be recovered.

-- 
Greetings, Michael.
