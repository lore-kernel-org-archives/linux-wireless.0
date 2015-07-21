Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38398 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbbGUPB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 11:01:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: fix moredata flag endianness in cabq tx
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1436437642-18781-1-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Message-Id: <20150721150156.DCA2D141ACC@smtp.codeaurora.org> (sfid-20150721_170200_718265_1E28B605)
Date: Tue, 21 Jul 2015 15:01:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> While compiling ath9k with some extra flags I've
> found that:
> 
>  ath9k/xmit.c +2473 ## 16: warning: restricted __le16 degrades to integer
>  ath9k/xmit.c +2474 ## 36: warning: invalid assignment: &=
>  ath9k/xmit.c +2474 ## 36:    left side has type restricted __le16
>  ath9k/xmit.c +2474 ## 36:    right side has type int
> 
> There's no way for frame ftype/stype to be
> mistreated as the offending 'moredata' flag when
> considering cab queue.
> 
> This could've however theoretically led sometimes
> to increased power consumption on connected
> stations as they would keep their Rx active
> waiting for frames that would never come.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
