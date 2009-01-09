Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4018 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZAIS3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 13:29:20 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
Subject: Re: drivers returning wrong results from their _tx op
Date: Fri, 9 Jan 2009 13:27:27 -0500
Message-Id: <20090109182142.M2510@bobcopeland.com> (sfid-20090109_192924_395403_24228DE9)
In-Reply-To: <87hc48tpwa.fsf@litku.valot.fi>
References: <1231193264.3697.41.camel@johannes> <b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com> <1231246859.3503.0.camel@johannes> <20090109022347.GA5077@hash.localnet> <87hc4828xn.fsf@litku.valot.fi> <20090109153716.M19288@bobcopeland.com> <87hc48tpwa.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 09 Jan 2009 18:17:41 +0200, Kalle Valo wrote
> I read it. Adding "or NETDEV_TX_BUSY if it fails" is just confusing,
> better to state that it just should not fail.

Fair enough, but the state of things today is some drivers do.
Yes, we're guilty of that in ath5k and it should be fixed.  But like 
->config(), if the callback should never ever fail, then returning
an error code at all is pretty suspect.  Would this be better?

"This function should return NETDEV_TX_OK except in very limited cases."

Then when someone asks which cases, you say "none"...

-- 
Bob Copeland %% www.bobcopeland.com

