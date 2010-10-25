Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0JYJJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 05:09:33 -0400
Subject: Re: Complexity of Adding 5/10 MHz Channel Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Galen <galenz@zinkconsulting.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1A7DEBB8-6337-4551-9F21-14C20E13B86B@zinkconsulting.com>
References: <1A7DEBB8-6337-4551-9F21-14C20E13B86B@zinkconsulting.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 10:46:19 +0200
Message-ID: <1287996379.3587.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-15 at 15:30 -0700, Galen wrote:
> Can anybody give me an idea the extent and complexity of adding
> support for 5/10 MHz channels in mac80211?
> 
> Several different radios (including those supported by ath5k and
> ath9k) have the hardware capability to operate at 5 MHz. Obviously,
> support in those drivers is a separate issue, but it is my
> understanding that mac80211 must first support 5/10 MHz channels.

Since we already have channel types, I've always suggested to add 5/10
as such. The complexity comes from the fact that some channel types are
incompatible, and we currently do not have to handle that -- a regular
scan for example will cover all current channel types, but with 5/10 MHz
you need to do special scans etc.

Also, you need to start in cfg80211, not mac80211, and make everything
from auth/assoc/connect/ibss-join etc. aware of channel types as well as
center freq.

johannes

