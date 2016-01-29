Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41624 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcA2JO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 04:14:26 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/3] mwifiex: firmware download enhancements
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1452152449-29803-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160129091425.73F1C6045B@smtp.codeaurora.org> (sfid-20160129_101432_613647_7CFD4EC2)
Date: Fri, 29 Jan 2016 09:14:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: chunfan chen <jeffc@marvell.com>
> 
> Same chip is being used by WLAN as well as bluetooth
> drivers. Each driver needs to check during initialisation
> if firmware is already active or it needs to be freshly
> downloaded. If one driver has started downloading the
> firmware, other finds the winner flag as false.
> 
> mwifiex_check_fw_status() checks firmware status and also
> check if WLAN is the winner for firmware downloading.
> 
> Once we detect that other interface is downloading
> the firmware, we call this routine again with max
> poll count to wait until firmware is ready.
> 
> This patch splits the routine to avoid checking
> winner status unnecessarily multiple times and ensures
> that correct messages are displayed to user.
> 
> Firmware status poll count is also increased to 150.
> 
> Signed-off-by: Chunfan Chen <jeffc@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

2fd5c6ed0b4f mwifiex: firmware download enhancements
dc386ce76ded mwifiex: fix IBSS data path issue.
17934b6a32b2 mwifiex: add debugfs file to read chip information

Kalle Valo
