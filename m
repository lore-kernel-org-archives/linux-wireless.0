Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75DDC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 05:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9480F20855
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 05:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drawerlight-com.20150623.gappssmtp.com header.i=@drawerlight-com.20150623.gappssmtp.com header.b="nzE5gele"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfARFsh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 00:48:37 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:54175 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfARFsh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 00:48:37 -0500
Received: by mail-it1-f193.google.com with SMTP id g85so5208306ita.3;
        Thu, 17 Jan 2019 21:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drawerlight-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rNchZrX6wjpbtjKY+B+Aes3vTPDGEdMcZKjJrdean4Y=;
        b=nzE5gele8tybksg9G4R5AXRnASuuTwkqZPhAyDonUjz/+wSCmN3Yl7kebhvlBrpwE5
         n8SOX6+Vm5f4/ZAYoT+7tunGwdRsJ8zuDZqET3XtUNChing3MGsVnRBCp8/mcfV1uK1K
         6l3jcCpZ6tsArvC7N9Albxvdi07d/2K2TIRVMevLtAA9B2p/qkKqNBhP2TrWVyH8TSC0
         yDHgIbWM6BD5PVdu15e8pXML4T4RxiZBe8dcMLNu31HHbxlWNwWZ3+Ynr3g5UGKljrIQ
         heKIgkU+iNV/EgW47i7fIKFgLPsROjn/ENXNLXqzAOgQFF+Zmt204RQFPJ5lfckKqK2+
         y32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rNchZrX6wjpbtjKY+B+Aes3vTPDGEdMcZKjJrdean4Y=;
        b=QcFCe2Pdo0VQouOMC5mvOaJusyW0Fo9P4JVHbwksc5ih0a/eW9MPaQE7anD1NKHlLp
         8qxFRCEsa4rkVwLu7XaQ/ngkNczyrvzsCv9f69Cg0Aqk31kj+u7Ij8H0XiGWXNLjMSf8
         ZBCS/klX18LYc+Fo3L9cFm6K+6nCGjFRc6cnst0MIBtiv2hs0T+s6z3HtZ9HHx6mmlPo
         rcgeoFkOoU+WmDHQ08WWI6zXffPDj1q156DZPchXq3OrzSW4lichA62oWPFg4w2l8G8U
         LXrjZGUkHyHXT/c8t5WDMmA4YncWZk+MilrPs5PV5x4S5XYzrNXML6eKNbC8lC+QHNLV
         ApEQ==
X-Gm-Message-State: AJcUukdwat6O2DP4V4DYgYy+qGqhO9UVrx1bQc1POs5mP6GU2VPY6AC2
        HSEKVgIQGYWb6Cav3ANS7sLExhAS/dO5tW1pgRQ=
X-Google-Smtp-Source: ALg8bN59/jxXQxQEokcDkAIcAbJdb3vfYn3U9HAkocetY4wZRmfmo9P0H7gFgq3xN0WwJjbYiT281A2n1mc01Jhx7CU=
X-Received: by 2002:a02:4c9:: with SMTP id 192mr9795503jab.2.1547790515998;
 Thu, 17 Jan 2019 21:48:35 -0800 (PST)
MIME-Version: 1.0
References: <20190118033215.5904-1-yuehaibing@huawei.com>
In-Reply-To: <20190118033215.5904-1-yuehaibing@huawei.com>
From:   Steve deRosier <derosier@drawerlight.com>
Date:   Thu, 17 Jan 2019 21:47:58 -0800
Message-ID: <CALLGbRJ74t=BpRDn5qthnqha_qLt43wvKhctF10Z+Xr=XNgafw@mail.gmail.com>
Subject: Re: [PATCH] wireless: remove unneeded semicolon
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, Kalle Valo <kvalo@codeaurora.org>,
        Arend <arend.vanspriel@broadcom.com>, franky.lin@broadcom.com,
        chi-hsien.lin@cypress.com, Ping-Ke Shih <pkshih@realtek.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 17, 2019 at 7:33 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> remove unneeded semicolon
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.h                     | 2 +-
>  drivers/net/wireless/ath/ath6kl/init.c                    | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
>  drivers/net/wireless/ray_cs.c                             | 2 +-
>  drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c      | 6 +++---
>  5 files changed, 7 insertions(+), 7 deletions(-)
>
...
> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
> index 54132af..aa1c71a 100644
> --- a/drivers/net/wireless/ath/ath6kl/init.c
> +++ b/drivers/net/wireless/ath/ath6kl/init.c
> @@ -1140,7 +1140,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
>
>                 len -= ie_len;
>                 data += ie_len;
> -       };
> +       }
>
>         ret = 0;
>  out:

For ath6kl

Acked-by: Steve deRosier <derosier@cal-sierra.com>
