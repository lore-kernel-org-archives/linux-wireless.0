Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35247 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbdHaEsm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 00:48:42 -0400
Subject: Re: [PATCH] rtlwifi: btcoex: 23b 1ant: fix duplicated code for
 different branches
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170830134223.GA13596@embeddedgus>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <ae09e952-112e-9616-735a-b86ba01ad398@lwfinger.net> (sfid-20170831_064902_919995_99B37E31)
Date: Wed, 30 Aug 2017 23:48:40 -0500
MIME-Version: 1.0
In-Reply-To: <20170830134223.GA13596@embeddedgus>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2017 08:42 AM, Gustavo A. R. Silva wrote:
> Refactor code in order to avoid identical code for different branches.
> 
> This issue was detected with the help of Coccinelle.
> 
> Addresses-Coverity-ID: 1226788
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> This issue was reported by Coverity and it was tested by compilation only.
> I'm suspicious this may be a copy/paste error. Please, verify.
> 
>   .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c   | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)

This change is not correct. When bt_link_info->sco_exist is true, the call should be

				halbtc8723b1ant_limited_rx(btcoexist,
							   NORMAL_EXEC, true,
							   false, 0x5);

NACK

I will push the correct patch.

Larry
