Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdITMpA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:45:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192ee: Fix memory leak when loading firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170914181744.8216-1-Larry.Finger@lwfinger.net>
References: <20170914181744.8216-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20170920124500.0117C6070F@smtp.codeaurora.org> (sfid-20170920_144503_235270_779B425F)
Date: Wed, 20 Sep 2017 12:44:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In routine rtl92ee_set_fw_rsvdpagepkt(), the driver allocates an skb, but
> never calls rtl_cmd_send_packet(), which will free the buffer. All other
> rtlwifi drivers perform this operation correctly.
> 
> This problem has been in the driver since it was included in the kernel.
> Fortunately, each firmware load only leaks 4 buffers, which likely
> explains why it has not previously been detected.
> 
> Cc: Stable <stable@vger.kernel.org> # 3.18+
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

519ce2f933fa rtlwifi: rtl8192ee: Fix memory leak when loading firmware

-- 
https://patchwork.kernel.org/patch/9953677/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
