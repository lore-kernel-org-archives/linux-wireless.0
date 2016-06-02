Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20200 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754AbcFBOwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 10:52:01 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath10k: Fix error while writing 'simulate_fw_crash' debugfs
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1464251262-4889-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	"Maharaja Kennadyrajan" <c_mkenna@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <413fd4df25784a74af69dc37eceeefe0@euamsexm01a.eu.qualcomm.com> (sfid-20160602_165206_385621_CC086636)
Date: Thu, 2 Jun 2016 16:51:53 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Fix invalid argument error while writing 'simulate_fw_crash',
> though the funcionality is working fine we get an error 'invalid
> argument' because 'count' value is not returned properly
> (no reason to reduce the count value for removing the newline)
> 
> Fixes the below write error:
> 
> /sys/kernel/debug/ieee80211/phy0/ath10k# echo hw-restart >
> simulate_fw_crash
> -bash: echo: write error: Invalid argument
> 
> Also move the 'conf_mutex' as it is really not required for
> fetching the userspace buffer.
> 
> Reported-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

Thanks, 1 patch applied to ath.git:

f5e307515b2b ath10k: fix error while writing 'simulate_fw_crash' debugfs

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9136787/

