Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39745 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbcF2Pu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:50:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: use s8 instead of char
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <4937395.5geC2TFNE0@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Message-Id: <20160629154857.E131B611F1@smtp.codeaurora.org> (sfid-20160629_175103_988409_4B8F1D03)
Date: Wed, 29 Jun 2016 15:48:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
> Compiling the rtlwifi drivers for ARM with gcc -Wextra warns about lots of
> incorrect code that results from 'char' being unsigned here, e.g.
> 
> realtek/rtlwifi/rc.c:113:18: error: comparison is always true due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8188ee/dm.c:1070:22: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8192ce/trx.c:54:16: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8192cu/mac.c:601:16: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8192de/trx.c:53:16: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8192ee/phy.c:1268:12: error: comparison is always true due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8192se/rf.c:150:20: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8723be/dm.c:877:29: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8723be/phy.c:386:16: error: comparison is always true due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8821ae/dm.c:1514:38: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8821ae/phy.c:1558:11: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8821ae/phy.c:386:24: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/rtl8821ae/trx.c:55:12: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> realtek/rtlwifi/stats.c:31:16: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> 
> This patch changes all uses of 'char' in this driver that refer to
> 8-bit integers to use 's8' instead, which is signed on all architectures.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, 1 patch applied to wireless-drivers-next.git:

08aba42fcc7e rtlwifi: use s8 instead of char

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9179539/

