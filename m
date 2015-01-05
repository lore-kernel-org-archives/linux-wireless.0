Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:52993 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEIIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 03:08:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Stable <stable@vger.kernel.org>,
	Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH V3 for 3.19]  rtlwifi: Fix error when accessing unmapped memory in skb
References: <1419996787-17395-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 05 Jan 2015 10:07:51 +0200
In-Reply-To: <1419996787-17395-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Tue, 30 Dec 2014 21:33:07 -0600")
Message-ID: <87oaqd4pm0.fsf@kamboji.qca.qualcomm.com> (sfid-20150105_090811_002670_C7FA2AAA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> These drivers use 9100-byte receive buffers, thus allocating an skb requires
> an O(3) memory allocation. Under heavy memory loads and fragmentation, such
> a request can fail. Previous versions of the driver have dropped the packet
> and reused the old buffer; however, the new version introduced a bug in that
> it released the old buffer before trying to allocate a new one. The previous
> method is implemented here. The skb is unmapped before any attempt is made to
> allocate another.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>  [v3.18]
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Cc: Eric Biggers <ebiggers3@gmail.com>

Thanks, applied to wireless-drivers.git.

-- 
Kalle Valo
