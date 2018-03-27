Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751732AbeC0JJi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 05:09:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmsmac: allocate ucode with GFP_KERNEL
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180316154149.16891-1-tiwai@suse.de>
References: <20180316154149.16891-1-tiwai@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Message-Id: <20180327090937.91DE86030F@smtp.codeaurora.org> (sfid-20180327_110942_452306_4A7F8BDF)
Date: Tue, 27 Mar 2018 09:09:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Takashi Iwai <tiwai@suse.de> wrote:

> The brcms_ucode_init_buf() duplicates the ucode chunks via kmemdup()
> with GFP_ATOMIC as a precondition of wl->lock acquired.  This caused
> allocation failures sometimes as reported in the bugzilla below.
> 
> When looking at the the real usage, one can find that it's called
> solely from brcms_request_fw(), and it's obviously outside the lock.
> Hence we can use GFP_KERNEL there safely for avoiding such allocation
> errors.
> 
> Bugzilla: http://bugzilla.suse.com/show_bug.cgi?id=1085174
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

b1c2d0f2507b brcmsmac: allocate ucode with GFP_KERNEL

-- 
https://patchwork.kernel.org/patch/10288881/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
