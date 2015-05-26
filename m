Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58682 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbbEZN5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:57:51 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k_htc: memory corruption calling set_bit()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150514083448.GC1665@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>
Message-Id: <20150526105444.2FAC81416CE@smtp.codeaurora.org> (sfid-20150526_155801_623265_37698A2B)
Date: Tue, 26 May 2015 10:54:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In d8a2c51cdcae ('ath9k_htc: Use atomic operations for op_flags') we
> changed things like this:
> 
> -	if (priv->op_flags & OP_TSF_RESET) {
> +	if (test_bit(OP_TSF_RESET, &priv->op_flags)) {
> 
> The problem is that test_bit() takes a bit number and not a mask.  It
> means that when we do:
> 
> 	set_bit(OP_TSF_RESET, &priv->op_flags);
> 
> Then it sets the (1 << 6) bit instead of the 6 bit so we are setting a
> bit which is past the end of the unsigned long.
> 
> Fixes: d8a2c51cdcae ('ath9k_htc: Use atomic operations for op_flags')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
