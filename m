Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40356 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbeH2OMy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 10:12:54 -0400
Received: by mail-wm0-f68.google.com with SMTP id 207-v6so4893841wme.5
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 03:16:42 -0700 (PDT)
Date: Wed, 29 Aug 2018 12:16:38 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sara Sharon <sara.sharon@intel.com>
Subject: Re: [PATCH] mac80211: avoid kernel panic when building AMSDU from
 non-linear SKB
Message-ID: <20180829101637.GA2488@localhost.localdomain> (sfid-20180829_121646_088997_71BD2E82)
References: <20180829065702.7316-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180829065702.7316-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Sara Sharon <sara.sharon@intel.com>
> 
> When building building AMSDU from non-linear SKB, we hit a
> kernel panic when trying to push the padding to the tail.
> Instead, put the padding at the head of the next subframe.
> This also fixes the A-MSDU subframes to not have the padding
> accounted in the length field and not have pad at all for
> the last subframe, both required by the spec.
> 
> Fixes: 6e0456b54545 ("mac80211: add A-MSDU tx support")
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/tx.c | 38 +++++++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 17 deletions(-)
> 

Reviewed-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
