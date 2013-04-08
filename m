Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935727Ab3DHTiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 15:38:54 -0400
Message-ID: <1365449914.25475.20.camel@jlt4.sipsolutions.net> (sfid-20130408_213900_996138_AEBDCC8B)
Subject: Re: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Mon, 08 Apr 2013 21:38:34 +0200
In-Reply-To: <CAG6hwVOBqfP_Mw-pirzEOFytck-7H6_LNiTtO_90gXskbEuNTg@mail.gmail.com> (sfid-20130408_213109_239033_A79D64E9)
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 <1365444377-9959-3-git-send-email-thomas@cozybit.com>
	 <1365446248.25475.17.camel@jlt4.sipsolutions.net>
	 <CAG6hwVOBqfP_Mw-pirzEOFytck-7H6_LNiTtO_90gXskbEuNTg@mail.gmail.com>
	 (sfid-20130408_213109_239033_A79D64E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 12:30 -0700, Thomas Pedersen wrote:

> OK those functions are exported to the drivers. The 'enum
> queue_stop_reason' is defined in ieee80211_i.h, so the driver wouldn't
> be able to interpret them anyway?

Oh, you're way underestimating the creativity of driver authors :-)

> Would you prefer a utility function internal to mac80211 which does
> return the reason, 

That seems fine, although a bit more inefficient?

> or just the following pattern?
> 
> if (ieee80211_queue_stopped(hw, queue)) {
>     qreason = hw_to_local(hw)->queue_stop_reasons[queue];
>     if (qreason & ~(ALLOWED_QUEUE_STOP_REASONS))
>         something;
> }

That seems racy? Even asking whether it's stopped is racy though, what
are you even trying to accomplish?

johannes

