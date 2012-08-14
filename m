Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12048 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab2HNOVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 10:21:25 -0400
Message-ID: <502A5EDC.6070704@qca.qualcomm.com> (sfid-20120814_162129_784782_5932F9C7)
Date: Tue, 14 Aug 2012 17:21:16 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: configure wow filters per-vif
References: <1344558753-20253-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1344558753-20253-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2012 03:32 AM, Thomas Pedersen wrote:
> Only WoW filters for the first vif were being set, causing failures to
> wake up on any concurrent connected vifs. Handle all per-vif suspend
> and resume tasks.
> 
> Since cfg80211 issues user wow filters on a per-wiphy basis, set any
> custom filters on all connected vifs.
> 
> Starting WoW in firmware and setting host sleep mode is still handled on
> a global per-phy level. The first vif is always used for bookkeeping
> regardless of whether it is connected or not.
> 
> WoW is cancelled if no connected vifs are found.
> 
> No firmware capability bits or API bump is needed for this patch, as
> setting filters for vifs with index > 0 will simply overwrite the index
> 0 filters in the current implementation. While not correct, this is
> identical to the existing behavior.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle

