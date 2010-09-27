Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0I0Is5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:48:57 -0400
Subject: Re: [PATCH 07/25] wl1271: Change supported channel order for a
 more optimal scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
In-Reply-To: <1285576669-8070-8-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-8-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 10:48:54 +0200
Message-ID: <1285577334.4043.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 11:37 +0300, Luciano Coelho wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The mac80211 inserts channels into a scan request in the same order the driver
> registers them. Use this fact to optimize scan by ordering the channels so
> that adjacent channels don't get scanned consecutively.

Cute, but not really ...

First of all, iw will also report channels in this order, and that's
just weird.

Secondly, if you pass any channels to scan manually (say with iw), this
assertion is no longer true -- cfg80211 will actually _sort_ the
channels in that case to make sure there are no duplicates.

So you really shouldn't be doing this.

johannes

