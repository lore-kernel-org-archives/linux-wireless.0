Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55711 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751481AbeCPUup (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 16:50:45 -0400
Received: by mail-wm0-f68.google.com with SMTP id q83so5405883wme.5
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2018 13:50:45 -0700 (PDT)
Subject: Re: [PATCH] brcmsmac: allocate ucode with GFP_KERNEL
To: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org
References: <20180316154149.16891-1-tiwai@suse.de>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AAC2E23.5020505@broadcom.com> (sfid-20180316_215049_412469_29ABD6D8)
Date: Fri, 16 Mar 2018 21:50:43 +0100
MIME-Version: 1.0
In-Reply-To: <20180316154149.16891-1-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/16/2018 4:41 PM, Takashi Iwai wrote:
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

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
