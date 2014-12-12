Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaLLVvX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 16:51:23 -0500
Date: Fri, 12 Dec 2014 22:51:21 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: avoid intersection when applying custom reg
Message-ID: <20141212215121.GS25677@wotan.suse.de> (sfid-20141212_225126_401941_AF6714D9)
References: <1417968225-17518-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417968225-17518-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 07, 2014 at 06:03:45PM +0200, Arik Nemtsov wrote:
> The custom-reg handling function can currently only add flags to a given
> channel. This results in stale flags being left applied. In some cases
> a channel was disabled and even the orig_flags were changed to reflect
> this.
> 
> Previously the API was designed for a single invocation before wiphy
> registration, so this didn't matter. The previous approach doesn't scale
> well to self-managed regulatory devices, particularly when a more
> permissive regdom is applied after a restrictive one.

So why not make this an excemption to only managed devices? You show the
issue but am not convinced this won't introduce regressions so would
prefer to make this an exception for managed devices.

  Luis
