Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59995 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbcC2IiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 04:38:03 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wei-Ning Huang <wnhuang@chromium.org>
Cc: linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>, snanda@google.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH] mwifiex: add __GFP_REPEAT to skb allocation call
References: <1459226840-36287-1-git-send-email-wnhuang@chromium.org>
Date: Tue, 29 Mar 2016 11:37:51 +0300
In-Reply-To: <1459226840-36287-1-git-send-email-wnhuang@chromium.org>
	(Wei-Ning Huang's message of "Tue, 29 Mar 2016 12:47:20 +0800")
Message-ID: <87vb45brxc.fsf@kamboji.qca.qualcomm.com> (sfid-20160329_103822_894274_5C48E807)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei-Ning Huang <wnhuang@chromium.org> writes:

> "single skb allocation failure" happens when system is under heavy
> memory pressure.  Add __GFP_REPEAT to skb allocation call so kernel
> attempts to reclaim pages and retry the allocation.
>
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>

Is this really a proper way to fix the issue? This is the first time I'm
hearing about the flag and there isn't even a single user in
drivers/net. I would like to get confirmation from others that
__GFP_REPEAT is really ok to use in a wireless driver before I can take
this.

-- 
Kalle Valo
