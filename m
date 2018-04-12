Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbeDLEXm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 00:23:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: rkir@google.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        bjoernj@google.com, lfy@google.com,
        Roman Kiryanov <rkir@google.com>
Subject: Re: [PATCH] ANDROID: mac80211_hwsim: support/ignore power state changes
References: <20180411184156.167978-1-rkir@google.com>
Date: Thu, 12 Apr 2018 07:23:37 +0300
In-Reply-To: <20180411184156.167978-1-rkir@google.com> (rkir@google.com's
        message of "Wed, 11 Apr 2018 11:41:56 -0700")
Message-ID: <87bmepjbna.fsf@purkki.adurom.net> (sfid-20180412_062349_237833_7EF73534)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rkir@google.com writes:

> From: Bjoern Johansson <bjoernj@google.com>
>
> Indicate support for power state changes and handle them by calling an
> empty function.
> The important part is "ieee80211_hw_set(hw, SUPPORTS_PS);" at the
> bottom of the diff. Without this upper layers in the kernel will return an
> error code when trying to set the power state because the driver doesn't
> indicate power state support. This in turn causes VTS
> (Android Vendor Test Suite) failures because the WiFi HAL can't enable
> power saving mode. The remaining code is just there to deal with the
> incoming state change request.
>
> Signed-off-by: Bjoern Johansson <bjoernj@google.com>
> Signed-off-by: Lingfeng Yang <lfy@google.com>
> Signed-off-by: Roman Kiryanov <rkir@google.com>

Why the odd "ANDROID:" prefix?

-- 
Kalle Valo
