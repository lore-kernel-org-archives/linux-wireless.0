Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33492 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab0CQCNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 22:13:46 -0400
Date: Tue, 16 Mar 2010 19:13:38 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: Add local-state-change-only
 auth/deauth/disassoc
Message-ID: <20100317021338.GA5654@jm.kir.nu>
References: <20100313195335.GA2420@jm.kir.nu>
 <1268777894.8918.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268777894.8918.13.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 16, 2010 at 03:18:14PM -0700, Johannes Berg wrote:
> mac80211 no longer maintains auth state at all when the auth is not in
> process, so should we, instead of passing this all through mac80211,
> make it cfg80211-only? Ok that doesn't work for the assoc part, but for
> auth it should?

I thought about that a bit when going through the needed changes and the
question of what to do with key configuration before association.. If we
want to enable that optimization, we will likely need to notify mac80211
somehow and this auth part could indeed be that notification. Or did you
have some other ways in mind for getting keys configured
pre-association?

-- 
Jouni Malinen                                            PGP id EFC895FA
