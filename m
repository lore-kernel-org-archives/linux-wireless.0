Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:52985 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271Ab1G3S2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 14:28:23 -0400
Date: Sat, 30 Jul 2011 21:28:10 +0300
From: Jouni Malinen <j@w1.fi>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
Message-ID: <20110730182810.GA2743@jm.kir.nu> (sfid-20110730_202829_689676_BE43E3CD)
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com>
 <1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 07:22:17PM +0200, Helmut Schaa wrote:
> Since EAPOL frames are normal data frames they are treated by the rate
> control algorithm as such. Thus it can happen that the rate control
> algorithm chooses an inappropriate rate (minstrel_ht uses MCS rates for
> example) for the 4-way handshake and under low signal conditions the
> handshake may time out.
> 
> To fix this issue always treat EAPOL frames the same as management
> frames and send them with the lowest available rate.

I don't think that this should be applied for the reasons given (and
alternative mechanisms proposed) in the discussion.

-- 
Jouni Malinen                                            PGP id EFC895FA
