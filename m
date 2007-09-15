Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:39373 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbXIOVBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 17:01:09 -0400
Message-ID: <46EC4844.1060003@lwfinger.net>
Date: Sat, 15 Sep 2007 16:01:56 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix machine check errors for PPC architecture  with BCM4306/2
References: <46ec18d6.puwbD1oRuPgUil6/%Larry.Finger@lwfinger.net> <200709152010.07647.mb@bu3sch.de> <46EC2E84.4080901@lwfinger.net> <200709152147.57431.mb@bu3sch.de>
In-Reply-To: <200709152147.57431.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> With your patch you remove the "gmode" semantics, so you could
> as well remove the whole variable and always assume it's set.
> But I don't recommend to go that way. I'd suggest you find the
> place in the code where phy->gmode is not set but it should be.
> _that_ is the place where the real bug is.
> 
> Just want to make sure you understand the consequences of your patch.
> You remove a feature with that.
> If that feature is really needed in legacy; that is another question.
> It's needed if you want to drive APHY devices.

All of the devices that b43legacy drives have either a BPHY or a GPHY. The current logic always sets
gmode and that feature is meaningless. Anyone overriding the rules that select this driver in order
to operate with an APHY device will hit a BUG_ON in wireless_core_attach.

I have generated and tested a patch that changes back to the old 'connected' variable. That will
avoid the semantics argument and match the V3 specs.

Larry


