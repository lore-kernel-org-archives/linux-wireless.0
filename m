Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [12.131.200.82] ([12.131.200.82]:46679 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1750915AbeFDS6e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 14:58:34 -0400
Subject: Re: [PATCH 3/6] qtnfmac: implement cfg80211 power management callback
To: linux-wireless@vger.kernel.org,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
 <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com>
 <0303f713-9e0d-5180-035f-ea78ffe56d67@quantenna.com>
 <20180604125021.pvcbnqexrkgqd72q@bars>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <4dfbc70e-831b-e2d3-ae3f-0f0f23c4341c@quantenna.com> (sfid-20180604_205838_293047_393FDDD4)
Date: Mon, 4 Jun 2018 11:58:32 -0700
MIME-Version: 1.0
In-Reply-To: <20180604125021.pvcbnqexrkgqd72q@bars>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/2018 05:50 AM, Sergey Matyukevich wrote:
>> I think it's better be moved somewhere out of qtnf_wiphy_allocate() as OPS
>> are global for all MACs, while qtnf_wiphy_allocate() is called for each MAC
>> separately.
> 
> Consider the case of splitting hardware capabilities into two groups:
> global and per-wmac. In this case we may need to register different
> subsets of cfg80211 operations for each wmac. In such a case, function
> qtnf_wiphy_allocate looks like a reasonable point where to merge both
> capability groups and customize cfg80211_ops structure for each wmac.
> 


What I mean is that wiphy_new() will not dup cfg80211_ops that we pass, 
it will just assign a pointer to whatever it gets.
qtn_cfg80211_ops is global right now, if we modify it, it will affect 
all WMACs, not just the one that we're allocating.

Currently it's not a problem as we do not have any per-WMAC 
capabilities. If we to have any, we would have to dup qtn_cfg80211_ops 
in qtnf_wiphy_allocate().

Though I agree that we already have QLINK_HW_CAPAB_DFS_OFFLOAD 
processing in qtnf_wiphy_allocate(), so it makes sense to do a cleanup 
separately.
