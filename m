Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38907 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2DPGHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:07:54 -0400
Message-ID: <4F8BB735.4040409@qca.qualcomm.com> (sfid-20120416_080758_711876_EFBE74D9)
Date: Mon, 16 Apr 2012 09:07:49 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: fix memory leak in ath6kl_fwlog_block_read()
References: <alpine.LNX.2.00.1204112239070.2137@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204112239070.2137@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2012 11:41 PM, Jesper Juhl wrote:
> If, in
> drivers/net/wireless/ath/ath6kl/debug.c::ath6kl_fwlog_block_read(),
> the call to wait_for_completion_interruptible() returns -ERESTARTSYS
> then we'll return without freeing the (as yet unused) memory we
> allocated for 'buf' - thus leaking it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks, applied to ath6kl.git.

Kalle
