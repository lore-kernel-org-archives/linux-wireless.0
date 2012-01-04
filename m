Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58977 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab2ADJsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 04:48:46 -0500
Message-ID: <4F042078.5040902@qca.qualcomm.com> (sfid-20120104_104851_316830_D4A82B2C)
Date: Wed, 4 Jan 2012 11:48:40 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <linville@tuxdriver.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	David Miller <davem@davemloft.net>,
	<linux-next@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: force building as a module
References: <20120104094134.28754.39652.stgit@x201>
In-Reply-To: <20120104094134.28754.39652.stgit@x201>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/04/2012 11:41 AM, Kalle Valo wrote:
> Stephen reported that ath6kl fails if both sdio and usb are built
> into the kernel:
> 
> ath6kl/cfg80211.c:27:1: error: expected ')' before 'KBUILD_MODNAME'
> ath6kl/cfg80211.c:27:1: error: 'KBUILD_MODNAME' undeclared here (not in a function)
> ath6kl/cfg80211.c:27:1: error: expected ',' or ';' before string constant
> 
> As a temporary fix make ath6kl build only as a module. This will be reverted
> once a separate ath6kl core module is implemented which will fix this
> properly.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Sorry, forgot to CC people. The original patch is here:

http://marc.info/?l=linux-wireless&m=132567025132302&w=2

John, can you please take this directly so that the build problem gets
fixed quickly? I will also apply it to ath6kl.git but that should not
create any merge problems.

Kalle
