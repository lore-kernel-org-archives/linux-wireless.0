Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:53195 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab0LLIqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 03:46:07 -0500
Subject: Re: [PATCH 2/2] ssb: Save sprom image for dump of device at
 alternate location
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net> (sfid-20101212_043513_712988_FFFFFFFF9320429C)
References: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net>
	 (sfid-20101212_043513_712988_FFFFFFFF9320429C)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 09:45:51 +0100
Message-ID: <1292143551.20015.24.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-12-11 at 21:35 -0600, Larry Finger wrote: 
> Some recent Broadcom devices in netbooks have an SPROM that is located
> at 0x0800, not the normal location of 0x1000. Initial reading of the
> SPROM has been solved in a previous commit; however, dumping to a console
> no longer works. This difficulty is fixed by saving the SPROM image
> from the initial read, and only freeing that memory at module unload.

Ah wait. Now I get what you were talking about.
Yes, those devices map the SPROM into the wireless core window.
So, yes, the wireless core has to be mapped for the readout to work,
of course. I don't know what other prerequisites have to be met to
read the data. Maybe IHR region has to be disabled.
I don't know how writing works on these devices.

-- 
Greetings Michael.

