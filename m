Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:33037 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZHQPbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 11:31:40 -0400
Received: by bwz22 with SMTP id 22so2380010bwz.18
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 08:31:39 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: Re: [PATCH v2] cfg80211: fix deadlock
References: <1250422358.17522.0.camel@johannes.local>
	<1250504737.15103.1.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 17 Aug 2009 18:31:33 +0300
In-Reply-To: <1250504737.15103.1.camel@johannes.local> (Johannes Berg's message of "Mon\, 17 Aug 2009 12\:25\:37 +0200")
Message-ID: <87vdkmtq22.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> When removing an interface with nl80211, cfg80211 will
> deadlock in the netdev notifier because we're already
> holding rdev->mtx and try to acquire it again to verify
> the scan has been done.
>
> This bug was introduced by my patch
> "cfg80211: check for and abort dangling scan requests".

[...]

> Reported-by: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I was bitten by the bug as well and this patch fixed it. Thanks.

Tested-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
