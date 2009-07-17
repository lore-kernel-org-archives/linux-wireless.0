Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33724 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934391AbZGQKuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 06:50:20 -0400
Received: by fxm18 with SMTP id 18so650260fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 03:50:18 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] cfg80211: don't optimise wext calls too much
References: <1247737144.24433.11.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 17 Jul 2009 13:50:14 +0300
In-Reply-To: <1247737144.24433.11.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Jul 2009 11\:39\:04 +0200")
Message-ID: <87vdlrpord.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> In the wext code I tried to not reconnect all the time
> when the user wasn't really sure what they were doing,
> like setting the BSSID back to the same value it was.
> However, this optimisation should only be done while
> associated so that setting the BSSID back to the same
> value that it was actually triggers a new association
> if not currently associated. To achieve, that, put the
> relevant code into the !IDLE case instead.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

At least this patch cured my resume problems I reported earlier[1]. It
will take few days to test the dropping from network case, but I'm sure
this patch will help with that problem as well. If not, I'll report
about the issue. Thanks for fixing this.

Tested-by: Kalle Valo <kalle.valo@iki.fi>

[1] http://www.spinics.net/lists/linux-wireless/msg35797.html

-- 
Kalle Valo
