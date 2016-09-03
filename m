Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56773 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751987AbcICKDz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:03:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wl3501_cs: Add spinlock to wl3501_reset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1470130913-5218-1-git-send-email-andrianov@ispras.ru>
To: Pavel Andrianov <andrianov@ispras.ru>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Pavel Andrianov <andrianov@ispras.ru>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        vaishali.thakkar@oracle.com
Message-Id: <20160903100136.BB94A6201C@smtp.codeaurora.org> (sfid-20160903_120401_769224_DAAB7828)
Date: Sat,  3 Sep 2016 10:01:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Andrianov <andrianov@ispras.ru> wrote:
> Likely wl3501_reset should acquire spinlock as wl3501_{open, close}.
> One of calls of wl3501_reset has been already protected.
> The others were unprotected and might lead to a race condition.
> The patch adds spinlock into the wl3501_reset and removes it from 
> wl3501_tx_timeout.
> 
> Found by Linux Driver Verification project (linuxtesting.org)
> 
> Signed-off-by: Pavel Andrianov <andrianov@ispras.ru>
> Acked-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

bd6b0242652a wl3501_cs: Add spinlock to wl3501_reset

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9255415/
