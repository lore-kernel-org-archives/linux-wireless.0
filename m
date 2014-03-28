Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:52150 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaC1NX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:23:57 -0400
Received: by mail-ig0-f169.google.com with SMTP id h18so797140igc.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 06:23:56 -0700 (PDT)
Date: Fri, 28 Mar 2014 09:22:04 -0400
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: TR: [RFC] 802.11s bitrate correction in airtime metric
 calculation
Message-ID: <20140328132204.GB18560@localhost> (sfid-20140328_142359_848722_BE0D569C)
References: <773DB8A82AB6A046AE0195C68612A31901734186@sbs2003.acksys.local>
 <773DB8A82AB6A046AE0195C68612A31901734187@sbs2003.acksys.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901734187@sbs2003.acksys.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 28, 2014 at 11:15:06AM +0100, Cedric VONCKEN wrote:
> Hi all,
> 
> I am currently using 802.11s for a project using openWrt mesh portals.
> All mesh points use 802.11a (non HT) and minstrel. Airtime metric uses a
> "rate"
> which is ultimately computed using sta->last_tx_rate from minstrel.
> 
> This last_tx_rate is also updated by minstrel attempts at lower and
> higher speeds. Even if these occasional attempts are outnumbered by
> frames at max_tp_rate[0], they cause unexpected airtime metric
> variations resulting in unneeded mesh path changes.
> My idea is to use max_tp_rate[0] (from minstrel) instead. This rate is
> not subject to minstrel attempts and directly reflects the speed used
> for the vast majority of the frames.

Interesting -- I tried this exact thing once before, but got mixed results
in my testing.

Can you share your testing strategy?

It's true that last_tx_rate is sub-optimal here, but I feel like using
max_tp_rate directly is a layering violation.  Many rate controllers
won't have that concept, and some rate controllers will exist entirely
in firmware.  So I think perhaps fixing the concept of "last_tx_rate" or
adding a new "best_tx_rate" field that excludes probes and such might be
the way forward, rather than calling into the rate controllers.

-- 
Bob Copeland %% www.bobcopeland.com
