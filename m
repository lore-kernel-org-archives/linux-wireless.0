Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:20102 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab2IGRBZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:01:25 -0400
Date: Fri, 7 Sep 2012 19:01:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	davem@davemloft.net, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] NFC: fix possible memory leak
Message-ID: <20120907170121.GF3647@sortiz-mobl> (sfid-20120907_190130_432351_E24BA2FB)
References: <CAPgLHd_sD6NYc=Dj4yJpHY0yLBuDmQx=upQY=XQLi-9kTycK-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd_sD6NYc=Dj4yJpHY0yLBuDmQx=upQY=XQLi-9kTycK-Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

On Sun, Sep 02, 2012 at 09:21:46PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> nfc_llcp_build_tlv() malloced the memory and should be free in
> nfc_llcp_build_gb() after used, and the same in the error handling
> case, otherwise it will cause memory leak.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  net/nfc/llcp/llcp.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
