Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:49070 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754544Ab2DCSll (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 14:41:41 -0400
Message-ID: <1333478499.26079.67.camel@joe2Laptop> (sfid-20120403_204144_290287_D8B8CED3)
Subject: Re: [PATCH 1/2] ath6kl: Use vmalloc instead of kmalloc for fw
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Natarajan <nataraja@qca.qualcomm.com>,
	ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org,
	PingYang Zhang <pingzhan@qca.qualcomm.com>
Date: Tue, 03 Apr 2012 11:41:39 -0700
In-Reply-To: <4F7B411D.5070903@qca.qualcomm.com>
References: <1332942686-6965-1-git-send-email-nataraja@qca.qualcomm.com>
	 <4F7B411D.5070903@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 21:27 +0300, Kalle Valo wrote:
> On 03/28/2012 04:51 PM, Vivek Natarajan wrote:
> > Sometimes it has been observed that allocating a contiguous memory
> > of more than 100K fails with kmalloc. This has been modified to
> > use vmalloc instead.
> > 
> > Signed-off-by: PingYang Zhang <pingzhan@qca.qualcomm.com>
> > Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
> 
> Thanks, both patches applied.

Because the vmalloc space is limited, this should try
kmalloc first and only on failure try vmalloc.

Andrew, more reasons for a real helper/API.
Care to rap any knuckles?

