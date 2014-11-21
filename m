Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56080 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbaKUNxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 08:53:04 -0500
Message-ID: <1416577981.1881.9.camel@sipsolutions.net> (sfid-20141121_145309_834447_D90C131E)
Subject: Re: [RFC 1/2] nl80211: support MSDU statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>
Date: Fri, 21 Nov 2014 14:53:01 +0100
In-Reply-To: <1416576505-15023-1-git-send-email-johannes@sipsolutions.net> (sfid-20141121_142834_070138_2793BA04)
References: <1416576505-15023-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20141121_142834_070138_2793BA04)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-21 at 14:28 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The base for the current statistics is pretty mixed up, support
> exporting RX/TX statistics for MSDUs.

Umm. Getting ahead of myself here - I actually wanted to make them
per-rate as well, but it's a bit awkward.

And it actually raises another question.

For RX, it is easy to do per-rate per-TID in mac80211. For TX, per-rate
is considerably more difficult and should probably have rate scaling
algorithm involvement, at least as far as iwlwifi is concerned.

Now, however, having separate counters for TX for per-rate and per-TID
seems a bit strange, if for RX they're per-rate/TID?

johannes

