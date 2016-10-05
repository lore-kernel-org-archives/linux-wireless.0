Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43759 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750807AbcJEJbf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 05:31:35 -0400
Subject: Re: [PATCH] mac80211: discard multicast and 4-addr A-MSDUs
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1475655551-13504-1-git-send-email-johannes@sipsolutions.net>
Cc: "M . Braun" <michael-dev@fami-braun.de>,
        Johannes Berg <johannes.berg@intel.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <90c1bacf-3ea3-0486-96f4-be878a4a759e@nbd.name> (sfid-20161005_113138_724058_4B803283)
Date: Wed, 5 Oct 2016 11:31:30 +0200
MIME-Version: 1.0
In-Reply-To: <1475655551-13504-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-10-05 10:19, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In mac80211, multicast A-MSDUs are accepted in many cases that
> they shouldn't be accepted in:
>  * drop A-MSDUs with a multicast A1 (RA), as required by the
>    spec in 9.11 (802.11-2012 version)
>  * drop A-MSDUs with a 4-addr header, since the fourth address
>    can't actually be useful for them; this was already done in
>    the case where 4-addr behaviour was requested, but bizarrely
>    not in the common cases
Won't this break the use of A-MSDU in existing 4-addr AP/STA setups?

- Felix
