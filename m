Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12566 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2IGRFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:05:25 -0400
Date: Fri, 7 Sep 2012 19:05:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] NFC: move the dereference below the NULL test
Message-ID: <20120907170522.GG3647@sortiz-mobl> (sfid-20120907_190528_918516_99144349)
References: <CAPgLHd8yH37C=mRWinWM4FGQaWTvH0r69PFEgJCNZL2DdZAS1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd8yH37C=mRWinWM4FGQaWTvH0r69PFEgJCNZL2DdZAS1A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

On Fri, Sep 07, 2012 at 02:51:47PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference should be moved below the NULL test.
> 
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/nfc/nfcwilink.c | 4 ++--
>  drivers/nfc/pn544_hci.c | 3 ++-
>  drivers/nfc/pn544.c     | 3 ++-
>  3 files changed, 6 insertions(+), 4 deletions(-)
Those are correct fixes but could you please split the nfcwilink and pn544_hci
fixes into 2 patches. Also, the pn544 driver is going to be removed so no need
to fix it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
