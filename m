Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34771 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbbHRGEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 02:04:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwl8k: refactor some conditionals for clarity
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1439222739-24545-1-git-send-email-linville@tuxdriver.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <20150818060407.6F9E6140390@smtp.codeaurora.org> (sfid-20150818_080411_896151_F8226CC4)
Date: Tue, 18 Aug 2015 06:04:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> CC [M]  drivers/net/wireless/mwl8k.o
> drivers/net/wireless/mwl8k.c: In function ‘mwl8k_bss_info_changed’:
> drivers/net/wireless/mwl8k.c:3290:2: warning: ‘ap_mcs_rates’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   memcpy(cmd->mcs_set, mcs_rates, 16);
>   ^
> drivers/net/wireless/mwl8k.c:4987:5: note: ‘ap_mcs_rates’ was declared here
>   u8 ap_mcs_rates[16];
>      ^
> 
> The warning was bogus.  But the conditionals were rather complicated,
> with multiple redundant checks.  This consolidates the checking and
> makes it more readable IMHO.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
