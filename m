Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3B0XWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 18:22:54 -0500
Message-ID: <1362007368.8172.13.camel@jlt4.sipsolutions.net> (sfid-20130228_002258_317956_B6FB3E75)
Subject: Re: Interesting behaviour when AP enables/disables HT
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 28 Feb 2013 00:22:48 +0100
In-Reply-To: <512E92FD.2090106@candelatech.com> (sfid-20130228_001314_338433_42408E0E)
References: <512E92FD.2090106@candelatech.com>
	 (sfid-20130228_001314_338433_42408E0E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 15:13 -0800, Ben Greear wrote:
> I was doing some tests where I change the AP's configuration
> (enable/disable HT, enable/disable HT40, etc) on a somewhat
> hacked 3.7.9+ kernel.
> 
> One thing I noticed is that if stations are associated using /a,
> but I quickly reconfigure the AP to use /a/n mode (ie HT enabled),
> the stations stay in 'no-ht' mode.
> 
> If I down/up the stations, they come up in HT mode.

You probably didn't flush the scan cache on the stations before
reconnecting after the reconfiguration.

johannes

