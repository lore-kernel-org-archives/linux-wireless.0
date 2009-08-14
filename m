Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18524 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbZHNGRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 02:17:23 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 23:17:25 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19077.390.561670.919782@gargle.gargle.HOWL>
Date: Fri, 14 Aug 2009 11:47:42 +0530
To: Pavel Roskin <proski@gnu.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Revert commit in ath9k
In-Reply-To: <20090814020913.0h159bvuo0sccwcg-cebfxv@webmail.spamcop.net>
References: <19076.56592.101907.186453@gargle.gargle.HOWL>
	<20090814020913.0h159bvuo0sccwcg-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Quoting Sujith <Sujith.Manoharan@atheros.com>:
> 
> > John,
> >
> > Can you revert the commit - "ath9k: Change DEBUG level for certain
> > interrupts" ?
> > This interrupt seems to trigger fairly often and floods the log.
> 
> I think it would be better to revert only the part for the actually
> triggered AR_INTR_SYNC_LOCAL_TIMEOUT.  This way we'll learn of other
> unexpected interrupts if they happen for some users.

Well, the other interrupts are handled appropriately (marked as FATAL).
And the ISR does a chip reset for all interrupts marked as FATAL.
SYNC_LOCAL_TIMEOUT was the one I was really interested in, since I saw it
occurring in my machine - and was curious about its occurrence elsewhere.
Apparently, it is widespread. :)

Sujith
