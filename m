Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:38140 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbYL1VgD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 16:36:03 -0500
Subject: Re: [PATCH] mac80211: add declarations for
 wake/stop_queue_by_reason()
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081228185414.6204.97451.stgit@tikku>
References: <20081228185414.6204.97451.stgit@tikku>
Content-Type: text/plain
Date: Sun, 28 Dec 2008 16:36:00 -0500
Message-Id: <1230500160.25726.7.camel@dv> (sfid-20081228_223608_409416_3D6A5C39)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-12-28 at 20:54 +0200, Kalle Valo wrote:
> Fixes sparse warnings:
> 
> net/mac80211/util.c:355:6: warning: symbol 
>   'ieee80211_wake_queue_by_reason' was not declared. Should it be static?
> net/mac80211/util.c:385:6: warning: symbol 
>   'ieee80211_stop_queue_by_reason' was not declared. Should it be static?

...
 
> +void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
> +				    enum queue_stop_reason reason);
> +void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
> +				    enum queue_stop_reason reason);

What's the point in declaring functions that are not used elsewhere?
Why not make them static as sparse suggests?  And if those function are
going to be used by other modules, maybe they should be exported?

-- 
Regards,
Pavel Roskin
