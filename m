Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab1J1LzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 07:55:21 -0400
Subject: Re: [PATCH] mac80211: disable powersave for broken APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Bill C Riemers <briemers@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EAA979D.7090108@redhat.com>
References: <1319795987.8931.7.camel@jlt3.sipsolutions.net>
	 <4EAA979D.7090108@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 13:55:06 +0200
Message-ID: <1319802906.8931.11.camel@jlt3.sipsolutions.net> (sfid-20111028_135524_620023_6EE58F3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 07:53 -0400, Bill C Riemers wrote:
> I'm not sure how patching this patch will stop the abort in
> iwl-core.c.   Unless of course the aid value set here ends up as what
> is tested in iwl-core.c.  

That's what happens, yes.

>  BTW.  Is it 2007 or 0x2007.   The ieee80211_softmac.c code is using
> 0x2007.  While it could just be coincidence, I would expect these two
> should be the same constant...

ieee80211_softmac.c is wrong then -- but it doesn't exist in upstream
kernels any more anyway so I'm not sure where you're seeing it? The
range is 1-2007, not 0x2007.

> I won't be able to test the code as it will take about 1-2 hours for a
> kernel build, and I am checking out of my hotel in about 30 minutes.
> However, my colleague mentioned he was seeing the same problem on his
> home network.   So I will ask him if my previous build fixed his
> problem.  If so it probably really is the exact same problem, and I
> can ask him to test this new patch.

Alright. I'm pretty confident it'd fix it since this is where the AID
value is obtained from the AP and passed down to iwlwifi.

johannes

