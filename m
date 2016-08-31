Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57402 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756123AbcHaHcP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 03:32:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] wil6210: fix protection of wil->scan_request
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1471858942-23766-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Lior David <qca_liord@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <0f6311c697f74bc2a804f09dff4c7a95@euamsexm01a.eu.qualcomm.com> (sfid-20160831_093221_646446_A2B7E7EE)
Date: Wed, 31 Aug 2016 09:31:43 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Lior David <qca_liord@qca.qualcomm.com>
> 
> Currently the places that check wil->scan_request and
> call cfg80211_scan_done are not consistently protected,
> so there is a risk that cfg80211_scan_done will be called
> with NULL scan_request, causing a kernel crash.
> Fix this by using p2p_wdev_mutex in few other places
> that access scan_request. This makes sense since
> scan_request may point to p2p_wdev, and it is not worth
> the extra complexity of adding a new mutex.
> 
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Thanks, 4 patches applied to ath-next branch of ath.git:

5ffae43208ec wil6210: fix protection of wil->scan_request
08989f9640a0 wil6210: align to latest auto generated wmi.h
12bace75704e wil6210: extract firmware capabilities from FW file
13cd9f758a55 wil6210: extract firmware version from file header

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9293303/
