Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab0JDNIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 09:08:04 -0400
Subject: Re: [PATCH 2/6] mac80211: merge ieee80211_scan_work() common code
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1285934732-16087-2-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
	 <1285934732-16087-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:07:51 +0200
Message-ID: <1286197671.3620.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 14:05 +0200, Stanislaw Gruszka wrote:

> +out_complete:
> +	mutex_unlock(&local->mtx);
> +	if (rc)
> +		__ieee80211_scan_completed(&local->hw, true);

That must be aborted, not "true".

Also, I just noticed that together with the other patch this gets quite
confusing with the "if (rc)" logic. I think

out_complete:
	mutex_unlock
	completed()
	return;
out:
	mutex_unlock()
}

would ultimately be easier to understand.

johannes

