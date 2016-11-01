Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60072 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752717AbcKAQl6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 12:41:58 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Brian Norris <briannorris@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH 1/2] mwifiex: fix corner case power save issue
Date: Tue, 1 Nov 2016 16:41:55 +0000
Message-ID: <465d581a689c40e3bc715fab2314f5f7@SC-EXCH04.marvell.com> (sfid-20161101_174202_679976_03036BE5)
References: <1477062948-8558-1-git-send-email-akarwar@marvell.com>
In-Reply-To: <1477062948-8558-1-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
> Sent: Friday, October 21, 2016 8:46 PM
> To: linux-wireless@vger.kernel.org
> Cc: Cathy Luo; Nishant Sarmukadam; Amitkumar Karwar
> Subject: [PATCH 1/2] mwifiex: fix corner case power save issue
> 
> We may get SLEEP event from firmware even if TXDone for last Tx packet
> is still pending. In this case, we may end up accessing PCIe memory for
> handling TXDone after power save handshake is completed. This causes
> kernel crash with external abort.
> 
> We will delay sending SLEEP confirm to firmware in this case to resolve
> the problem.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Please drop this patch.
Xinming Hu has better and complete solution for this issue as discussed at https://patchwork.kernel.org/patch/9405119/

Regards,
Amitkumar
