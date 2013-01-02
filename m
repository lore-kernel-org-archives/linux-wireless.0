Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3ABKtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 05:49:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TqLtH-0004Ak-T3
	for linux-wireless@vger.kernel.org; Wed, 02 Jan 2013 11:49:44 +0100
Message-ID: <1357123801.9839.0.camel@jlt4.sipsolutions.net> (sfid-20130102_114952_059423_6641656F)
Subject: Re: [PATCH] nl80211/mac80211: support full station state in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 11:50:01 +0100
In-Reply-To: <1356636718-16000-1-git-send-email-johannes@sipsolutions.net> (sfid-20121227_203149_567722_88BE9968)
References: <1356636718-16000-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121227_203149_567722_88BE9968)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-27 at 20:31 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Today, stations are added already associated. That is
> inefficient if, for example, the driver has no room
> for stations any more because then the station will
> go through the entire auth/assoc handshake, only to
> be kicked out afterwards.
> 
> To address this a bit better, at least with drivers
> using the new station state callback, allow hostapd
> to add stations in unauthenticated mode, just after
> receiving the AUTH frame, before even replying. Thus
> if there's no more space at that point, it can send
> a negative auth frame back. It still needs to handle
> later state transition errors though, of course.

Applied.

johannes

