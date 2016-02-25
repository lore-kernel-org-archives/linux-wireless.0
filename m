Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57248 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467AbcBYKAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 05:00:50 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] b43: Remove unnecessary synchronize_irq() before free_irq()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1454964073-25108-1-git-send-email-lars@metafoo.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Lars-Peter Clausen <lars@metafoo.de>
Message-Id: <20160225100049.E4F4F6089B@smtp.codeaurora.org> (sfid-20160225_110055_188739_5BB1121D)
Date: Thu, 25 Feb 2016 10:00:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Calling synchronize_irq() right before free_irq() is quite useless. On one
> hand the IRQ can easily fire again before free_irq() is entered, on the
> other hand free_irq() itself calls synchronize_irq() internally (in a race
> condition free way), before any state associated with the IRQ is freed.
> 
> Patch was generated using the following semantic patch:
> // <smpl>
> @@
> expression irq;
> @@
> -synchronize_irq(irq);
>  free_irq(irq, ...);
> // </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks, 2 patches applied to wireless-drivers-next.git:

10fbc7cf031d b43: Remove unnecessary synchronize_irq() before free_irq()
400b43c58269 rtlwifi: Remove unnecessary synchronize_irq() before free_irq()

Kalle Valo
