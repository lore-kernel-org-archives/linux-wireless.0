Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32363 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936122AbcKWOvQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 09:51:16 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/7] wil6210: fix net queue stop/wake
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1477720287-17606-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1477720287-17606-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Dedy Lansky <qca_dlansky@qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <ca3e82a71958458c92e6c0b3701191cf@euamsexm01a.eu.qualcomm.com> (sfid-20161123_155149_295056_0029AF82)
Date: Wed, 23 Nov 2016 15:51:08 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
> 
> Driver calls to netif_tx_stop_all_queues/netif_tx_wake_all_queues are
> inconsistent. In several cases, driver can get to a situation where net
> queues are stopped forever and data cannot be sent.
> 
> The fix is to stop net queues if there is at least one vring which is
> "full" and to wake net queues if all vrings are not "full".
> 
> Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

6 patches applied to ath-next branch of ath.git, thanks.

f9e3033ff7eb wil6210: fix net queue stop/wake
2c207eb8e6ab wil6210: add support for power save enable / disable
dfb5b098e0f4 wil6210: fix deadlock when using fw_no_recovery option
035859a5117b wil6210: add support for abort scan
cbf795c195fb wil6210: align to latest auto generated wmi.h
3fea18d079e2 wil6210: support NL80211_ATTR_WIPHY_RETRY_SHORT

-- 
https://patchwork.kernel.org/patch/9403059/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
