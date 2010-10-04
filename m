Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab0JDNJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 09:09:13 -0400
Subject: Re: [PATCH 3/6] mac80211: keep lock when calling
 __ieee80211_scan_completed()
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1285934732-16087-3-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
	 <1285934732-16087-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:09:06 +0200
Message-ID: <1286197746.3620.30.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 14:05 +0200, Stanislaw Gruszka wrote:

>  out_complete:
> +	finish = false;
> +	if (rc) {
> +		hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
> +		finish = __ieee80211_scan_completed(&local->hw, aborted, hw_scan);
> +	}
> +
>  	mutex_unlock(&local->mtx);
> -	if (rc)
> -		__ieee80211_scan_completed(&local->hw, true);
> +
> +	if (finish)
> +		__ieee80211_scan_completed_finish(&local->hw, hw_scan);
>  }

And this makes the logic here even more confusing :-)

johannes

