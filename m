Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbeITRzH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:55:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] brcmsmac: Use kvmalloc() for ucode allocations
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180913061517.26295-1-tiwai@suse.de>
References: <20180913061517.26295-1-tiwai@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Message-Id: <20180920121155.6B8EF60B73@smtp.codeaurora.org> (sfid-20180920_141203_155462_D5E274C2)
Date: Thu, 20 Sep 2018 12:11:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Takashi Iwai <tiwai@suse.de> wrote:

> The ucode chunk might be relatively large and the allocation with
> kmalloc() may fail occasionally.  Since the data isn't DMA-transferred
> but by manual loops, we can use vmalloc instead of kmalloc.
> For a better performance, though, kvmalloc() would be the best choice
> in such a case, so let's replace with it.
> 
> Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1103431
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Patch applied to wireless-drivers-next.git, thanks.

6c3efbe77bc7 brcmsmac: Use kvmalloc() for ucode allocations

-- 
https://patchwork.kernel.org/patch/10598731/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
