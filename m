Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48094 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbeEOFjt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 01:39:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rsi: Add null check for virtual interfaces in wowlan config
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1526050673-7026-2-git-send-email-sushant2k1513@gmail.com>
References: <1526050673-7026-2-git-send-email-sushant2k1513@gmail.com>
To: Sushant Kumar Mishra <sushant2k1513@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Message-Id: <20180515053948.A5E3660A06@smtp.codeaurora.org> (sfid-20180515_074000_317492_5AE43442)
Date: Tue, 15 May 2018 05:39:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sushant Kumar Mishra <sushant2k1513@gmail.com> wrote:

> From: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
> 
> When the "poweroff" command is executed after wowlan enabled, we have
> observed a system crash. In the system "poweroff" sequence, network-manager
> is sent to inactive state by cleaning up the network interfaces, using
> rsi_mac80211_remove_interface() and when driver tries to access those
> network interfaces in rsi_wowlan_config() which was invoked by SDIO
> shutdown, results in a crash. Added a NULL check before accessing the
> network interfaces in rsi_wowlan_config().
> 
> Signed-off-by: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>

3 patches applied to wireless-drivers-next.git, thanks.

54b5172087ae rsi: Add null check for virtual interfaces in wowlan config
d76f8513fa90 rsi: reset hibernate_resume flag to work hibernate resume in coex mode.
1d18c5584c05 rsi: Set wowlan flag while writing wowlan config parameters

-- 
https://patchwork.kernel.org/patch/10394551/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
