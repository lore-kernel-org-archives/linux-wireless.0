Return-Path: <SRS0=3v18=Y4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97922CA9EA0
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Nov 2019 11:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61CD921D81
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Nov 2019 11:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572867488;
	bh=S4DlKjC+QyxZ/Bxg0haMUneTgTsHsCFknXW9hG+gi8c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=U6tejubhtNkWlL1OTEs3dHVRTlLZYCCg4TRtlWivINsl9OfyY08vP7cv4Zm7niqKX
	 cG1WZ/ewjiOgXXrTOIr6pZteCo0iYPA4OR9SI3+vz8XWtZNR8MQ1JPYc+Yk3OMdXkP
	 3hLLZUuXQ74cINVlujS1sGA/cvVLAOZx5phE7dH8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfKDLiH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Nov 2019 06:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfKDLiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Nov 2019 06:38:07 -0500
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3B921E6F
        for <linux-wireless@vger.kernel.org>; Mon,  4 Nov 2019 11:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572867487;
        bh=S4DlKjC+QyxZ/Bxg0haMUneTgTsHsCFknXW9hG+gi8c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AMgqxP2ruVOZ9dYNxw4KpxK31DJa75jm9+SBGiuRTwprlJwu3gw5FmD0xVCF6kyjy
         3H67l0aO1+Gg5cJidU0w1U7wrzZl1wsn5oBIZZadPkYkPdj3VUdU9zrjHH33muO2Jn
         38lXHelaG604IJLv2sshvc5VeeHaCvbr+bB0/+H4=
Received: by mail-qk1-f177.google.com with SMTP id i19so8131909qki.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2019 03:38:07 -0800 (PST)
X-Gm-Message-State: APjAAAWw+JGQmyNVbt/+MPkzGzk+nSZE/KUwbmG09OgM4EgLdEtyqbBM
        kpsKCLAYliOBJavClvxJBvGO4/ks5uqhSxR2cBw=
X-Google-Smtp-Source: APXvYqz+nNf1kPRZV08fhj3lqRaAMkeaoYmLvD3JfhQ9vv066fYjFa/4cEyEciXrNOHvHn4m3sYi5n/7WQGjI7ynI/E=
X-Received: by 2002:a37:2ec6:: with SMTP id u189mr16634308qkh.95.1572867486302;
 Mon, 04 Nov 2019 03:38:06 -0800 (PST)
MIME-Version: 1.0
References: <20191104022948.24735-1-yhchuang@realtek.com>
In-Reply-To: <20191104022948.24735-1-yhchuang@realtek.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 4 Nov 2019 06:37:55 -0500
X-Gmail-Original-Message-ID: <CA+5PVA4+-jpGa06fn7UoKh-89nLqkphcuWDs+F-G1s3Fo16Ebg@mail.gmail.com>
Message-ID: <CA+5PVA4+-jpGa06fn7UoKh-89nLqkphcuWDs+F-G1s3Fo16Ebg@mail.gmail.com>
Subject: Re: [PATCH v2] rtw88: RTL8723D: add firmware file v48
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Linux Firmware <linux-firmware@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Nov 3, 2019 at 9:30 PM <yhchuang@realtek.com> wrote:
>
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> Add firmware file for RTL8723D series devices.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>
> v1 -> v2
>   * rebase on top of master
>
>  WHENCE                |   1 +
>  rtw88/rtw8723d_fw.bin | Bin 0 -> 28884 bytes
>  2 files changed, 1 insertion(+)
>  create mode 100644 rtw88/rtw8723d_fw.bin

Applied and pushed out.

josh
