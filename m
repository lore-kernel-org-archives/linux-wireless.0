Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54277 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0ALLOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 06:14:22 -0500
Received: by bwz27 with SMTP id 27so974792bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 03:14:21 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	a.young.jason@gmail.com
Subject: Re: [PATCH PATCH v6 1/7] mac80211: add U-APSD client support
References: <20100112084059.27492.86738.stgit@tikku>
	<20100112084231.27492.77457.stgit@tikku>
	<1263292276.3583.15.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 12 Jan 2010 13:14:18 +0200
In-Reply-To: <1263292276.3583.15.camel@johannes.local> (Johannes Berg's message of "Tue\, 12 Jan 2010 11\:31\:16 +0100")
Message-ID: <87hbqrtw1h.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2010-01-12 at 10:42 +0200, Kalle Valo wrote:
>
>> + *
>> + * @IEEE80211_HW_SUPPORTS_UAPSD:
>> + *	Hardware supports Unscheduled Automatic Power Save Delivery
>> + *	(U-APSD) in managed mode. The mode is configured with
>> + *	conf_tx() operation.
>
> I think a little more detail would be good here, for example adding that
> it must support staying awake with just the frame triggering it, and
> that it won't be asked to wake up by mac80211?

Good point. I was planning to improve power save documentation, I do
that in this patchset and I'll also add more documentation about
U-APSD. That should help to understand this more.

> Or will it, actually? We've had that discussion with PS-poll so ...

Yes, HW must stay awake until end of service period. I'll write more
documentation to clear up all this.

-- 
Kalle Valo
