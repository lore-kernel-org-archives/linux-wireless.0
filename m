Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946959Ab3BHUrC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:47:02 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U3uqb-0003XD-6F
	for linux-wireless@vger.kernel.org; Fri, 08 Feb 2013 21:47:01 +0100
Message-ID: <1360356410.29851.30.camel@jlt4.sipsolutions.net> (sfid-20130208_215343_885648_67AAFD43)
Subject: Re: [RFC 14/14] mac80211: properly track HT/VHT operation changes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 08 Feb 2013 21:46:50 +0100
In-Reply-To: <1360344344-15742-15-git-send-email-johannes@sipsolutions.net> (sfid-20130208_183812_452599_890EF4AF)
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
	 <1360344344-15742-15-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130208_183812_452599_890EF4AF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 18:25 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> A while ago, I made the mac80211 station code never change
> the channel type after association. This solved a number of
> issues but is ultimately wrong, we should react if the AP
> changes the HT operation IE and switches bandwidth. One of
> the issues is that we associate as HT40 capable, but if the
> AP ever switches to 40 MHz we won't be able to receive such
> frames because we never set our channel to 40 MHz.
> 
> This addresses this and VHT operation changes. If there's a
> change that is incompatible with our setup, e.g. if the AP
> decides to change the channel entirely (and for some reason
> we still hear the beacon) we'll just disconnect.

This part works. The rate control update is broken though ...

johannes

