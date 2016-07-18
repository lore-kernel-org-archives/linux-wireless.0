Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40137 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbcGRTdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:33:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4] mwifiex: Reduce endian conversion for REG Host Commands
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467022402-23990-1-git-send-email-prasunmaiti87@gmail.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Message-Id: <20160718193314.3B9A26043B@smtp.codeaurora.org> (sfid-20160718_213333_831406_59837BB2)
Date: Mon, 18 Jul 2016 19:33:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prasun Maiti <prasunmaiti87@gmail.com> wrote:
> For multiple REG Host Commands (e.g HostCmd_CMD_802_11_EEPROM_ACCESS,
> HostCmd_CMD_MAC_REG_ACCESS etc.) "cpu_to_leX"-converted values are
> saved to driver. So, "leX_to_cpu" conversion is required too many
> times afterwards in driver.
> 
> This patch reduces the endian: conversion without saving "cpu_to_leX"
> converted values in driver. This will convert endianness in prepare
> command and command response path.
> 
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

8cfb86003dbf mwifiex: Reduce endian conversion for REG Host Commands

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9200265/

