Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2107 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932436AbcHVQI0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 12:08:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4.8] ath9k: fix using sta->drv_priv before initializing it
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160802110322.38359-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <4b1b967ced10485a9a0fc3a69e26dfc9@euamsexm01a.eu.qualcomm.com> (sfid-20160822_180954_255105_B73CB485)
Date: Mon, 22 Aug 2016 18:08:19 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> A station pointer can be passed to the driver on tx, before it has been
> marked as associated. Since ath9k_sta_state was initializing the entry
> too late, it resulted in some spurious crashes.
> 
> Fixes: df3c6eb34da5 ("ath9k: Use sta_state() callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Thanks, 1 patch applied to ath-current branch of ath.git:

7711aaf08ad3 ath9k: fix using sta->drv_priv before initializing it

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9255463/
