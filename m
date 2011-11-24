Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1KXPQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 10:16:43 -0500
Subject: Re: [PATCH 4/7] mac80211: fix forwarded mesh frame queue mapping
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
In-Reply-To: <1322080347-7644-5-git-send-email-thomas@cozybit.com> (sfid-20111123_213318_804832_690FC766)
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
	 <1322080347-7644-5-git-send-email-thomas@cozybit.com>
	 (sfid-20111123_213318_804832_690FC766)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 16:16:40 +0100
Message-ID: <1322147800.5366.24.camel@jlt3.sipsolutions.net> (sfid-20111124_161647_127775_2565B369)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +/* Indicate which queue to use for this fully formed 802.11 frame */
> +u16 ieee80211_select_queue_cooked(struct ieee80211_local *local,
> +				  struct sk_buff *skb,
> +				  struct ieee80211_hdr *hdr) {

Where's that opening brace? ;-)

Can't say I like the name -- maybe select_queue_80211 or so would be
better? The "cooked" term is really only relevant for the special case
of monitor interfaces for AP mode that I'm even trying to get rid of ...

johannes

