Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518Ab2HXJ3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 05:29:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T4qD5-0004jH-RJ
	for linux-wireless@vger.kernel.org; Fri, 24 Aug 2012 11:29:48 +0200
Message-ID: <1345800585.4503.8.camel@jlt3.sipsolutions.net> (sfid-20120824_113044_356303_14951AEB)
Subject: Re: [RFC 00/20] mac80211: multi-channel work
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 24 Aug 2012 11:29:45 +0200
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131724_863712_473E357A)
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120727_131724_863712_473E357A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 13:16 +0200, Johannes Berg wrote:

> Comments welcome!

Ilan pointed me to a problem here yesterday.

Say we authenticate, then at that time we'll bind the virtual interface
into an appropriate channel context. Now we associate, and keep that
channel context. So far, so good.

Now say we disassociate. At this point, the connection is gone, so we
remove the channel context.

Now if the supplicant wants to deauthenticate as well, we have no
channel context to use for it. We could use remain-on-channel? Or we
could create a new channel context? Or just ignore the deauth? I haven't
found a good solution yet... We also can't rely on the supplicant always
doing a deauth, so we don't want to keep the channel context around
until the deauth either.

Obviously the same can also happen if the supplicant just asks us to
deauthenticate without ever having connected at all, but that's a rather
unlikely case.

Anyone have any idea? :)

johannes

