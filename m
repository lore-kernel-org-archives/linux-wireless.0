Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:58886 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbeICNSz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:18:55 -0400
Message-ID: <1535965175.3437.21.camel@sipsolutions.net> (sfid-20180903_110029_782043_0682D854)
Subject: Re: [PATCH 00/28] cfg80211/mac80211 patches from our internal tree
 2018-08-31
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Naftali Goldstein <naftali.goldstein@intel.com>
Date: Mon, 03 Sep 2018 10:59:35 +0200
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi> (sfid-20180831_103149_730121_01876D5D)
References: <20180831083130.15525-1-luca@coelho.fi>
         (sfid-20180831_103149_730121_01876D5D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied 2, 4, 8, 10, 11 as fixes.
Applied 1, 3, 5, 6, 7, 

As Kalle pointed out, 20-28 are corrupted, so you need to resend; 22 was
already in the tree, no need to resend that one.

Please respin patch 20 ("mac80211: fix saving a few HE values") to use
FIELD_GET() to avoid such problems in the future. Or perhaps just use
le32_get_bits(), avoiding the explicit conversion first, I think the
compiler will probably do something sane either way.

While you're resending, please fix the kernel-doc in patch 19.

Please resend patches 9 and 12 as well, addressing my comments on it.

Still haven't looked at patch 12 because I remember some ordering issues
and need to double-check that.

johannes
