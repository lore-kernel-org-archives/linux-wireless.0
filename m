Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.231]:26302 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXJXGek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 02:34:40 -0400
Received: by nz-out-0506.google.com with SMTP id s18so112318nze
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2007 23:34:39 -0700 (PDT)
Message-ID: <40f31dec0710232334u38731941ua642583e44fef7a9@mail.gmail.com> (sfid-20071024_073501_113050_C93F791B)
Date: Wed, 24 Oct 2007 09:34:38 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Eric W Anderson" <Eric.Anderson@colorado.edu>
Subject: Re: Proc usage (was: Re: [ath5k-devel] [PATCH 3/3] consistently use ath5k in printks)
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <471EC944.2010700@colorado.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-4-git-send-email-bruno@thinktube.com>
	 <1192619652.8841.13.camel@johannes.berg>
	 <1192630172.10567.29.camel@localhost.localdomain>
	 <43e72e890710170719o120f9dbak34f33d8218038dfc@mail.gmail.com>
	 <40f31dec0710170926p3847b796gdf52f80297b7c117@mail.gmail.com>
	 <471EC944.2010700@colorado.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/24, Eric W Anderson <Eric.Anderson@colorado.edu>:
> I realize that primary role of the driver is for actual use, rather than for
> research, but...  It's very useful in experiments to have /proc entries for all
> the settings that you don't normally think of as tunable.  (e.g. turning off
> antenna diversity, or ACKs, or changing the CCA thresholds). I'd really hate for
> knobs to go away because someone things they're not "really" needed, or because
> they're not worth merging into the new configuration framework.
>
> -Eric
>

We don't say that these values (eg. diversity) should not be tweaked,
we say that /proc isn't the right solution. Also have in mind that for
some of these we don't know if they work ok with the reverse
engineered HAL, eg. i'm not sure that disabling rx diversity works
because we haven't tested current hw_setdefantenna implementation
(disabling tx diversity should work by passing a proper antenna value
on setup_tx_desc but diversity is something that we might handle on
mac80211, /proc's purpose is not doing configuration stuff).

Actually only tweakable values at the moment are the calibration
interval (very few people will play with that) and debug (which is a
mask for enabling various debug messages) and i think they are both
useless for someone not working on the driver. You can always use
madwifi with the binary HAL for such stuff and research. Tweaking is
not a priority right now for ath5k, we have to make things working
before we start tweaking  (eg. we can't tweak diversity when we still
work on phy initialization)...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
