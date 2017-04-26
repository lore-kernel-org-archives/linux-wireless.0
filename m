Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36900 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1955928AbdDZJrD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 05:47:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RESEND] ath10k: fix out of bounds access to local buffer
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170424071157.6979-1-dev@michaelmera.com>
References: <20170424071157.6979-1-dev@michaelmera.com>
To: Michael Mera <dev@michaelmera.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Michael Mera" <dev@michaelmera.com>
Message-ID: <0a7aa133740b4488a19bd95115831988@euamsexm01a.eu.qualcomm.com> (sfid-20170426_114929_990909_6F73010F)
Date: Wed, 26 Apr 2017 11:46:22 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Mera <dev@michaelmera.com> wrote:
> During write to debugfs file simulate_fw_crash, fixed-size local buffer
> 'buf' is accessed and modified at index 'count-1', where 'count' is the
> size of the write (so potentially out of bounds).
> This patch fixes this problem.
> 
> Signed-off-by: Michael Mera <dev@michaelmera.com>

I fixed a checkpatch warning in the pending branch:

drivers/net/wireless/ath/ath10k/debug.c:636: spaces preferred around that '-' (ctx:VxV)

-- 
https://patchwork.kernel.org/patch/9695703/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
