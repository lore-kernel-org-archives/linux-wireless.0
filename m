Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754801AbdLGNbu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:31:50 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: cfg80211: do not change virtual interface during scan
 processing
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1512022954-10129-1-git-send-email-huxm@marvell.com>
References: <1512022954-10129-1-git-send-email-huxm@marvell.com>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Limin Zhu <liminzhu@marvell.com>, Xinming Hu <huxm@marvell.com>
Message-Id: <20171207133150.382D0608BA@smtp.codeaurora.org> (sfid-20171207_143234_034902_666C2C3F)
Date: Thu,  7 Dec 2017 13:31:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> From: Limin Zhu <liminzhu@marvell.com>
> 
> (1) Change virtual interface operation in cfg80211 process reset and
> reinitilize private data structure.
> (2) Scan result event processed in main process will dereference private
> data structure concurrently, ocassionly crash the kernel.
> 
> The cornel case could be trigger by below steps:
> (1) wpa_cli mlan0 scan
> (2) ./hostapd mlan0.conf
> 
> Cfg80211 asynchronous scan procedure is not all the time operated
> under rtnl lock, here we add the protect to serialize the cfg80211
> scan and change_virtual interface operation.
> 
> Signed-off-by: Limin Zhu <liminzhu@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

c61cfe49f0f0 mwifiex: cfg80211: do not change virtual interface during scan processing

-- 
https://patchwork.kernel.org/patch/10084299/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
