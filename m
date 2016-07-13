Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50874 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbcGMPPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 11:15:03 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 2/2] mwifiex: add hostcmd wext ioctl support
References: <1468417703-32716-1-git-send-email-akarwar@marvell.com>
	<1468417703-32716-2-git-send-email-akarwar@marvell.com>
Date: Wed, 13 Jul 2016 18:14:28 +0300
In-Reply-To: <1468417703-32716-2-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Wed, 13 Jul 2016 19:18:23 +0530")
Message-ID: <87y455a7u3.fsf@purkki.adurom.net> (sfid-20160713_171532_830488_181F6F4B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> This patch adds ndo_ioctl support to mwifiex netdev handlers.
> This will be used to download hostcmds to firmware from userspace.
> This is needed for manufacturing mode support in mwifiex. ndo_ioctl
> is allowed only when mfg mode is enabled via module load parameters.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v3: Add "select WIRELESS_EXT" in Kconfig to resolve kbuild test robot errors.
>     WEXT_PRIV seems to have a dependency with WIRELESS_EXT.
> v2: 1) Sequence of these two patches are changed to resolve compilation
>     error seen if only 1/2 is applied.
>     2) Add "select WEXT_PRIV" in Kconfig to resolve warnings reported by
>     kbuild test robot.

Why can't you use nl80211 testmode interface?

-- 
Kalle Valo
