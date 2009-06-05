Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:41437 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZFEVUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 17:20:55 -0400
Message-ID: <4A298C37.9030503@lwfinger.net>
Date: Fri, 05 Jun 2009 16:20:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net> <200906052101.47168.mb@bu3sch.de>
In-Reply-To: <200906052101.47168.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> This is pretty silly behavior IMO. Just to bring it to the point:
> We initialize a huge wireless MAC, PHY and Radio that consume several watts of power
> just to poll a silly RF-kill bit.

That is what the driver already does.

> We can't we just accept that the RF-kill status is unknown while the device is down?

The problem is that while the interface is down the switch status
cannot be interrogated. If you try, you get a fatal SSB error. Thus
the only way to bring it back up is to flip the switch, then
rmmod/insmod the driver. If you want hardware rfkill to be one-way,
then take Johannes's patch. We would save a little power by calling
b43_wireless_exit() if we brought it up to test the switch, and the
switch was still off. That would leave everything off most of the time.

> I really do hate all that rfkill crap and I'm still refusing to sign off on anything that's
> related to rfkill (like I did for the past year or so). If people want this merged,
> somebody else maintain and sign it off, please.

I'm sick of rfkill as well and really detest the endless discussions
that have taken place; however, I do want the stuff to work.

As I see it, we have several options (presented in my order of
preference):

1. We switch to the cfg80211 rfkill and use this patch modified to
turn the interface back off if the switch is still off.

2. We continue to use the old rfkill mechanism. It works just fine,
but this method runs the risk of the old method being deprecated and
eliminated.

3. We get new callbacks that will only power down/up the radio when it
is blocked. That saves a little power.

Larry

