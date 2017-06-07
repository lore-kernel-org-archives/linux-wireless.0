Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60712 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbdFGV51 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2017 17:57:27 -0400
Message-ID: <1496872642.3291.4.camel@sipsolutions.net> (sfid-20170607_235731_130722_755C7167)
Subject: Re: [PATCH 1/1] mac80211: ieee80211_rx_napi: remove warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Erik Stromdahl <erik.stromdahl@gmail.com>, kvalo@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Wed, 07 Jun 2017 23:57:22 +0200
In-Reply-To: <1496581915-4412-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20170604_151234_601164_C284D202)
References: <1496581915-4412-1-git-send-email-erik.stromdahl@gmail.com>
         <1496581915-4412-2-git-send-email-erik.stromdahl@gmail.com>
         (sfid-20170604_151234_601164_C284D202)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-06-04 at 15:11 +0200, Erik Stromdahl wrote:
> The softirq count is not always incremented during driver
> operation. This is the case for usb and sdio network
> drivers.

I'm pretty sure the warning is correct, and we do rely on having
local_bh_disable(), otherwise we may end up taking a soft-IRQ and I
believe there are some things that could get messed up in that case.

So - I think the warning is there for a reason, and drivers should just
local_bh_disable() before calling into that. What's wrong with that?

johannes
