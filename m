Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46238 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752573Ab1LUP0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 10:26:32 -0500
Received: by mail-lpp01m010-f42.google.com with SMTP id j5so3047370lag.15
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 07:26:31 -0800 (PST)
Subject: Re: [PATCH] atheros: force endian checks on atheros wireless
 drivers
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>, arik@wizery.com
In-Reply-To: <1324480449.3401.7.camel@jlt3.sipsolutions.net>
References: <1324408728-20300-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1324465840.2182.198.camel@cumari>
	 (sfid-20111221_121047_806730_87573FD9)  <1324480449.3401.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 17:26:28 +0200
Message-ID: <1324481188.2182.243.camel@cumari> (sfid-20111221_162636_668482_B85FAD92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-21 at 16:14 +0100, Johannes Berg wrote: 
> On Wed, 2011-12-21 at 13:10 +0200, Luciano Coelho wrote:
> 
> > >  ath-$(CONFIG_ATH_DEBUG) += debug.o
> > > +ccflags-y += -D__CHECK_ENDIAN__
> > 
> > Doesn't this force everyone who compiles the modules (even
> > non-developers) to have sparse installed? Is it really what we want?
> 
> No. It just forces everyone who does use sparse to also use it for
> endian checks. I do the same in all code I maintain, take a look :-)

Ah, I get it now.  sparse will only run if C=[12] is passed in the make
command.

I'll probably add the same in wl12xx.

It would be nice to have a way to enforce developers to run sparse.
Maybe public humiliation works, but it's not the most efficient way. :)

-- 
Cheers,
Luca.

