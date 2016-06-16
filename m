Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56144 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcFPPCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:02:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wei-Ning Huang <wnhuang@chromium.org>
Cc: Linux-Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, akarwar@marvell.com,
	djkurtz@chromium.org
Subject: Re: [PATCH v2] mwifiex: fix race condition when downloading firmware
References: <1464352059-13923-1-git-send-email-wnhuang@chromium.org>
Date: Thu, 16 Jun 2016 18:02:30 +0300
In-Reply-To: <1464352059-13923-1-git-send-email-wnhuang@chromium.org>
	(Wei-Ning Huang's message of "Fri, 27 May 2016 20:27:38 +0800")
Message-ID: <87bn31w515.fsf@kamboji.qca.qualcomm.com> (sfid-20160616_170311_003353_69EB2A49)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei-Ning Huang <wnhuang@chromium.org> writes:

> The action 'check for winner' and 'download firmware' should be an
> atomic action. This is true for btmrvl driver but not mwmfiex, which
> cause firmware download to fail when the following scenario happens:
>
> 1) mwifiex check winner status: true
> 2) btmrvl check winner status: true, and start downloading firmware
> 3) mwifiex tries to download firmware, but failed because btmrvl is
> already downloading.
>
> This won't happen if 1) and 3) is an atomic action. This patch adds
> sdio_claim/release_host call around those two actions to make sure it's
> atomic.
>
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>

As I accidentally applied v1, I need to drop this one.

-- 
Kalle Valo
