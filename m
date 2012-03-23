Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab2CWIwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 04:52:07 -0400
Message-ID: <1332492725.3506.5.camel@jlt3.sipsolutions.net> (sfid-20120323_095212_753670_4CB8726B)
Subject: Re: [RFC 08/12] mac80211: introduce
 IEEE80211_HW_SUPPORTS_MULTI_CHANNEL
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2012 09:52:05 +0100
In-Reply-To: <8ddd58c3-b1d2-44b3-8fb6-a9368814653b@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154023_532477_CDEA420A)
References: <8ddd58c3-b1d2-44b3-8fb6-a9368814653b@FIVLA-EXHUB02.eu.tieto.com>
	 (sfid-20120320_154023_532477_CDEA420A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 11:36 +0100, Michal Kazior wrote:
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  include/net/mac80211.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index c114b18..f7f0252 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1130,6 +1130,9 @@ enum sta_notify_cmd {
>   * @IEEE80211_HW_MFP_CAPABLE:
>   *	Hardware supports management frame protection (MFP, IEEE 802.11w).
>   *
> + * @IEEE80211_HW_SUPPORTS_MULTI_CHANNEL
> + *	Hardware supports concurrent multi-channel operation.

This isn't nearly as fully-featured as we need, I think.

There is undoubtedly going to be hardware that doesn't support one
channel per virtual interface, simply because it can only do maybe two
or three channels and many more virtual interfaces.

Now, we already have this advertising though in the interface
combinations, so this flag isn't necessary.

The question is how we structure the API, the two possibilities I was
thinking of are:
1) do similar to what you did, have per-interface channel and let the
   driver sort it out -- however this still requires channel
   compatibility checks in mac80211 etc.
2) keep mac80211 doing more work and introduce API like
   * add channel context
   * move vif A to channel context X
   * etc.

I'm not sure which one's better, and I still have to look at the monitor
interface implementation to make sure we do it right.

johannes

