Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60074 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1BBIGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 03:06:41 -0500
Received: by qyk12 with SMTP id 12so8487491qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 00:06:41 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110128075211.26919.39228.stgit@localhost6.localdomain6>
References: <20110128075211.26919.39228.stgit@localhost6.localdomain6>
Date: Wed, 2 Feb 2011 09:06:40 +0100
Message-ID: <AANLkTim2MBSMSDxyokEWWDC=bwzMCO92qd4_i3Cm0h29@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Fix short and long retry configuration
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 28, 2011 at 8:52 AM, Bruno Randolf <br1@einfach.org> wrote:
> The register definition for retry configuration on AR5212 was wrong, and simply
> copied over from AR5210. Update the register definitions from the documentation.
>
> Let the short and long retries be configured from mac80211 and use the standard
> values of 7 and 4 by default. Also we need to make sure we don't export more
> retries than we are configured for to mac80211 (and the rate module) in
> hw->max_rate_tries.
>
> Also clean up the code by removing unused defines and variables and drop the
> different values for "station retries" - if these need to be different it can
> be handled tru ah_retry_long/short.
>

As I saw your patch in linux-next/wireless-next-2.6, I wanted to ask
what's up with Bob's
"mac80211-minstrel-honor-max-retry-counts-from-cfg80211.patch" (see
[1])?
Is this patch obsolete, now?
Will it go in one of the wireless trees?


- Sedat -

[1] https://patchwork.kernel.org/patch/359722/
