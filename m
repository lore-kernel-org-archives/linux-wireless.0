Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeGaJGA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:06:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] rtl818x: Replace mdelay() with msleep() in
 rtl8225se_rf_init
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180727085045.3949-1-baijiaju1990@gmail.com>
References: <20180727085045.3949-1-baijiaju1990@gmail.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Message-Id: <20180731072703.6141960708@smtp.codeaurora.org> (sfid-20180731_092722_800170_C96C9B52)
Date: Tue, 31 Jul 2018 07:27:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> rtl8225se_rf_init() is never called in atomic context.
> It calls mdelay() to busily wait, which is not necessary.
> mdelay() can be replaced with msleep().
> This patch only replaces the mdelay() that has >20ms time to wait.
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

622e938240db rtl818x: Replace mdelay() with msleep() in rtl8225se_rf_init

-- 
https://patchwork.kernel.org/patch/10546749/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
