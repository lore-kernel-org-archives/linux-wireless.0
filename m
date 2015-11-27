Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44846 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbbK0IfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:35:21 -0500
Message-ID: <1448613316.2531.13.camel@sipsolutions.net> (sfid-20151127_093523_998354_7D51BB1C)
Subject: Re: [PATCH v2 6/8] cfg80211: reg: Add NL80211_RRF_USER_REGD_NEEDED
 flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>, linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?ISO-8859-1?Q?Kaisrl=EDk?= <kaisrja1@fel.cvut.cz>
Date: Fri, 27 Nov 2015 09:35:16 +0100
In-Reply-To: <1448303241-27747-7-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192804_844242_D8C85F7B)
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
	 <1448303241-27747-7-git-send-email-sojkam1@fel.cvut.cz>
	 (sfid-20151123_192804_844242_D8C85F7B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-23 at 19:27 +0100, Michal Sojka wrote:
> 
> The NL80211_RRF_USER_REGD_NEEDED flag introduced in this commit
> allows
> drivers to specify that certain band is enabled only if it is
> additionally enabled in user-supplied regulatory database. If the
> band
> is not present there, the channels are simply disabled.

I can see why you'd want this flag internally (although it'll require
rework given the comments on the previous patch) - but is there a
reason to export it in nl80211? Then again, perhaps it *would* be good
to show this information in userspace?

johannes
