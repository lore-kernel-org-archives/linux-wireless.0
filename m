Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43958 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab1CUOZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 10:25:10 -0400
Received: by mail-wy0-f172.google.com with SMTP id 42so7891822wyb.17
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 07:25:07 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: set the actual tid instead of the ac
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1300309434-15491-1-git-send-email-eliad@wizery.com>
References: <1300309434-15491-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 16:24:27 +0200
Message-ID: <1300717467.2593.213.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-16 at 23:03 +0200, Eliad Peller wrote:
> When passing a tx frame, the driver incorrectly set desc->tid
> with the ac instead of the actual tid.
> 
> It has some serious implications when using 802.11n + QoS,
> as the fw starts a BlockAck with the wrong tid (which finally
> cause beacon loss and disconnection / some fw crash)
> 
> Fix it by using the actual tid stored in skb->priority.
> 
> Reported-by: Shahar Levi <shahar_levi@ti.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thank you! And thanks Juuso for the review!

-- 
Cheers,
Luca.

