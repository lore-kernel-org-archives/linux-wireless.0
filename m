Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33802 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbZDPKzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:55:13 -0400
Received: by fxm2 with SMTP id 2so335215fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 03:55:10 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3 v2] mac80211: improve powersave implementation
References: <20090415171046.336006351@sipsolutions.net>
	<20090415171633.290542228@sipsolutions.net>
	<1239824326.29769.4.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 13:55:08 +0300
In-Reply-To: <1239824326.29769.4.camel@johannes.local> (Johannes Berg's message of "Wed\, 15 Apr 2009 21\:38\:46 +0200")
Message-ID: <87r5zs98c3.fsf@litku.valot.fi> (sfid-20090416_125517_719694_ED2F4288)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> When you have multiple virtual interfaces the current
> implementation requires setting them up properly from
> userspace, which is undesirable when we want to default
> to power save mode. Keep track of powersave requested
> from userspace per managed mode interface, and only
> enable powersave globally when exactly one managed mode
> interface is active and has powersave turned on.
>
> Second, only start the dynPS timer when PS is turned
> on, and properly turn it off when PS is turned off.
>
> Third, fix the scan_sdata abuse in the dynps code.
>
> Finally, also reorder the code and refactor the code
> that enables PS or the dynps timer instead of having
> it copied in two places.

The code is a lot cleaner now, thanks for doing this.

Unfortunately I don't have time to do proper review or testing right
now, but after a quick look this looks good.

-- 
Kalle Valo
