Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36496 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752288AbeBKJ7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Feb 2018 04:59:05 -0500
Subject: Re: [PATCH] ath10k: fix use-after-free in ath10k_wmi_cmd_send_nowait
To: Carl Huang <cjhuang@codeaurora.org>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <1518317805-5796-1-git-send-email-cjhuang@codeaurora.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <3995aa0a-00f0-5ca1-fc49-1fad141fb2ae@nbd.name> (sfid-20180211_105911_668553_CFBDF36F)
Date: Sun, 11 Feb 2018 10:59:02 +0100
MIME-Version: 1.0
In-Reply-To: <1518317805-5796-1-git-send-email-cjhuang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-11 03:56, Carl Huang wrote:
> The skb may be freed in tx completion context before
> trace_ath10k_wmi_cmd is called. This can be easily captured
> when KASAN(Kernel Address Sanitizer) is enabled. The fix is
> to add a reference count to the skb and release it after
> trace_ath10k_wmi_cmd is called.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
I think it makes more sense to simply call the trace function before
ath10k_htc_send. Also, for a trivial change like this it probably does
not make sense to add a Copyright line either.

- Felix
