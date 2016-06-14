Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59906 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbcFNOZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:25:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix racing condition when downloading firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463630023-5258-1-git-send-email-wnhuang@chromium.org>
To: Wei-Ning Huang <wnhuang@chromium.org>
Cc: Linux-Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, akarwar@marvell.com,
	djkurtz@chromium.org, Wei-Ning Huang <wnhuang@chromium.org>
Message-Id: <20160614142519.AB5F2613E0@smtp.codeaurora.org> (sfid-20160614_162556_598496_AB6E1222)
Date: Tue, 14 Jun 2016 14:25:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei-Ning Huang <wnhuang@chromium.org> wrote:
> The action 'check for winner' and 'download firmware' should be an
> atomic action. This is true for btmrvl driver but not mwmfiex, which
> cause firmware download to fail when the following senerio happens:
> 
> 1) mwifiex check winner status: true
> 2) btmrvl check winner status: true, and start downloading firmware
> 3) mwfieix tries to download firmware, but failed because btmrvl is
> already downloading.
> 
> This won't happen if 1) and 3) is an atomic action. This patch adds
> sdio_claim/release_host call around those two actions to make sure it's
> atomic.
> 
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>

Thanks, 1 patch applied to wireless-drivers-next.git:

65c71efe1c59 mwifiex: fix racing condition when downloading firmware

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9123771/

