Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60983 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbbIWLV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 07:21:56 -0400
Message-ID: <1443007312.1889.8.camel@sipsolutions.net> (sfid-20150923_132159_055199_A21EF661)
Subject: Re: Low latency communication over wifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Date: Wed, 23 Sep 2015 13:21:52 +0200
In-Reply-To: <20150923110343.GA19160@amd> (sfid-20150923_130348_584090_91456CD1)
References: <20150923110343.GA19160@amd>
	 (sfid-20150923_130348_584090_91456CD1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-23 at 13:03 +0200, Pavel Machek wrote:
> Hi!
> 
> I'm trying to transfer some audio data over wifi. Latency constrains
> are such that if it would took more than 20msec to wait for
> transmission, the packet should be dropped instead, and new one 
> should be transmitted.

This is typically not supported, at least not by the drivers right now.
Some hardware might support it, not sure.

>   	  qi->tqi_cw_min = ath5k_cw_validate(0);
>           qi->tqi_cw_max = ath5k_cw_validate(20);
> 
> ...but I don't think it did what I wanted. What am I missing?

That just changes the content window settings, which changes the
probability of getting medium access.

> (I could use Intel 3945ABG-based card instead, but I figured out 
> ath5k might be easier to hack?)
> 
> Is there way to manipulate type of service from userland to get
> similar behaviour without patching kernel?

If your AP has WMM/QoS then you can use setsockopt(SO_PRIORITY) to
change the TID and thus the AC and get your packets classified as voice
(VO) on wifi, which makes them much more likely to get access to the
medium.

johannes
