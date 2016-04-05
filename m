Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53522 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896AbcDEJeV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:34:21 -0400
Message-ID: <1459848853.18188.26.camel@sipsolutions.net> (sfid-20160405_113425_951404_8C1BAC7E)
Subject: Re: [PATCH 2/2] mac80211: close the SP when we enqueue frames
 during the SP
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 11:34:13 +0200
In-Reply-To: <1458226302-6086-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1458226302-6086-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1458226302-6086-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-17 at 16:51 +0200, Emmanuel Grumbach wrote:
> Since we enqueued the frame that was supposed to be sent
> during the SP, and that frame may very well cary the
> IEEE80211_TX_STATUS_EOSP bit, we may never close the SP
> (WLAN_STA_SP will never be cleared). If that happens, we
> will not open any new SP and will never respond to any poll
> frame from the client.
> Clear WLAN_STA_SP manually if a frame that was polled during
> the SP is queued because of a starting A-MPDU session. The
> client may not see the EOSP bit, but it will at least be
> able to poll new frames in another SP.
> 
Also applied.

johannes
