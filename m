Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55956 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeAPPCK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 10:02:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4] brcmfmac: fix CLM load error for legacy chips when user
 helper is enabled
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516094814-16528-1-git-send-email-wright.feng@cypress.com>
References: <1516094814-16528-1-git-send-email-wright.feng@cypress.com>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, stable@vger.kernel.org
Message-Id: <20180116150209.9C53960854@smtp.codeaurora.org> (sfid-20180116_160214_046389_6837FB4C)
Date: Tue, 16 Jan 2018 15:02:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> wrote:

> For legacy chips without CLM blob files, kernel with user helper function
> returns -EAGAIN when we request_firmware(), and then driver got failed
> when bringing up legacy chips. We expect the CLM blob file for legacy chip
> is not existence in firmware path, but the -ENOENT error is transferred to
> -EAGAIN in firmware_class.c with user helper.
> Because of that, we continue with CLM data currently present in firmware
> if getting error from doing request_firmware().
> 
> Cc: stable@vger.kernel.org # v4.15.y
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

I'll try to squeeze this to 4.15 still.

-- 
https://patchwork.kernel.org/patch/10166257/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
