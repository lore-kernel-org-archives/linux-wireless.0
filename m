Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58234 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751576AbdF0RUm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 13:20:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 1/8] qtnfmac: updates and fixes for regulatory support
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
        <20170620195517.18373-2-sergey.matyukevich.os@quantenna.com>
Date: Tue, 27 Jun 2017 20:20:38 +0300
In-Reply-To: <20170620195517.18373-2-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 20 Jun 2017 22:55:10 +0300")
Message-ID: <87wp7x4aah.fsf@purkki.adurom.net> (sfid-20170627_192046_544588_EAF6F37D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> This patch introduces several changes for regulatory support
> in qtnfmac driver:
>
> * Introduce support for setting regdomain from host
> New command is implemented to notify firmware about regdomain changes
> performed by host. Firmware is supposed to check requested regdomain
> changes. On success firmware enables updated hardware channel
> configuration and then host driver updates channel info for each band.
>
> * Introduce support of custom regulatory rules
> Obtain custom regulatory rules from the firmware and
> enable them during wiphy registration
>
> * Regulatory for self-managed setup
> Regdomain information needs to be registered with cfg80211
> for devices with REGULATORY_WIPHY_SELF_MANAGED flag set.
>
> * Misc fixes in regulatory code paths
>   - add missing lock in qtnf_cmd_get_mac_chan_info
>   - do not free band channel structure if channel count is the same
>   - free allocated regdomain hw_info.rd structure on detach
>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Each patch should contain one logical change, but here you are listing
multiple changes in the commit log which is a clear indication that's
not the case here. Is there a specific reason why you did it like this?

-- 
Kalle Valo
