Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:38546 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219AbZFANL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 09:11:58 -0400
Received: by bwz22 with SMTP id 22so7456629bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 06:11:59 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org,
	Jason Andryuk <jandryuk@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	karllinuxtest.relton@ntlworld.com
Subject: Re: [PATCH] at76c50x-usb: avoid mutex deadlock in at76_dwork_hw_scan
References: <20090528004925.d6d9be31.akpm@linux-foundation.org>
	<1243503926-5094-1-git-send-email-linville@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 01 Jun 2009 16:11:54 +0300
In-Reply-To: <1243503926-5094-1-git-send-email-linville@tuxdriver.com> (John W. Linville's message of "Thu\, 28 May 2009 11\:45\:26 +0200")
Message-ID: <87ws7wt7xh.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> http://bugzilla.kernel.org/show_bug.cgi?id=13312
>
> at76_dwork_hw_scan holds a mutex while calling ieee80211_scan_completed,
> which then calls at76_config which needs the same mutex.  This reworks
> the ordering to not hold the lock while calling ieee80211_scan_completed.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks.

Acked-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
