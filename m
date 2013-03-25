Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60386 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab3CYPJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 11:09:32 -0400
Message-ID: <1364224101.23210.19.camel@cumari.coelho.fi> (sfid-20130325_160935_560362_D9F6152C)
Subject: Re: [PATCH] wlcore: move handling from hardirq to the irq thread
 function
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <ido@wizery.com>, <balbi@ti.com>, <gregoire@alwaysinnovating.com>
Date: Mon, 25 Mar 2013 17:08:21 +0200
In-Reply-To: <1364208824-18751-1-git-send-email-coelho@ti.com>
References: <1364208824-18751-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-25 at 12:53 +0200, Luciano Coelho wrote:
> Spin locks and completions are expensive in hard IRQ context and cause
> problems with RT kernels.  In RT kernels, both spin locks and
> completions can schedule(), so we can't use them in hard irq context.
> 
> Move handling code into the irq thread function to avoid that.
> 
> Reported-by: Gregoire Gentil <gregoire@alwaysinnovating.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Luca.

