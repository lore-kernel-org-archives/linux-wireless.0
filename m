Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0LIMsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 07:48:01 -0500
Subject: Re: [PATCH] cfg80211: update information elements in cached BSS
 struct
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291891690-26118-1-git-send-email-s.neumann@raumfeld.com>
References: <1291891690-26118-1-git-send-email-s.neumann@raumfeld.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 13:47:56 +0100
Message-ID: <1291898876.3540.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 11:48 +0100, Sven Neumann wrote:
> When a cached BSS struct is updated because a new beacon was received,
> the code replaces the cached information elements by the IEs from the
> new beacon. However it did not update the pub.information_elements
> and pub.len_information_elements fields leaving them either pointing
> to the old beacon IEs or in an inconsistent state where the data is
> replaced by the new beacon IEs but len_information_elements still has
> its value from the first beacon.
> 
> Fix this by updating the information elements fields if they are
> pointing to beacon IEs.

Err, no, this is intentional -- we want data from probe responses to
"win" and be displayed preferentially. If you look at the code that
dumps them out, that's what will happen.

If you need the most up-to-date beacon IEs, use (the equivalent of) "iw
wlan0 scan dump -b".

johannes

