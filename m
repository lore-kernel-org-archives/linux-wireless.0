Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34843 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0JDNMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 09:12:44 -0400
Subject: Re: [PATCH v2 1/3] mac80211: fix channel assumption for
 association done work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <1285965233-11097-2-git-send-email-lrodriguez@atheros.com>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
	 <1285965233-11097-2-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:12:40 +0200
Message-ID: <1286197960.3620.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 16:33 -0400, Luis R. Rodriguez wrote:
> Be consistent and use the wk->chan instead of the
> local->hw.conf.channel for the association done work.
> This prevents any possible races against channel changes
> while we run this work.
> 
> In the case that the race did happen we would be initializing
> the bit rates for the new AP under the assumption of a wrong
> channel and in the worst case, wrong band. This could lead
> to trying to assuming we could use CCK frames on 5 GHz, for
> example.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

