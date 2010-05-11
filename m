Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab0EKK5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 06:57:40 -0400
Subject: Re: [PATCH 1/5] ath9k_htc: Lock sta_notify() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith.Manoharan@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19433.14190.31764.174876@gargle.gargle.HOWL>
References: <19433.14190.31764.174876@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 12:57:33 +0200
Message-ID: <1273575453.3669.55.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-11 at 16:24 +0530, Sujith.Manoharan@atheros.com wrote:
> Since ->sta_notify() can sleep, protect
> the callback with a mutex.

While this may be a correct change, it's not a correct description :)

You should be locking _data_, not _code_, and due to mac80211 the
callback cannot be invoked twice at the same time anyway.

johannes


