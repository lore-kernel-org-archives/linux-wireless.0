Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:44147 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab0LLQM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 11:12:27 -0500
Subject: Re: [PATCH 2/2] ssb: Save sprom image for dump of device at
 alternate location
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
In-Reply-To: <4D04F2AF.5080706@lwfinger.net> (sfid-20101212_170450_663695_3B8CD5F6)
References: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net>
	 (sfid-20101212_043513_712988_FFFFFFFF9320429C) <1292143551.20015.24.camel@maggie>
	 <4D04EB7D.1090009@lwfinger.net>
	 (sfid-20101212_103356_973639_7B7006EC) <1292168319.3572.6.camel@maggie>
	 <4D04F2AF.5080706@lwfinger.net> (sfid-20101212_170450_663695_3B8CD5F6)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 17:12:19 +0100
Message-ID: <1292170339.3572.11.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-12-12 at 10:05 -0600, Larry Finger wrote: 
> On 12/12/2010 09:38 AM, Michael Büsch wrote:
> > 
> > So, do we actually make sure the wireless core is mapped while reading
> > SPROM from offset 0x800? I guess not and it just works by accident,
> > because the core is still mapped from a previous operation.
> 
> I have core switching debug enabled on that box. When the SPROM is read, the
> ChipCommon core is mapped, and no other core has yet been selected.

Well, ok. Whatever core it is, it's coincidence that it is mapped.
I'd rather prefer an explicit mapping of the chipcommon before
the area is accessed. The chipcommon MMIO functions could probably
be used. That would be easiest. (16bit function does not exist, yet,
but is trivial to add).

-- 
Greetings Michael.

