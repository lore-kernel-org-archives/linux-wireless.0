Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46864 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbbFQJCd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:02:33 -0400
Message-ID: <1434531750.1884.20.camel@sipsolutions.net> (sfid-20150617_110242_551271_39A71322)
Subject: Re: [PATCH] mac80211: TDLS: correctly configure SMPS state
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 17 Jun 2015 11:02:30 +0200
In-Reply-To: <1434290026-10158-1-git-send-email-arik@wizery.com> (sfid-20150614_155351_638821_596E824E)
References: <1434290026-10158-1-git-send-email-arik@wizery.com>
	 (sfid-20150614_155351_638821_596E824E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-06-14 at 16:53 +0300, Arik Nemtsov wrote:
> The IEEE802.11-2012 specification is vague regarding SMPS operation during
> TDLS. It does not define a clear way to transition between SMPS states.
> 
> To avoid interop issues, set SMPS to off when TDLS peers are connected.
> Accomplish this by extending the definition of the AUTOMATIC state. If the
> driver forces a state other than OFF, disconnect all TDLS peers.
> 
> While at it, avoid changing the SMPS state of the peer STA. We have no
> way to control it, so try and behave correctly towards it.
> 
> Move the TDLS peer-teardown function to where the rest of the TDLS code
> resides.

Applied.

johannes

