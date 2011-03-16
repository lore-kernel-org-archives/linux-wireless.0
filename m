Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51751 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1CPJrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 05:47:51 -0400
Received: by iyb26 with SMTP id 26so1481205iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 02:47:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300268390.3761.14.camel@jlt3.sipsolutions.net>
References: <1300268390.3761.14.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 16 Mar 2011 02:47:31 -0700
Message-ID: <AANLkTi=r-iktQVn8b1=iCh0PFDDP=mSVBUeqBfxa5e_B@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix comment regarding aggregation buf_size
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm, this seems to not quite convey some complexities. See some inlines below.

On Wed, Mar 16, 2011 at 2:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The description for buf_size was misleading and
> just said you couldn't TX larger aggregates, but
> of course you can't TX aggregates in a way that
> would exceed the window either, which is possible
> even if the aggregates are shorter than that.
>
> Expand the description, thanks to Emmanuel for
> explaining this to me.
>
> Cc: Emmanuel Grumbach <egrumbach@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/mac80211.h |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> --- a/include/net/mac80211.h    2011-03-16 10:30:26.000000000 +0100
> +++ b/include/net/mac80211.h    2011-03-16 10:37:49.000000000 +0100
> @@ -1753,8 +1753,17 @@ enum ieee80211_ampdu_mlme_action {
>  *     that TX/RX_STOP can pass NULL for this parameter.
>  *     The @buf_size parameter is only valid when the action is set to
>  *     %IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's reorder
> - *     buffer size (number of subframes) for this session -- aggregates
> - *     containing more subframes than this may not be transmitted to the peer.
> + *     buffer size (number of subframes) for this session -- the driver
> + *     may neither send aggregates containing more subframes than this
> + *     nor send aggregates in a way that lost frames would exceed the
> + *     buffer size. If just limiting the aggregate size, this would be

<dan starts here>

> + *     possible with a buf_size of 8:
> + *      - TX: 1.....7
> + *      - RX: 2.....7 (lost frame #1),
> + *      - TX:         89...1...
> + *     which is invalid since #1 was now re-transmitted well past the
> + *     buffer size of 7. The correct way to retransmit #1 would be:
> + *      - TX:         1       or
> + *      - TX:         18
> + *     though the standard allows:
> + *      - TX:         81
> + *     The following might happen, but will violate buffering assumptions as above if frame 1 is lost again
> + *      - TX:         189.....

Dan
