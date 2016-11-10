Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40830 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbcKJOGR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 09:06:17 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH RESEND v2 01/11] mwifiex: check tx_hw_pending before downloading sleep confirm
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
Date: Thu, 10 Nov 2016 16:06:11 +0200
In-Reply-To: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
        (Xinming Hu's message of "Thu, 10 Nov 2016 19:57:02 +0800")
Message-ID: <87y40rpgz0.fsf@purkki.adurom.net> (sfid-20161110_150621_808866_173B957E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> writes:

> From: Shengzhen Li <szli@marvell.com>
>
> We may get SLEEP event from firmware even if TXDone interrupt
> for last Tx packet is still pending. In this case, we may
> end up accessing PCIe memory for handling TXDone after power
> save handshake is completed. This causes kernel crash with
> external abort.
>
> This patch will only allow downloading sleep confirm
> when no tx done interrupt is pending in the hardware.
>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: address format issues(Brain)
> RESEND v2(Applicable for complete patch series):
>     1) Fixed syntax issue "changelog not placed after the  Sign-offs"
>        pointed by Brian.
>     2) Dropped "[v2,03/12] mwifiex: don't do unbalanced free()'ing in
>        cleanup_if()" patch in this series. It was already sent by Brian
>        separately.

I do not know where this "v2 RESEND" practise is coming from but I very
much prefer that people would not use it. If you need to resend
something keep things simple, just increase the version number and
document in the changelog that nothing changed. I don't care what the
patchset version number is, I always look at the latest version and
discard the older ones.

This is just for the future, no need resend anything because of this.

-- 
Kalle Valo
