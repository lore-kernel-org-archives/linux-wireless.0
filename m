Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33612 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdHXJyK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 05:54:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: make a couple arrays larger
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170818080519.mvjls5pgnxeknzpk@mwanda>
References: <20170818080519.mvjls5pgnxeknzpk@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Maxim Samoylov <max7255@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20170824095410.1E2B9606B7@smtp.codeaurora.org> (sfid-20170824_115413_413940_4B05CB76)
Date: Thu, 24 Aug 2017 09:54:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This is a static checker fix.  "cal_num" is 10.  We're declaring the
> tx_dt[] and rx_td[] arrays as 3 element arrays.  The static checker
> complains that we do:
> 
> 	tx_dt[cal] = (vdf_y[1]>>20)-(vdf_y[0]>>20);
> 
> "cal" is the iterator and it is in the 0-9 range so it looks like
> we could corrupt memory.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

d9ee6015e573 rtlwifi: make a couple arrays larger

-- 
https://patchwork.kernel.org/patch/9907821/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
