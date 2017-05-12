Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36757 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757714AbdELOBT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 10:01:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [7/7] wil6210: low level RF sector API
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1477720287-17606-8-git-send-email-qca_merez@qca.qualcomm.com>
References: <1477720287-17606-8-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Lior David <qca_liord@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <d1c2f4300d4843239e5339b0fa6a2e2f@euamsexm01a.eu.qualcomm.com> (sfid-20170512_160234_432283_C519A72B)
Date: Fri, 12 May 2017 16:01:11 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Lior David <qca_liord@qca.qualcomm.com>
> 
> Added vendor commands for low level control over
> RF sectors. It allows user space a fine-grained control
> over RF characteristics for TX and RX, such as direction
> and gain of TX/RX. Main usages are debugging and diagnostics,
> but also operational use cases.
> API includes getting/setting a specific RF sector
> configuration, as well as getting/setting the selected
> sector which is used to communicate with a station.
> 
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Sorry for taking so long to get back to this. I was still able to apply the
patch to my pending branch, only the nla_parse() interface had changed but that
was a simple fix:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=d31df2dcc53e4901d4c26de45f4877fbd8783124

But when I started to look this more closely I don't see wiphy->vendor_commands
set anywhere, did you forgot to set that?

-- 
https://patchwork.kernel.org/patch/9403071/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
