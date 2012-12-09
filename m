Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab2LISYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 13:24:32 -0500
Message-ID: <1355077493.9878.0.camel@jlt4.sipsolutions.net> (sfid-20121209_192436_572441_F392233B)
Subject: Re: WLAN not working anymore after changing the MAC address
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>,
	brcm80211-dev-list@broadcom.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sun, 09 Dec 2012 19:24:53 +0100
In-Reply-To: <50C4CFDA.5020900@broadcom.com>
References: <201212090940.38269.maxi@daemonizer.de>
	 <50C4CFDA.5020900@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-12-09 at 18:52 +0100, Arend van Spriel wrote:

> > After changing the MAC address of my wireless network interface it
> > doesn't work anymore. I would very much like to change the MAC
> > address to avoid being traceable by it. Steps how this can be
> > reproduced are shown below. Here is first some information about my
> > Hardware and test setup:
> > 
> 
> How is this supposed to be distributed to the driver? I have been
> looking in the mac80211 interface. The only callback that I can think
> is is the change_interface() callback although the documentation does
> state this is only for changing the interface type. Or is it to be
> done upon add_interface()?

You should read the interface address in add_interface and basically
never use perm_addr. change_interface can't change it as it's only
called while an interface is up.

johannes

