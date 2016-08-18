Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41141 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946825AbcHRN0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2016 09:26:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix large amsdu packets causing firmware hang
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469098824-8031-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160818130223.AE95961C2C@smtp.codeaurora.org> (sfid-20160818_152649_551418_36AB5803)
Date: Thu, 18 Aug 2016 13:02:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Cathy Luo <cluo@marvell.com>
> 
> Sometimes host prepares and downloads a large amsdu packet to firmware
> which leads to a memory corruption in firmware.
> The reason is __dev_alloc_skb() may allocate larger buffer than required
> size. This patch solves the problem by checking "adapter->tx_buf_size"
> instead of relying on skb_tailroom().
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers.git:

c81396f3da22 mwifiex: fix large amsdu packets causing firmware hang

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9241469/
