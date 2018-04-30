Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeD3KXA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:23:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] mt76: fix concurrent rx calls on A-MPDU release
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180425091124.909-1-nbd@nbd.name>
References: <20180425091124.909-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180430102259.9B3E360588@smtp.codeaurora.org> (sfid-20180430_122303_546868_FA711960)
Date: Mon, 30 Apr 2018 10:22:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Add a spinlock in mt76_rx_complete. Without this, multiple stats updates
> could happen in parallel, which can lead to deadlocks. There are
> probably more corner cases fixed by this change.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

4 patches applied to wireless-drivers-next.git, thanks.

c3d7c82a8bb0 mt76: fix concurrent rx calls on A-MPDU release
9febfa67ca15 mt76: add rcu locking in tid reorder function
1d868b70e06a mt76: add rcu locking around tx scheduling
95135e8c0b4a mt76: check for pending reset before attempting to schedule tx

-- 
https://patchwork.kernel.org/patch/10361963/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
