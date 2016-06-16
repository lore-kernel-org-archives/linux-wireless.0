Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57016 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbcFPPGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:06:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wl3501_cs: avoid bogus gcc-6 warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <4731273.LDpWBaOjNT@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160616150654.83BA46141C@smtp.codeaurora.org> (sfid-20160616_170713_354055_BA7635D7)
Date: Thu, 16 Jun 2016 15:06:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
> gcc-6 on x86 started warning about wl3501_get_encode when building
> with -O2:
> 
> drivers/net/wireless/wl3501_cs.c: In function ‘wl3501_get_encode’:
> drivers/net/wireless/wl3501_cs.c:1769:5: warning: ‘implemented’ may be used uninitialized in this function
> drivers/net/wireless/wl3501_cs.c:1686:19: warning: ‘threshold’ may be used uninitialized in this function
> drivers/net/wireless/wl3501_cs.c:1702:20: warning: ‘threshold’ may be used uninitialized in this function
> drivers/net/wireless/wl3501_cs.c:1719:23: warning: ‘txpow’ may be used uninitialized in this function
> drivers/net/wireless/wl3501_cs.c:1752:20: warning: ‘retry’ may be used uninitialized in this function
> drivers/net/wireless/wl3501_cs.c:1806:25: warning: ‘pwr_state’ may be used uninitialized in this function
> drivers/net/wireless/wl3501_cs.c:1383:24: warning: ‘value’ may be used uninitialized in this function
> 
> I could not figure out what exactly confuses gcc here, but splitting the
> wl3501_get_mib_value function into two helps the compiler to figure out
> that the variables are not actually used uninitialized, and makes it
> slightly clearer to a human reader what the function actually does and
> which parts of it are under the spinlock.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, 1 patch applied to wireless-drivers-next.git:

2683f7dd9aad wl3501_cs: avoid bogus gcc-6 warning

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9138643/

