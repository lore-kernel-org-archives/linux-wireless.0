Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755058AbeDPODp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 10:03:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH 5/5] wcn36xx: pass information elements in scan requests
References: <20180416131634.25432-1-daniel@zonque.org>
        <20180416131634.25432-6-daniel@zonque.org>
Date: Mon, 16 Apr 2018 17:03:41 +0300
In-Reply-To: <20180416131634.25432-6-daniel@zonque.org> (Daniel Mack's message
        of "Mon, 16 Apr 2018 15:16:34 +0200")
Message-ID: <87lgdnp7sy.fsf@kamboji.qca.qualcomm.com> (sfid-20180416_160349_136488_2F762707)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

> When the ieee8022 core passes IE elements in the scan request, append

You mean mac80211?

And yeah, the ieee80211_ prefix is confusing. Many many years I
started to change that to mac80211_ but gave up :(

> them to the firmware message. The driver currently tells the core that
> it is capable of attaching up to WCN36XX_MAX_SCAN_IE_LEN octets, but
> doesn't actually pass them to the the hardware.
>
> Some defines were moved around to avoid cyclic include dependencies.

Does this fix anything or change functionality somehow? You should
document that also in the commit log.

-- 
Kalle Valo
