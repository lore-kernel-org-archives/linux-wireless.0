Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42088 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbeIDQoU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:44:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath10k: average ack rssi support for data frames
References: <1536062951-17955-1-git-send-email-bpothuno@codeaurora.org>
Date: Tue, 04 Sep 2018 15:19:22 +0300
In-Reply-To: <1536062951-17955-1-git-send-email-bpothuno@codeaurora.org>
        (Balaji Pothunoori's message of "Tue, 4 Sep 2018 17:39:11 +0530")
Message-ID: <87va7l78vp.fsf@kamboji.qca.qualcomm.com> (sfid-20180904_141928_921585_18CE625D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Balaji Pothunoori <bpothuno@codeaurora.org> writes:

> Average ack rssi value is weighted average of ack rssi for
> no of msdu's has been sent.
> This feature is enabled by the host driver if firmware is capable.
> After receiving event from host, firmware allocates the necessary
> memory to store the ack_rssi for data packets during the init time.
>
> After each successful transmission, If tx completion status is OK
> and 24th bit is set in HTT message header then host will fetch the
> ack_rssi else host can ignore the ack_rssi field
>
> Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
> ---
> v2:
>    Addressed ath10k-check warnings
> v3:
>    cfg80211/mac80211 changes are already merged hence 
>    rebased ath10k patch alone.

Heh, we had a collision. Just 2 hours ago I rebased v2, fixed some
conflicts and it's now in pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ca376d236d335ccc9475ea1ab49df4643d8246b7

So please check that, and if it's good most likely I'll drop this v3.

-- 
Kalle Valo
