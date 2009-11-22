Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48763 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZKVSLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 13:11:48 -0500
Received: by gxk26 with SMTP id 26so4259415gxk.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2009 10:11:55 -0800 (PST)
Message-ID: <4B097EE8.10902@lwfinger.net>
Date: Sun, 22 Nov 2009 12:11:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
References: <200911192224.29491.mb@bu3sch.de> <200911221852.19143.mb@bu3sch.de>
In-Reply-To: <200911221852.19143.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2009 11:52 AM, Michael Buesch wrote:
> On Thursday 19 November 2009 22:24:29 Michael Buesch wrote:
>> This rewrites the error handling policies in the TX status handler.
>> It tries to be error-tolerant as in "try hard to not crash the machine".
>> It won't recover from errors (that are bugs in the firmware or driver),
>> because that's impossible. However, it will return a more or less useful
>> error message and bail out. It also tries hard to use rate-limited messages
>> to not flood the syslog in case of a failure.
>>
>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> So did somebody try this with opensource firmware, yet?

I'm testing now. So far, it has survived about 18 hours running tcpperf in one
console, and a flood ping in another. It looks really good, but I want at least
24 hours before committing.

Larry
