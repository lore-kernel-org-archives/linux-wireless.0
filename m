Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52159 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbcDZJTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:19:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmf: Fix null pointer exception in bcdc_hdrpull
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460899503-5245-1-git-send-email-per.forlin@gmail.com>
To: per.forlin@gmail.com
Cc: linux-wireless@vger.kernel.org, arend@broadcom.com,
	brudley@broadcom.com, Per Forlin <per.forlin@gmail.com>
Message-Id: <20160426091907.778F16120A@smtp.codeaurora.org> (sfid-20160426_111919_938677_A2161210)
Date: Tue, 26 Apr 2016 09:19:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Per Forlin <per.forlin@gmail.com>
> 
> In fwsignal.c: brcmf_fws_commit_skb()
> ...
> if (rc < 0) {
>   entry->transit_count--;
>     if (entry->suppressed)
>       entry->suppr_transit_count--;
>       (void)brcmf_proto_hdrpull(fws->drvr, false, skb, NULL);
>                                                      ^^^^^^^
>     goto rollback;
> }
> ...
> 
> The call to hdrpull will trigger a null pointer exception
> unless a null check is made in the method implementation.
> 
> Signed-off-by: Per Forlin <per.forlin@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
