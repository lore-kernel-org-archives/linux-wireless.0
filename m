Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:58761 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbbAOMpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:45:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] adm8211: fix error return code
References: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
	<1419872683-32709-7-git-send-email-Julia.Lawall@lip6.fr>
Date: Thu, 15 Jan 2015 14:45:11 +0200
In-Reply-To: <1419872683-32709-7-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Mon, 29 Dec 2014 18:04:41 +0100")
Message-ID: <87fvbctdpk.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_134544_783006_53C99FA8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
