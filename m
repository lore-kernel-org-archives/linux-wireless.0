Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53446 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524AbcDEJRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:17:55 -0400
Message-ID: <1459847872.18188.23.camel@sipsolutions.net> (sfid-20160405_111758_724684_9F021C42)
Subject: Re: [PATCH 1/2] mac80211: don't send deferred frames outside the SP
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 11:17:52 +0200
In-Reply-To: <1458226302-6086-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1458226302-6086-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-17 at 16:51 +0200, Emmanuel Grumbach wrote:
> Frames that are sent between
> ampdu_action(IEEE80211_AMPDU_TX_START) and the move to the
> HT_AGG_STATE_OPERATIONAL state are buffered.
> If we try to start an A-MPDU session while the peer is
> sleeping and polling frames with U-APSD, we may have frames
> that will be buffered by ieee80211_tx_prep_agg. These frames
> have IEEE80211_TX_CTL_NO_PS_BUFFER set since they are sent to
> a sleeping client and possibly IEEE80211_TX_STATUS_EOSP.
> If the frame is buffered, we need clear these two flags
> since they will be re-sent after the move to
> HT_AGG_STATE_OPERATIONAL state which is very likely to
> happen after the SP ends.
> 
Applied.

johannes
