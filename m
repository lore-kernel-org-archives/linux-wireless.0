Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1957239AbdDZIxh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:53:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170426085337.181AA61493@smtp.codeaurora.org> (sfid-20170426_105510_511260_35215C9D)
Date: Wed, 26 Apr 2017 08:53:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
> callback was actually cloned. So instead of checking for sufficient
> headroom it should also be writable. Hence use skb_cow_head() to
> check and expand the headroom appropriately.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Steve, would you have time to run a quick test with this?

Patch set to Deferred.

-- 
https://patchwork.kernel.org/patch/9697757/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
