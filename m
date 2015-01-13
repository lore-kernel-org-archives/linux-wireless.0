Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50211 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbAMOQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:16:51 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: <linux-wireless@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ath10k@lists.infradead.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 8/8] ath10k: fix error return code
References: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
	<1419872683-32709-9-git-send-email-Julia.Lawall@lip6.fr>
Date: Tue, 13 Jan 2015 16:16:40 +0200
In-Reply-To: <1419872683-32709-9-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Mon, 29 Dec 2014 18:04:43 +0100")
Message-ID: <87ppai6a0n.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_151732_243081_1AAB3BC3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> Return a negative error code on failure.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> identifier ret; expression e1,e2;
> @@
> (
> if (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, applied to ath.git.

-- 
Kalle Valo
