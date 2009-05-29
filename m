Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:50759 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZE2VPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 17:15:10 -0400
Message-ID: <4A20505D.40908@lwfinger.net>
Date: Fri, 29 May 2009 16:15:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Matthieu CASTET <castet.matthieu@free.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 vs b43legacy
References: <loom.20090529T190620-42@post.gmane.org>
In-Reply-To: <loom.20090529T190620-42@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthieu CASTET wrote:
>
> what's the difference between b43 and b43legacy ?
> 
>>From a first point a view, it seems b43 is for core >= 5 and b43legacy for the
> other.
> There is also firmware difference : b43 need v4 and b43legacy need v3.

The firmware difference is the primary one.

> But v4 firmware seems to support core 4 (pcm4 & ucode4) and b43 code got some
> support for old chips (<5).

The Broadcom V4 drivers do have core 4 firmware embedded in them and it is
extracted by b43-fwcutter; however, b43 will _NOT_ work with core 4 chips. The
firmware loader will only find firmware for core 5 and later. On the other hand,
core 5 devices have been tested with b43legacy. I have a local patch that I use
to switch my 14e4:4312 device so that it uses b43legacy. This allows me to test
any changes.

> Is the split was made because nobody know how to use firmware v4 with core 4 or
> because core 4 it so different from newer core.
> In the latter case why code for older chip (<5) is not removed from the driver ?

>From what I have heard, the older chips do not have the on-board memory to run
V4 firmware. Certainly, any chips that have core 2 cannot handle V4 firmware.

I suspect that any residual code for older chips left in b43 was missed. If you
want to prepare patches to remove such code, please do.

Larry
