Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:3169 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZCNTpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 15:45:14 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1109074wfa.4
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 12:45:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090314171438.11126.30330.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171438.11126.30330.stgit@tikku>
Date: Sat, 14 Mar 2009 12:45:12 -0700
Message-ID: <43e72e890903141245k46f4dd4co6a33b45b82e9098a@mail.gmail.com> (sfid-20090314_204520_733846_425C9A1B)
Subject: Re: [RFC PATCH v2 2/4] mac80211: track beacons separately from the rx
	path activity
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 14, 2009 at 10:14 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Separate beacon and rx path tracking in preparation for the beacon filtering
> support. At the same time change ieee80211_associated() to look a bit simpler.
>
> Probe requests are now sent only after IEEE80211_PROBE_IDLE_TIME, which
> is now set to 60 seconds.
>
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

Can this be split into 3 separate patches, to make the one with the
actual functional changes easier to review. One is the making of
ieee80211_associated() look easier, the other the rename, and lastly
the actual functional changes. When reviewing the commit log it would
then be easier to see what was done.

  Luis
