Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:35910 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab1BNNjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 08:39:05 -0500
Date: Mon, 14 Feb 2011 15:38:58 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: reply to directed probes in IBSS
Message-ID: <20110214133858.GA7113@jm.kir.nu>
References: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
 <AANLkTimEDvmp2RbLXdOf8vRrjzBKd+rLwqoreX+x3EdB@mail.gmail.com>
 <1297678357.3785.14.camel@jlt3.sipsolutions.net>
 <20110214122818.GA6712@jm.kir.nu>
 <1297686694.3785.40.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297686694.3785.40.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 01:31:34PM +0100, Johannes Berg wrote:
> The next question ends up being under which circumstances we should
> _send_ a unicast probe request. Currently, I don't think we ever do.

For WMM, we could do that whenever we have frames to send to another STA
in the same IBSS and we have not yet received a Beacon frame from that
STA. Then again, I'm not sure whether we would ever send a frame in such
a state since that would need a STA entry (I hope). I haven't really
looked at the current implementation, but anyway, the key is to use
directed Probe Request in IBSS to make sure we have correct information
about a peer STA's capabilities.

For RSN IBSS, wpa_supplicant is currently pretty much hardcoded to use
RSN with CCMP and PSK. Eventually, it could be extended to probe the
peer before starting key negotiation to figure out which pairwise cipher
to use and to also validate AKM options before ending up in 4-way
handshake. I'm not sure whether this is really needed in practice, but
that option is certainly there in the standard.

-- 
Jouni Malinen                                            PGP id EFC895FA
