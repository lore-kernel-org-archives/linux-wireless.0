Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39955 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab3C1LXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 07:23:40 -0400
Date: Thu, 28 Mar 2013 12:23:35 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rymarkiewicz Waldemar <waldemar.rymarkiewicz@tieto.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>
Subject: Re: [linux-nfc] [PATCH] NFC: microread: use kfree_skb() instead of
 kfree()
Message-ID: <20130328112335.GG2153@zurbaran> (sfid-20130328_122342_790274_3C6DE25B)
References: <CAPgLHd-BKoizHok9hDdAz9yBY1YqfpTov6s3CoefPTtbacQW3g@mail.gmail.com>
 <514AF0EA.9020504@tieto.com>
 <CAPgLHd9tUibxW53tQXhCsS9LPsgn=UA2Zj8O4Fxet0u7eEK7cQ@mail.gmail.com>
 <514C34C1.1010004@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <514C34C1.1010004@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Waldemar,

On Fri, Mar 22, 2013 at 11:38:57AM +0100, Rymarkiewicz Waldemar wrote:
> Hi,
> 
> >>
> >>kfree_skb call is used internally by the kernel. A driver should use dev_kfree_skb instead, I guess.
> >
> >It seems that dev_kfree_skb() call when dev_alloc_skb() is used, and
> >kfree_skb() use to free skb malloced by alloc_skb().
> 
> I agree. The driver should use  dev_* flavoured skb function then.
I'd prefer the driver to call nfc_alloc_recv_skb() instead. This one calls
alloc_skb() but we could have it call dev_alloc_skb() I suppose. dev_alloc_skb
does atomic allocation though.
And kfree_skb() or dev_kfree_skb() is essentially the same.

I'll fix the driver so that it calls nfc_alloc_recv_skb() and kfree_skb unless
Wei beats me at it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
