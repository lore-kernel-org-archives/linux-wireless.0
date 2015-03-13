Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51290 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbCMOHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 10:07:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [next] ar5523: use container_of
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1425997539-25206-1-git-send-email-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Message-Id: <20150313140749.B266A1415F0@smtp.codeaurora.org> (sfid-20150313_150759_413325_97BD9641)
Date: Fri, 13 Mar 2015 14:07:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> If we want to shrink skb->cb then we'd have to see about
> reducing struct ieee80211_tx_info, which gets embedded inside
> skb->cb[].
> 
> It provides a scratch space to be used by wireless drivers.
> ar5523 uses the maximum space available today (40 bytes), but it seems
> we don't need this -- data->skb pointer seems to always point back to the
> skb whose cb buffer the data structure resides, iow, given a pointer to the
> embedded control buffer we can infer the skb address.
> 
> Tested-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
