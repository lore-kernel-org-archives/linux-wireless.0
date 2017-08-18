Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35267 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdHRNJq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 09:09:46 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtlwifi: make a couple arrays larger
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Maxim Samoylov <max7255@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20170818080519.mvjls5pgnxeknzpk@mwanda>
Message-ID: <a3aeacec-750a-aca3-2943-e13d57e7539a@lwfinger.net> (sfid-20170818_150949_813766_1355050E)
Date: Fri, 18 Aug 2017 08:09:43 -0500
MIME-Version: 1.0
In-Reply-To: <20170818080519.mvjls5pgnxeknzpk@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/18/2017 03:05 AM, Dan Carpenter wrote:
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
> ---
> I'm pretty sure this patch is correct and absolutely harmless.  But the
> code is pretty involved and I didn't test it.  So you may want to review
> this one carefully.

I believe the patch is correct. In testing, I also confirmed that this branch is 
executed, thus the memory corruption does happen.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry
