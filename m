Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43936 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbbKOOiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2015 09:38:13 -0500
Message-ID: <1447598285.2554.1.camel@sipsolutions.net> (sfid-20151115_153840_582285_0CE05C2D)
Subject: Re: [PATCH v2] cfg80211: add VHT support for Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@codeaurora.org>, Peter Oh <poh@qca.qualcomm.com>,
	ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 15 Nov 2015 15:38:05 +0100
In-Reply-To: <5646774D.2000801@codeaurora.org>
References: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com>
	 <1447358605.2131.3.camel@sipsolutions.net>
	 <564505A6.9030001@codeaurora.org>
	 <1447364413.2131.5.camel@sipsolutions.net>
	 <56451294.9060205@codeaurora.org>
	 <1447367523.2131.6.camel@sipsolutions.net>
	 <56451B2F.3060704@codeaurora.org>
	 <1447400275.3271.2.camel@sipsolutions.net>
	 <5646774D.2000801@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-13 at 15:50 -0800, Peter Oh wrote:
> 
> I'm saying, cannot use VHT Mesh by wpa_supplicant because a lack of 
> communication method between driver and wpa_supplicant, hence
> extending NL80211 feature flag.
> > 

And I'm arguing that you don't need such a communication method since,
unlike IBSS, mesh doesn't restrict the channel width usable further
than the HT/VHT capabilities.

It might, on the other hand, very well be that mesh stuff is missing
some VHT compatibility today - that would be an argument for a more
comprehensive patch that then includes the feature flag to say "we've
fixed the VHT issues in mesh mode". That's quite obviously not what
you're doing though.

johannes
