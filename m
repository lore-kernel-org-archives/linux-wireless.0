Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8019CC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 21:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45FA921726
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 21:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fzy8TEQu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfAVVei (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 16:34:38 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37557 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfAVVeh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 16:34:37 -0500
Received: by mail-pg1-f194.google.com with SMTP id c25so18315pgb.4
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 13:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0UEYFk0G9Y/+uJFIlHMIMqeMFmsdf+KgCHUR8jOoESs=;
        b=fzy8TEQut+ZY0sw7OPKcjYr0gfjBA4Nce+DzxjkH+mivI6M/yNCauDSQGxQ20OcFF+
         Dt/fMQaKIlHUvMyPte3+WNUTp5WxUDW4FDrl8uakDH35YKJDXWrxUGPDnixfIMcga2em
         StP4G4ihRlEPRb254ctK3Q2+LFkbH/svupAxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0UEYFk0G9Y/+uJFIlHMIMqeMFmsdf+KgCHUR8jOoESs=;
        b=Cqh+pZeXZbPNLJlvJY9BWUN/lv6LmylcOQ3Fzt9aDfehz19wuB8gZVmECCx5629124
         rSwOVOdPQXo+cVJ7NDEHodzb7ISvRpsbcEDv2jrH4LJwGzrvALvgsLjFvoAjIuxImejL
         zGsGMrKWLgiblANp6yqTlZoyXJefEl3nMlQN2v85n0g+rw7Qu87CWckHOKm+r8gttX/c
         hMkQT8O1NwN2UFbiNLDipvb9CBMWMDDRF2JD21Hyb2qc3Rhp1TcWxUZqcGX0P8m95w3F
         d7kQdTssBeB/I40o86yePVMHCwP8KghvU0nJuJQZlZwTKqTmSzXb/YLsR/Lp7+wrGjcC
         UnBQ==
X-Gm-Message-State: AJcUukfP9HjKx3kQY8+xCKytgVg71T7aG05J618orcXb2A7Unmak1tWM
        HFrUTWRc1YC+zJjR1G3RmLFqbg==
X-Google-Smtp-Source: ALg8bN4g93U7gxJuPJ95+NuHJiQjV290VsEszcDRz8M+g48a21UpPabJzKmikiOmkfdYcwUFnpIGyA==
X-Received: by 2002:a63:5664:: with SMTP id g36mr33208597pgm.313.1548192876947;
        Tue, 22 Jan 2019 13:34:36 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id s130sm35959524pgc.60.2019.01.22.13.34.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 13:34:35 -0800 (PST)
Date:   Tue, 22 Jan 2019 13:34:32 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
Subject: Re: [PATCH v2 13/13] rtw88: add support for Realtek 802.11ac
 wireless chips
Message-ID: <20190122213423.GA52826@google.com>
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
 <1542367879-28880-14-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542367879-28880-14-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Yan-Hsuan,

On Fri, Nov 16, 2018 at 07:31:19PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9ad052a..138515b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12546,6 +12546,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
>  S:	Maintained
>  F:	drivers/net/wireless/realtek/rtlwifi/
>  
> +REALTEK WIRELESS DRIVER (rtw88)
> +M:	Yan-Hsuan Chuang <yhchuang@realtek.com>
> +L:	linux-wireless@vger.kernel.org
> +W:	http://wireless.kernel.org/
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

That tree hasn't been updated in years. I expect that's not relevant, so
perhaps you should remove it? I think these days, unless you have a
large amount of patches that deserves its own tree / pull-request,
you're probably just going to be covered by the wireless-drivers /
wireless-drivers-next trees:

NETWORKING DRIVERS (WIRELESS)
M:      Kalle Valo <kvalo@codeaurora.org>
L:      linux-wireless@vger.kernel.org
Q:      http://patchwork.kernel.org/project/linux-wireless/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git

Regards,
Brian

> +S:	Maintained
> +F:	drivers/net/wireless/realtek/rtw88/
> +
>  RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
>  M:	Jes Sorensen <Jes.Sorensen@gmail.com>
>  L:	linux-wireless@vger.kernel.org
