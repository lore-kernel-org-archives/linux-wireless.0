Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33890 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbeHaTzV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:55:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mwifiex: do no submit URB in suspended state
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1534837982-31206-1-git-send-email-gbhat@marvell.com>
References: <1534837982-31206-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Vidya Dharmaraju <vidyad@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180831154715.32FA66053D@smtp.codeaurora.org> (sfid-20180831_174754_798992_4CEFE4E4)
Date: Fri, 31 Aug 2018 15:47:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> There is a possible race between USB suspend and main thread:
> 
> 1. After processing the command response, main thread will submit
> rx_cmd URB back so as to process next command response, by
> calling mwifiex_usb_submit_rx_urb.
> 
> 2. During USB suspend, the suspend handler will check if rx_cmd
> URB is pending(submitted) and if true, kill this URB.
> 
> There is a possible race between #1 and #2, where rx_cmd URB will
> be submitted by main thread(#1) after the suspend handler check
> in #2.
> 
> To fix this, check if device is already suspended in
> mwifiex_usb_submit_rx_urb, in which case do not submit the URB.
> 
> Signed-off-by: Vidya Dharmaraju <vidyad@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

7bd4628c2f31 mwifiex: do no submit URB in suspended state
33a164fa8a4c mwifex: free rx_cmd skb in suspended state

-- 
https://patchwork.kernel.org/patch/10571161/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
