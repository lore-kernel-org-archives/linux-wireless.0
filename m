Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44247 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbcECKF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 06:05:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl818x: Deinline indexed IO functions, save 21568 bytes
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461593872-6296-1-git-send-email-dvlasenk@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: unlisted-recipients:; (no To-header on input)
	Denys Vlasenko <dvlasenk@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160503100557.76E7A60239@smtp.codeaurora.org> (sfid-20160503_120618_608621_17E7888A)
Date: Tue,  3 May 2016 10:05:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> rtl818x_ioread8_idx: 151 bytes, 29 calls
> rtl818x_ioread16_idx: 151 bytes, 11 calls
> rtl818x_ioread32_idx: 151 bytes, 5 calls
> rtl818x_iowrite8_idx: 157 bytes, 117 calls
> rtl818x_iowrite16_idx: 158 bytes, 74 calls
> rtl818x_iowrite32_idx: 157 bytes, 22 calls
> 
> Each of these functions has a pair of mutex lock/unlock ops,
> both of these ops perform atomic updates of memory (on x86, it boils down to
> "lock cmpxchg %reg,mem" insn), which are 4-8 times more expensive than call+return.
> 
>     text     data      bss       dec     hex filename
> 95894242 20860288 35991552 152746082 91ab862 vmlinux_before
> 95872674 20860320 35991552 152724546 91a6442 vmlinux
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Larry Finger <Larry.Finger@lwfinger.net>
> CC: Chaoming Li <chaoming_li@realsil.com.cn>
> CC: linux-wireless@vger.kernel.org
> CC: linux-kernel@vger.kernel.org

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
