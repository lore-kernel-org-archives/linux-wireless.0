Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44436 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbcLGMAh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 07:00:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Pan Bian <bianpan2016@163.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: wireless: intersil: fix improper return value
References: <1480760572-4444-1-git-send-email-bianpan2016@163.com>
Date: Wed, 07 Dec 2016 14:00:31 +0200
In-Reply-To: <1480760572-4444-1-git-send-email-bianpan2016@163.com> (Pan
        Bian's message of "Sat, 3 Dec 2016 18:22:52 +0800")
Message-ID: <8760mwdk4g.fsf@kamboji.qca.qualcomm.com> (sfid-20161207_130100_619388_D048CD15)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pan Bian <bianpan2016@163.com> writes:

> Function orinoco_ioctl_commit() returns 0 (indicates success) when the
> call to orinoco_lock() fails. Thus, the return value is inconsistent with
> the execution status. It may be better to return "-EBUSY" when the call 
> to orinoco_lock() fails.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188671
>
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/net/wireless/intersil/orinoco/wext.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please use prefix "orinoco:", more info:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject_name

-- 
Kalle Valo
