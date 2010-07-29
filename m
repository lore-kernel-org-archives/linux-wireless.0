Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0G2UmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 16:42:07 -0400
Subject: Re: [PATCH 1/2] mac80211: support use of NAPI for bottom-half
 processing
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280435978.3823.20.camel@jlt3.sipsolutions.net>
References: <1280434454-3597-1-git-send-email-linville@tuxdriver.com>
	 <1280435978.3823.20.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 22:42:06 +0200
Message-ID: <1280436126.3823.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-29 at 22:39 +0200, Johannes Berg wrote:

> > +	int (*napi_poll)(struct napi_struct *napi, int budget);
> 
> I'd prefer passing the hw here and having mac80211 wrap it in a simple
> function that does the container_of magic? Anything preventing that?
> Then the napi struct can be hidden from drivers.

Ok actually that requires wrapping napi_complete() too, that doesn't
seem worth it. Can you wrap the container_of() in an inline though and
maybe do "struct napi_struct _napi;" and document it shouldn't really be
touched or something?

johannes

