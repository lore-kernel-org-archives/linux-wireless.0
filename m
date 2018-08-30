Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54540 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbeH3NFS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 09:05:18 -0400
Received: by mail-wm0-f68.google.com with SMTP id c14-v6so1156602wmb.4
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2018 02:04:09 -0700 (PDT)
Date: Thu, 30 Aug 2018 11:04:06 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: always account for A-MSDU header changes
Message-ID: <20180830090406.GD9867@localhost.localdomain> (sfid-20180830_110412_647509_93AB21DF)
References: <20180830085549.21955-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830085549.21955-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Johannes Berg <johannes.berg@intel.com>
> 
> In the error path of changing the SKB headroom of the second
> A-MSDU subframe, we would not account for the already-changed
> length of the first frame that just got converted to be in
> A-MSDU format and thus is a bit longer now.
> 
> Fix this by doing the necessary accounting.
> 
> It would be possible to reorder the operations, but that would
> make the code more complex (to calculate the necessary pad),
> and the headroom expansion should not fail frequently enough
> to make that worthwhile.
> 
> Fixes: 6e0456b54545 ("mac80211: add A-MSDU tx support")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
