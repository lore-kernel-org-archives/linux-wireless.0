Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2KHRkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 12:40:53 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TWW60-0002h9-MC
	for linux-wireless@vger.kernel.org; Thu, 08 Nov 2012 18:40:52 +0100
Message-ID: <1352396489.11421.12.camel@jlt4.sipsolutions.net> (sfid-20121108_184104_965023_FE8D9748)
Subject: Re: [RFC] cfg80211: remove remain-on-channel channel type
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 08 Nov 2012 18:41:29 +0100
In-Reply-To: <1352396268-20776-1-git-send-email-johannes@sipsolutions.net> (sfid-20121108_183732_207729_D15E27D8)
References: <1352396268-20776-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121108_183732_207729_D15E27D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-08 at 18:37 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> As mwifiex (and mac80211 in the software case) are the
> only drivers actually implementing remain-on-channel
> with channel type, userspace can't be relying on it.
> This is the case, as it's used only for P2P operations
> right now.

The other reason for this, of course, is that I'm starting to work on
VHT channel configuration, and that can't be using the channel type enum
any more, so the internal APIs all have to change.

Since this really won't be needed for other channel types (for now),
I've decided to remove it instead rather than make my life more complex
with VHT. :)

johannes

