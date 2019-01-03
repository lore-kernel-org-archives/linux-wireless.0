Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2982C43387
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 10:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 980802073D
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 10:06:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=raspberrypi.org header.i=@raspberrypi.org header.b="kzxouBvr";
	dkim=pass (2048-bit key) header.d=raspberrypi.org header.i=@raspberrypi.org header.b="HhfAKrGi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfACKGE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 05:06:04 -0500
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:7329 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730589AbfACKGD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 05:06:03 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2019 05:06:02 EST
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x039s9Bn015200
        for <linux-wireless@vger.kernel.org>; Thu, 3 Jan 2019 09:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raspberrypi.org; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type; s=pp; bh=ASY7dSf3pxrJAAxsFWzpgSGMjJvJ/BpWmZcrDzbLq6o=;
 b=kzxouBvr0PaRF7Cg3Y1RbuoZX7t7vGT9k8SLEF0BeDbqKyXHEt2WreyFRa4984Cb48H3
 0Mi2/z8973o7D39P91kC/DXH17Xv9iVL5EtGQMxvSoFXQpDCHQLVcqc/1v4z70GZug5d
 dBSJjldFeqNZ48A6CiGvk1ilx7u0g1lZ882iGoKGPlFUjzS9wO9QzEL0v/XYJka7ACDF
 eq9HI7FzQxO0uunufsYYZUyo7lqGLvgD0+AMApttiQ1Lu0EdW86MbPnJq3MbrAgTXZ0r
 rEMgk44yAlHK7zAw0Ihcq6abxqkTn46nya3Ltlhkzt9IKF5KWXGQtZ6F19iR46DVs5jY Rg== 
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        by mx07-00252a01.pphosted.com with ESMTP id 2ps9b986wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2019 09:56:25 +0000
Received: by mail-wm1-f70.google.com with SMTP id e1so8802939wmg.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2019 01:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ASY7dSf3pxrJAAxsFWzpgSGMjJvJ/BpWmZcrDzbLq6o=;
        b=HhfAKrGia5XQgmQ44p7FE8u7mi5yW7PjU3G/+x7NM+jlQ9u7wUVTzmZvAKI0XoBh48
         hdXWyqtscwMb9H2JmTNwh4rDj5G2U8MBRg4/WCgZl93bIyDFae0kJxD6t81iKCMqvAoQ
         zJTPblWH1pcDuLSXbsJl+r23vniNMgV8XzLgAHGsiJRpH10AbHYyjfbILyEfFij92WCv
         dSBYTq0Zcr6pyY4F/HdGC030iDOkO7hXBVhz4JoMKhNrTSUhA1dPhaSIpyUgKtIK6w2I
         WePJix8Z/G2cx5KhNynB9KcEzn+z4WnMr3GGajdkMjiGOFz3Y5yIRm4T03lAJyI/88AK
         MVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ASY7dSf3pxrJAAxsFWzpgSGMjJvJ/BpWmZcrDzbLq6o=;
        b=SPMyuXOsjyUP/2A8MiUjxfye0fGUC7NMdGHYUZ9GfMDxfSVzXq1by3sYjj4cubOJ2c
         NRXyZieG2uP/yCfN9SeF76E0MJR9FzZ2vWd59zA78cuU61hglWX5hyhqz8/hGh+1FOsz
         0M/CuLt+ymdtBZJR8uewWz8u/goZMW3+2SVELdMmoOUJXFG4jFuJMRRQtC+N4yPvx0JT
         9Z0gEJcGWeGUWRqpiyaYAERsYsxiPODNOmepF127vkYIXeIeIJ7adUsKJ4b7IdXD6IXS
         KkUOLlytLQtPyHJelt28xpdc7HMLSZaMyHDILqmxX56LGF+G6ydSsi0jPGkceLczFMez
         WMWA==
X-Gm-Message-State: AA+aEWbIWNqXKSSsSdKiyBh8NUXW92FEHitZLywRpmh2P0xcE/DF4Eg4
        L8wr0C5TnpuBl+IAHLDMGKE36X9DkLmCvwBQAI6fbACelomhfp2X+UHlySKfcBhW4qytU465O5s
        BkdhbbMWif0YaTPWD9eY033wT22KrqNNfm6rz+NJWsVs=
X-Received: by 2002:a1c:aad2:: with SMTP id t201mr36303247wme.148.1546509384765;
        Thu, 03 Jan 2019 01:56:24 -0800 (PST)
X-Google-Smtp-Source: ALg8bN7QVtnkckxj/+LmPbiSRqzKyfUTNMCyzyjJDKVsaiKl3Nse+BbxMj4H8Iq7ww14oPhPRHYQD7I+6W/guxDtE1Y=
X-Received: by 2002:a1c:aad2:: with SMTP id t201mr36303226wme.148.1546509384437;
 Thu, 03 Jan 2019 01:56:24 -0800 (PST)
MIME-Version: 1.0
References: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com> <1546501565-40752-2-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1546501565-40752-2-git-send-email-chi-hsien.lin@cypress.com>
From:   James Hughes <james.hughes@raspberrypi.org>
Date:   Thu, 3 Jan 2019 09:56:14 +0000
Message-ID: <CAE_XsM+mdHkwMF3PEimVJBpLd=oMmuvK1uDdA7y8uJT8hYNfbA@mail.gmail.com>
Subject: Re: [PATCH 1/2] brcmfmac: fix system warning message during wowl suspend
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-03_04:,,
 signatures=0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 3 Jan 2019 at 07:46, Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com> wrote:
>
> From: Lo-Hsiang Lo <double.lo@cypress.com>
>
> There is a system warning message, warn_slowpath-fmt, during suspend
> while using supplicant join AP and enable wowl feature by IW command.
> It's cuased by brcmf_pno_remove_request path can't find the reqid.
> This fix will not go to remove pno request function if there is no
> pno scan.

Typo in the commit message `cuased`

>
> Signed-off-by: Lo-Hsiang Lo <double.lo@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> index ffa243e2e2d0..55974a43796a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> @@ -496,6 +496,11 @@ int brcmf_pno_stop_sched_scan(struct brcmf_if *ifp, u64 reqid)
>         brcmf_dbg(TRACE, "reqid=%llu\n", reqid);
>
>         pi = ifp_to_pno(ifp);
> +
> +       /* No PNO reqeuset */

Typo. `reqeuset`

> +       if (!pi->n_reqs)
> +               return 0;
> +
>         err = brcmf_pno_remove_request(pi, reqid);
>         if (err)
>                 return err;
> --
> 2.1.0
>
