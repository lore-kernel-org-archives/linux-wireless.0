Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab1GFT2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 15:28:06 -0400
Subject: Re: [PATCH 2/2] mac80211: fix CCMP PN race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110706101558.466384440@sipsolutions.net> (sfid-20110706_121637_541845_ADF8A914)
References: <20110706100929.554431961@sipsolutions.net>
	 <20110706101558.466384440@sipsolutions.net>
	 (sfid-20110706_121637_541845_ADF8A914)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 21:28:04 +0200
Message-ID: <1309980484.3893.10.camel@jlt3.sipsolutions.net> (sfid-20110706_212810_349767_57E7C6C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-06 at 12:09 +0200, Johannes Berg wrote:
> plain text document attachment (009-mac80211-fix-ccmp-races.patch)
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since we can process multiple packets at the
> same time for different ACs, but the PN is
> allocated from a single counter, we need to
> use an atomic value there. Use atomic64_t to
> make this cheaper on 64-bit platforms, other
> platforms will support this through software
> emulation, see lib/atomic64.c.

This fixes the PN race but is incomplete, will send a new version.

johannes

