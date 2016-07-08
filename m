Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14055 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbcGHGhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 02:37:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath10k: Fix 10.4 extended peer stats update
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1464851602-12969-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <d69d17f6b281447d8a26994a0a1a2772@euamsexm01a.eu.qualcomm.com> (sfid-20160708_083737_941172_BC850A45)
Date: Fri, 8 Jul 2016 08:37:25 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> 10.4 'extended peer stats' will be not be appended with normal peer stats
> data and they shall be coming in separate chunks. Fix this by maintaining
> a separate linked list 'extender peer stats' for 10.4 and update
> rx_duration for per station statistics. Also parse through beacon filter
> (if enabled), to make sure we parse the extended peer stats properly.
> This issue was exposed when more than one client is connected and
> extended peer stats for 10.4 is enabled
> 
> The order for the stats is as below
> S - standard peer stats, E- extended peer stats, B - beacon filter stats
> 
> {S1, S2, S3..} -> {B1, B2, B3..}(if available) -> {E1, E2, E3..}
> 
> Fixes: f9575793d44c ("ath10k: enable parsing per station rx duration for 10.4")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

4a49ae94a448 ath10k: fix 10.4 extended peer stats update

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9149357/

