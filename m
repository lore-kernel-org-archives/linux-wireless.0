Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3GKIzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 04:55:39 -0400
Message-ID: <1373532936.8201.5.camel@jlt4.sipsolutions.net> (sfid-20130711_105542_624770_AB0DC56A)
Subject: Re: [WT PATCH 4/6] mac80211: Add per-sdata station hash, and sdata
 hash.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jul 2013 10:55:36 +0200
In-Reply-To: <1372546738-25827-4-git-send-email-greearb@candelatech.com> (sfid-20130630_005944_514926_D21D8724)
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
	 <1372546738-25827-4-git-send-email-greearb@candelatech.com>
	 (sfid-20130630_005944_514926_D21D8724)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-06-29 at 15:58 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Add sdata hash (based on sdata->vif.addr) to local
> structure.
> 
> Add sta_vhash (based on sta->sta.addr) to sdata struct.
> 
> Make STA_HASH give a better hash spread more often.
> 
> Use new hashes where we can.  Might be able to completely
> get rid of the local->sta_hash, but didn't want to try that
> quite yet.
> 
> This significantly improves performance when using lots
> of station VIFs connected to the same AP.  It will likely
> help other cases where the old hash logic failed to create
> a decent spread.

I think this is too much code for a corner case unlikely to happen
outside of your specific scenario, so I'm not taking this either.

I also don't like maintaining two separate hash tables and all that.

I'd reconsider if you actually remove the hash entirely, but that'll be
tricky to walk the station list and will quite possibly make the RX path
there more expensive?

johannes


