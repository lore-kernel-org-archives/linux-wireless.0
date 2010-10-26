Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57953 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab0JZLk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 07:40:58 -0400
Subject: Re: [PATCH 1/2] wl1271: Fix scan failure detection
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: luciano.coelho@nokia.com, linux-wireless@vger.kernel.org
In-Reply-To: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 13:40:57 +0200
Message-ID: <1288093257.3761.59.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 14:24 +0300, juuso.oikarinen@nokia.com wrote:

>  	mutex_lock(&wl->mutex);
>  
> +	if (wl->state == WL1271_STATE_OFF) {
> +		/*
> +		 * We cannot return -EBUSY here because mac80211 will expect
> +		 * a call to ieee80211_scan_completed if we do - in this case
> +		 * there won't be any call.
> +		 */

???

johannes

