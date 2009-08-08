Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:52589 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933748AbZHHJlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 05:41:17 -0400
Received: by fxm28 with SMTP id 28so179627fxm.17
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 02:41:17 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: fix locking for SIWFREQ
References: <1249722238.31670.17.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 08 Aug 2009 12:41:14 +0300
In-Reply-To: <1249722238.31670.17.camel@johannes.local> (Johannes Berg's message of "Sat\, 08 Aug 2009 11\:03\:58 +0200")
Message-ID: <87zlaalk1x.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> "cfg80211: validate channel settings across interfaces"
> contained a locking bug -- in the managed-mode SIWFREQ
> call it would end up running into a lock recursion.
>
> This fixes it by not checking that particular interface
> for a channel that it needs to stay on, which is as it
> should be as that's the interface we're setting the
> channel for.

Thanks, this fixes the problem I reported.

> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Reported-by: Kalle Valo <kalle.valo@iki.fi>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
