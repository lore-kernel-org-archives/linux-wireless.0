Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42576 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab3CVKjF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 06:39:05 -0400
Message-ID: <514C34C1.1010004@tieto.com> (sfid-20130322_113910_390414_3D79D07B)
Date: Fri, 22 Mar 2013 11:38:57 +0100
From: Rymarkiewicz Waldemar <waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>
Subject: Re: [linux-nfc] [PATCH] NFC: microread: use kfree_skb() instead of
 kfree()
References: <CAPgLHd-BKoizHok9hDdAz9yBY1YqfpTov6s3CoefPTtbacQW3g@mail.gmail.com> <514AF0EA.9020504@tieto.com> <CAPgLHd9tUibxW53tQXhCsS9LPsgn=UA2Zj8O4Fxet0u7eEK7cQ@mail.gmail.com>
In-Reply-To: <CAPgLHd9tUibxW53tQXhCsS9LPsgn=UA2Zj8O4Fxet0u7eEK7cQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>>
>> kfree_skb call is used internally by the kernel. A driver should use dev_kfree_skb instead, I guess.
>
> It seems that dev_kfree_skb() call when dev_alloc_skb() is used, and
> kfree_skb() use to free skb malloced by alloc_skb().

I agree. The driver should use  dev_* flavoured skb function then.


Thanks,
/Waldek


