Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:58216 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbZI3Ord (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 10:47:33 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: NOHZ: local_softirq_pending 08
References: <200909111648.50902.mb@bu3sch.de>
	<20090929192928.GF2678@tuxdriver.com> <4AC3475C.7000403@hartkopp.net>
	<200909301633.04376.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 30 Sep 2009 17:47:32 +0300
In-Reply-To: <200909301633.04376.mb@bu3sch.de> (Michael Buesch's message of "Wed\, 30 Sep 2009 16\:33\:02 +0200")
Message-ID: <87ocosqykb.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

>> I don't know how expensive in_interrupt() is, but it IMO should be
>> avoided when the context for a code section can be determined in
>> another way.
>
> What if we just get the fix merged and discuss later whether it's
> worth to optimize a picosecond or not?? My patch fixes the _bug_.
> You can merge a more "efficient" fix later that saves one or two CPU
> cycles.

I agree with Michael. The bug is real and I have verified that
Michael's patch fixes the issue. Better to apply the patch now, it's
trivial to change the implementation if/when the network stack has
support for this.

-- 
Kalle Valo
