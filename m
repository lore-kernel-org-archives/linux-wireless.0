Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37540 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933491AbbJIIr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 04:47:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath: fix DFS timestamp wraparound reset condition
References: <1443522589-14421-1-git-send-email-zefir.kurtisi@neratec.com>
Date: Fri, 09 Oct 2015 11:47:52 +0300
In-Reply-To: <1443522589-14421-1-git-send-email-zefir.kurtisi@neratec.com>
	(Zefir Kurtisi's message of "Tue, 29 Sep 2015 12:29:49 +0200")
Message-ID: <87zizsqvgn.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_104806_768929_84727CE3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:

> The DFS pattern detector ought to reset the
> detector lines when a pulse is added with
> lower time stamp than the previous (which
> indicates a TSF restart).
>
> This did not work so far and is fixed with
> this patch.
>
> The modification does not change detection
> performance within the driver, since it
> only ensures early reset (which is later
> performed by the PRI detectors anyway).
> It is relevant for synthetic tests and
> statistical evaluations, where millions
> of pulse patterns are processed and an
> early reset helps reducing load.
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Applied, thanks.

-- 
Kalle Valo
