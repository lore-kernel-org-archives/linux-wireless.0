Return-Path: <SRS0=wpaD=YZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92220CA9ECF
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Nov 2019 11:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A7EF21897
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Nov 2019 11:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572606895;
	bh=WpF6LVHcwvLGyg21hweOG7aRyEpLPoQgKNX3GjxIxDA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=VHrTsd0sHOU3r00/w0OlCPErpXA4MbExOZu+Rxr4Qtsudj6sg7h5ZeVaLBAe5X+A0
	 fUfYQL3dECL1KkUli8y7UNVAGvvrFmlJ+qMkGX0tPcP9HEH2eIMe94HuKTlKyuvcZ5
	 4fSTTJnF3N6u126hni30UgKmXGg7vSCZxIqJnxzQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbfKALOy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Nov 2019 07:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfKALOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Nov 2019 07:14:54 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE8CD21835
        for <linux-wireless@vger.kernel.org>; Fri,  1 Nov 2019 11:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572606893;
        bh=WpF6LVHcwvLGyg21hweOG7aRyEpLPoQgKNX3GjxIxDA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U60KUotpd9Y8yLcU2NQQYhKd1rXR+XBFKP+GNtyV3hS2k95KdO4S7uiaothXrFZ12
         A0WHr0qNs0dAYl2ItDs2+LqwNdna6se3DOTNM3A99Th4fZsZDEPawnAc4TkJIlADw3
         5nhQrYOnp/zgSiy8nzGuGOKz4Ld9qnR32O9D4rZc=
Received: by mail-qt1-f180.google.com with SMTP id e14so12501354qto.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2019 04:14:53 -0700 (PDT)
X-Gm-Message-State: APjAAAXDPSuVZYhv7h00lOhtYxAqntvgFADtt0hYVTlTZBdF+DTF99ke
        LAa9HCKUmaRqqDhFiZXWPaQmLZ169aaYwwGVtV4=
X-Google-Smtp-Source: APXvYqwUMR0ejkbvf1SiiAiM6ne0JIKq68iwTd5z653LJKCzZSrDNlsVr4BAcBYcRaSAmmN3MtS6OWN1RP6TiMhqnbE=
X-Received: by 2002:a0c:efc2:: with SMTP id a2mr9662647qvt.44.1572606892881;
 Fri, 01 Nov 2019 04:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191101023805.16093-1-yhchuang@realtek.com>
In-Reply-To: <20191101023805.16093-1-yhchuang@realtek.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Fri, 1 Nov 2019 07:14:41 -0400
X-Gmail-Original-Message-ID: <CA+5PVA4G0zgrPsrCwV-dDBHR9o2=hh7a+2dyBi3a77sCNE2HbQ@mail.gmail.com>
Message-ID: <CA+5PVA4G0zgrPsrCwV-dDBHR9o2=hh7a+2dyBi3a77sCNE2HbQ@mail.gmail.com>
Subject: Re: [PATCH] rtw88: RTL8723D: add firmware file v48
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 31, 2019 at 10:38 PM <yhchuang@realtek.com> wrote:
>
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> Add firmware file for RTL8723D series devices.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  WHENCE                |   1 +
>  rtw88/rtw8723d_fw.bin | Bin 0 -> 28884 bytes
>  2 files changed, 1 insertion(+)
>  create mode 100644 rtw88/rtw8723d_fw.bin
>
> diff --git a/WHENCE b/WHENCE
> index 41494ab..5fcde52 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2792,6 +2792,7 @@ Info: Sent to Larry Finger by Realtek engineer Yan-Hsuan Chuang <yhchuang@realte
>  File: rtw88/rtw8822b_fw.bin
>  File: rtw88/rtw8822c_fw.bin
>  File: rtw88/rtw8822c_wow_fw.bin
> +File: rtw88/rtw8723d_fw.bin

This doesn't apply cleanly.  Can you rebase it to the latest tree and resend?

josh
