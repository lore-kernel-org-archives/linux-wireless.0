Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35062 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754052AbdETPBZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 11:01:25 -0400
Subject: Re: [PATCH] rtlwifi: btcoex: 23b 1ant: fix
 halbtc8723b1ant_action_wifi_only()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20170520053343.gwdinyn447bwpia2@mwanda>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <643aa5f9-5634-d910-e10f-51523e464b50@lwfinger.net> (sfid-20170520_170131_461304_46A2B695)
Date: Sat, 20 May 2017 10:01:24 -0500
MIME-Version: 1.0
In-Reply-To: <20170520053343.gwdinyn447bwpia2@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/2017 12:33 AM, Dan Carpenter wrote:
> The parameters are in the wrong order when we call
> halbtc8723b1ant_set_ant_path() so it's equivalent of calling:
> 
> 	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_WIFI, false, true);
> 
> Fixes: f66509e3d7c2 ("rtlwifi: btcoex: Remove 23b 1ant configuration parameter")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Now I know why I did not see the Sparse error. This problem was fixed in 
https://patchwork.kernel.org/patch/9737583/, which is waiting to be merged. Once 
that one is merged, this patch will no longer apply.

NACK.

Larry
