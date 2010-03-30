Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab0C3GDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 02:03:08 -0400
Subject: Re: Another AR5008 hang
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
References: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 08:03:06 +0200
Message-ID: <1269928986.3927.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 10:26 -0700, Ben Gamari wrote:
> New (2.6.33 and greater) kernels seem to result in a selective hang on my
> machine directly only seconds after association with an 802.11N access point
> (hosted with hostapd and another ar5008). I've included dmesg output for a
> failure event, including back traces of hung processes. What ath9k.debug flags
> would be most helpful for tracing this further?

None, I would think, this seems to be a lockup between
modprobe/stop_machine and some rtnl things, but I have no idea why that
would happen. Do you have lockdep enabled? And if you do, please disable
RCU lockdep as it typically gives you a warning and then turns off
lockdep...

johannes


