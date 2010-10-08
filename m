Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab0JHRM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 13:12:26 -0400
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <lrodriguez@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath9k <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAF4FDA.8060908@candelatech.com>
References: <SNT111-W333C4BA6050D535151071FFB690@phx.gbl>
	 <SNT111-W2989DC6A52022428756E6FB500@phx.gbl>
	 <20101008111221.5425.qmail@stuge.se>
	 <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com>
	 <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl>
	 <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>
	 <4CAF4B70.9050001@candelatech.com> <20101008165232.GI10149@tux>
	 <4CAF4FDA.8060908@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 19:12:23 +0200
Message-ID: <1286557944.3612.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-08 at 10:07 -0700, Ben Greear wrote:

> Well, the command fails because of this check (mbm is 20 in his case)
> cfg.c:
> 	case NL80211_TX_POWER_FIXED:
> 		if (mbm < 0 || (mbm % 100))
> 			return -EOPNOTSUPP;
> 
> That mbm % 100 looks quite strange to me..any idea what that is supposed to
> accomplish?

There's a later division by 100 to go from mBm to dBm ... I think you
want 2000, not 20.

johannes

