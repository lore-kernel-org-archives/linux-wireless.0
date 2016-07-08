Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39640 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbcGHJzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 05:55:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Create _rtl_dbg_trace function to reduce RT_TRACE code
 size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <90cd7c8f12b51571db565fd496a2fcf610e2e484.1466894688.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160708095542.49BF460239@smtp.codeaurora.org> (sfid-20160708_115609_810976_36B24A7C)
Date: Fri,  8 Jul 2016 09:55:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> wrote:
> This debugging macro can expand to a lot of code.
> Make it a function to reduce code size.
> 
> (x86-64 defconfig w/ all rtlwifi drivers and allyesconfig)
> $ size drivers/net/wireless/realtek/rtlwifi/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  900083	 200499	   1907	1102489	 10d299	drivers/net/wireless/realtek/rtlwifi/built-in.o.defconfig.new
> 1113597	 200499	   1907	1316003	 1414a3	drivers/net/wireless/realtek/rtlwifi/built-in.o.defconfig.old
> 1746879	 453503	   8512	2208894	 21b47e	drivers/net/wireless/realtek/rtlwifi/built-in.o.new
> 2051965	 503311	   8512	2563788	 271ecc	drivers/net/wireless/realtek/rtlwifi/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 1 patch applied to wireless-drivers-next.git:

9ce221915a94 rtlwifi: Create _rtl_dbg_trace function to reduce RT_TRACE code size

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9198897/

