Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48347 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZHIKS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 06:18:26 -0400
Received: by bwz19 with SMTP id 19so2130806bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2009 03:18:26 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: add missing device list locking
References: <1249811489.4636.2.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 09 Aug 2009 13:18:23 +0300
In-Reply-To: <1249811489.4636.2.camel@johannes.local> (Johannes Berg's message of "Sun\, 09 Aug 2009 11\:51\:29 +0200")
Message-ID: <87iqgxl28g.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> When calling into the wext code from the NETDEV_UP
> notifier, we need to hold the devlist_mtx mutex as
> the wext code ends up calling into channel checks.
>
> Reported-by: Kalle Valo <kalle.valo@iki.fi>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for fixing this. I wasn't able to reproduce the warning after one
suspend/resume cycle, but I'll test this patch a bit more before I send
my Tested-by tag.

-- 
Kalle Valo
