Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:54682 "EHLO plaes.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751671AbbCVRFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 13:05:33 -0400
Message-ID: <1427043900.14656.2.camel@plaes.org> (sfid-20150322_180558_284753_7C4503BD)
Subject: Re: [PATCH v2 0/4] rtlwifi: Use common functions for driver stats
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Chaoming Li <chaoming_li@realsil.com.cn>,
	Joe Perches <joe@perches.com>
Date: Sun, 22 Mar 2015 19:05:00 +0200
In-Reply-To: <550EED87.8010008@lwfinger.net>
References: <1427031320-10913-1-git-send-email-plaes@plaes.org>
	 <550EED87.8010008@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-03-22 at 11:27 -0500, Larry Finger wrote:
> On 03/22/2015 08:35 AM, Priit Laes wrote:
> > Hi all,
> > 
> > This is a small fixup to unify make the drivers use common helper
> > functions for driver statistics.
> > 
> > There are no functional changes since the first posting, except 
> > dropping
> > patches already applied and addressing the comments by Joe Perches.
> 
> Are there patches that are required before these work? Applying 
> these four 
> results in the following build errors:

Oops. I'll figure out what went wrong.
> 
> drivers/net/wireless/rtlwifi/rtl8192de/trx.c: In function 
> ‘_rtl92de_query_rxphystatus’:
> drivers/net/wireless/rtlwifi/rtl8192de/trx.c:132:3: error: implicit 
> declaration 
> of function ‘rtl_query_rxpwrpercentage’ [-Werror=implicit-function-
> declaration]
>     pwdb_all = rtl_query_rxpwrpercentage(rx_pwr_all);
>     ^
> drivers/net/wireless/rtlwifi/rtl8192de/trx.c:192:4: error: implicit 
> declaration 
> of function ‘rtl_evm_db_to_percentage’ [-Werror=implicit-function-
> declaration]
>      evm = rtl_evm_db_to_percentage(p_drvinfo->rxevm[i]);
>      ^
> drivers/net/wireless/rtlwifi/rtl8192de/trx.c:204:4: error: implicit 
> declaration 
> of function ‘rtl_signal_scale_mapping’ [-Werror=implicit-function-
> declaration]
>      (u8)(rtl_signal_scale_mapping(pwdb_all));
>      ^
> cc1: some warnings being treated as errors
> scripts/Makefile.build:258: recipe for target 
> 'drivers/net/wireless/rtlwifi/rtl8192de/trx.o' failed
> 
> I cannot find any patches that created common routines in rtlwifi.
> 
> Larry
> 
