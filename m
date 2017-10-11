Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46606 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdJKLH2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 07:07:28 -0400
Message-ID: <1507720042.1998.31.camel@sipsolutions.net> (sfid-20171011_130757_075866_158974A6)
Subject: Re: [PATCH V5 1/5] mac80211: Enable TDLS peer buffer STA feature
From: Johannes Berg <johannes@sipsolutions.net>
To: yintang@qti.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 11 Oct 2017 13:07:22 +0200
In-Reply-To: <1507623080-9311-2-git-send-email-yintang@qti.qualcomm.com> (sfid-20171010_100936_649329_136CB55B)
References: <TDLS for ath10k patch>
         <1507623080-9311-1-git-send-email-yintang@qti.qualcomm.com>
         <1507623080-9311-2-git-send-email-yintang@qti.qualcomm.com>
         (sfid-20171010_100936_649329_136CB55B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/include/net/cfg80211.h
> @@ -3249,6 +3249,8 @@ struct cfg80211_ops {
>   *	beaconing mode (AP, IBSS, Mesh, ...).
>   * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key
> installation
>   *	before connection.
> + * @WIPHY_FLAG_SUPPORT_TDLS_BUFFER_ST: Device support buffer STA
> when TDLS is
> + *	established.

There's a typo (missing A) here.

However, I don't see a reason for this to be a WIPHY flag rather than a
mac80211 hw flag (enum ieee80211_hw_flags) since you only use it in
mac80211.

In reality, adding WIPHY flags should be really rare - only if
*cfg80211* needs to know something, but *userspace* doesn't...

If cfg80211 doesn't care, add to mac80211. If userspace cares, add to
extended nl80211 flags instead :)

johannes
