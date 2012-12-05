Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2LEPzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 10:55:15 -0500
Message-ID: <1354722937.24513.2.camel@jlt4.sipsolutions.net> (sfid-20121205_165519_083368_3587CF83)
Subject: Re: [PATCH] mac80211: Skip radiotap space calculation if no monitor
 exists
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Dec 2012 16:55:37 +0100
In-Reply-To: <1354714572-26995-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121205_143626_644904_42C126D6)
References: <1354714572-26995-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20121205_143626_644904_42C126D6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 14:36 +0100, Helmut Schaa wrote:
> The radiotap header length "needed_headroom" is only required if we're
> sending the skb to a monitor interface. Hence, move the calculation a
> bit later so the calculation can be skipped if no monitor interface is
> present.

Applied. If we didn't need "local" we could mark the function __pure and
the compiler would do this optimisation for us ;-))

johannes

