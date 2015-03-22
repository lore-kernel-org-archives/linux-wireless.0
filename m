Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34819 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbbCVQ1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 12:27:54 -0400
Message-ID: <550EED87.8010008@lwfinger.net> (sfid-20150322_173210_045852_CCB6D78A)
Date: Sun, 22 Mar 2015 11:27:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Priit Laes <plaes@plaes.org>, Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 0/4] rtlwifi: Use common functions for driver stats
References: <1427031320-10913-1-git-send-email-plaes@plaes.org>
In-Reply-To: <1427031320-10913-1-git-send-email-plaes@plaes.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/2015 08:35 AM, Priit Laes wrote:
> Hi all,
>
> This is a small fixup to unify make the drivers use common helper
> functions for driver statistics.
>
> There are no functional changes since the first posting, except dropping
> patches already applied and addressing the comments by Joe Perches.

Are there patches that are required before these work? Applying these four 
results in the following build errors:

drivers/net/wireless/rtlwifi/rtl8192de/trx.c: In function 
‘_rtl92de_query_rxphystatus’:
drivers/net/wireless/rtlwifi/rtl8192de/trx.c:132:3: error: implicit declaration 
of function ‘rtl_query_rxpwrpercentage’ [-Werror=implicit-function-declaration]
    pwdb_all = rtl_query_rxpwrpercentage(rx_pwr_all);
    ^
drivers/net/wireless/rtlwifi/rtl8192de/trx.c:192:4: error: implicit declaration 
of function ‘rtl_evm_db_to_percentage’ [-Werror=implicit-function-declaration]
     evm = rtl_evm_db_to_percentage(p_drvinfo->rxevm[i]);
     ^
drivers/net/wireless/rtlwifi/rtl8192de/trx.c:204:4: error: implicit declaration 
of function ‘rtl_signal_scale_mapping’ [-Werror=implicit-function-declaration]
     (u8)(rtl_signal_scale_mapping(pwdb_all));
     ^
cc1: some warnings being treated as errors
scripts/Makefile.build:258: recipe for target 
'drivers/net/wireless/rtlwifi/rtl8192de/trx.o' failed

I cannot find any patches that created common routines in rtlwifi.

Larry

