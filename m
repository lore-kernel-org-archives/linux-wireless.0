Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762000AbcINQl4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 12:41:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/3,v2] wlcore: Pass win_size taken from ieee80211_sta to FW
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160821112425.11302-2-maxim.altshul@ti.com>
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        Maxim Altshul <maxim.altshul@ti.com>
Message-Id: <20160914164153.B69A361B1D@smtp.codeaurora.org> (sfid-20160914_184200_719487_02FD99B8)
Date: Wed, 14 Sep 2016 16:41:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Altshul <maxim.altshul@ti.com> wrote:
> When starting a new BA session, we must pass the win_size to the FW.
> 
> To do this we take max_rx_aggregation_subframes (BA RX win size)
> which is stored in ieee80211_sta structure (e.g per link and not per HW)
> 
> We will use the value stored per link when passing the win_size to
> firmware through the ACX_BA_SESSION_RX_SETUP command.
> 
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>

Depends on this commit which is currently in mac80211-next:

480dd46b9d68 mac80211: RX BA support for sta max_rx_aggregation_subframes

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9292121/
