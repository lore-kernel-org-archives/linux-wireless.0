Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23156 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2H3JSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 05:18:17 -0400
Message-ID: <503F2FC3.8010903@qca.qualcomm.com> (sfid-20120830_111820_625345_77F1FB1F)
Date: Thu, 30 Aug 2012 12:17:55 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dengke Qiu <dqiu@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl:link speed is 0Mbps sometimes
References: <y> <1346139222-3102-1-git-send-email-dqiu@qca.qualcomm.com>
In-Reply-To: <1346139222-3102-1-git-send-email-dqiu@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/2012 10:33 AM, Dengke Qiu wrote:
> The MSB of rate index from FW is used for sgi. But the ath6kl_wmi_get_rate
> doesn't handle it. The access to wmi_rate_tbl array may be out of range
> if sgi is 1. This may cause the return value of ath6kl_wmi_get_rate()
> function is incorrect link rate. We add sgi adjustment to avoid such case.
> 
> Signed-off-by: Dengke Qiu <dqiu@qca.qualcomm.com>

Thanks, applied. But I changed the title to better reflect what's changed:

ath6kl: fix link speed when using sgi

Kalle
