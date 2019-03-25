Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F14C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6979120879
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:36:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="j/RVjQgj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfCYOgS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:36:18 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41338 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbfCYOgS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 10:36:18 -0400
Received: by mail-pg1-f196.google.com with SMTP id f6so2559867pgs.8
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 07:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MFJd7OZVMORPrw/Av5yh6NtCleI3jAm/2uYTUmZXhd0=;
        b=j/RVjQgjLCb9SYK71wTWWncgXnoxeklgHUP+aLvQmu8YhFgoW3tL7ftIe7vbY+Znzm
         l+Cd4rFNlg4FCwAJoJBhwqlp9zm6KoepPVfKV7uoNrsMBKTPD50755yEwWgqH0rckUgR
         xKGiWhjNku/NOOUOQiqlUc/h0uIWSXj8dCkxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MFJd7OZVMORPrw/Av5yh6NtCleI3jAm/2uYTUmZXhd0=;
        b=qJpwXc1EPY3s1s0I5RE77dGguyGhavoedjZ2QAxYaRX5loE+XnTKC6Q6vs1Taz2406
         NETYBV2c720PGw7GAO+8BhEtItZ7qeZMFuPML26/+1MNzb5IIE4m5ElwvU6o9W5Jx3A9
         YyvM+3Z5f+SwOp3p6ATMDJ9Ayf1Bh8PT+NZG2p0899rn+rFuRJ1IiACyc36ldj11IQgK
         PxEWNQpHgCXO/6MkgtBsOEWwrc7aVpdM959ByKHUaGG/kTQGyOeKVcRvftH7iqgaL0nQ
         4hHwWYxjvyA3didY5igP1ixyoDwGopPoDdhP4UhPaqxofm4hrOJf353YZY6VyeZ6JH3f
         pVwQ==
X-Gm-Message-State: APjAAAU7swOiuThOz/7bPjEvAjbtyTJlWU9mQ5e5+CVjychVKnH4pg2K
        ziNazhpmrFfJRoZ1vA4OYTiLpw==
X-Google-Smtp-Source: APXvYqx7eoc6Ql41ArwjOlh6alz69tsLLYre+JLIaRG74/NrsNvm6rPEHbbgdO+J1rTNjihGPVi+TA==
X-Received: by 2002:a63:ac12:: with SMTP id v18mr22339083pge.111.1553524578105;
        Mon, 25 Mar 2019 07:36:18 -0700 (PDT)
Received: from penguin (189.8.197.35.bc.googleusercontent.com. [35.197.8.189])
        by smtp.gmail.com with ESMTPSA id v20sm4854876pfn.116.2019.03.25.07.36.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:36:17 -0700 (PDT)
Date:   Mon, 25 Mar 2019 14:36:11 +0000
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        sgruszka@redhat.com, pkshih@realtek.com, tehuang@realtek.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Message-ID: <20190325143611.sjwwjqtrftxntwyk@penguin>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, Mar 13, 2019 at 12:13:49PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> rtw88 now supports RTL8822BE/RTL8822CE now, with basic station mode
> functionalities. The firmware for both can be found at linux-firmware.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> For RTL8822BE: rtw88/rtw8822b_fw.bin
> For RTL8822CE: rtw88/rtw8822c_fw.bin

> Potential problems:

>  * TRX statictics misleading, as we are not reporting status correctly,
>    or say, not reporting for "every" packet.

By the way, I see earlier RFC versions had similar comments/questions
from Stanislaw and Kalle that I had too. So at least Kalle didn't have a
great answer either on what to do with hardware where it is inefficient
to get ACK reports for everything :D But least you did add a little bit
of comments this time, and fixed up some of the reporting.

...

> v5

...

>  - use macro instead of ugly struct layout with #ifdef __LITTLE_ENDIAN

BTW, you technically could still use a struct there if you'd like, but
removing the bitfield / __LITTLE_ENDIAN handling was nice, thank you.

>  - simplify efuse logical map parsing function

Much better, thank you!

...

>  - enable DMA sync to avoid pci bus timeout

...

> v8
> 
>  - add prefix "rtw_" to *_rates and corresponding *_sizes, otherwise
>    the extern will confuse the linker there are multiple definitions
>    with brcmsmac driver

I can't say I've closely reviewed every bit of this driver, but I did
tackle significant portions of it. All my comments have been addressed,
apart from one relatively insignificant piece that I re-commented on
this version. So:

Reviewed-by: Brian Norris <briannorris@chromium.org>

I also gave 8822CE some moderate testing, and while I'm sure it's not
perfect, it's at least stable, and it's in much better than when I
tested approximately v2 (as Tony has rolled in a lot of fixes since
then):

Tested-by: Brian Norris <briannorris@chromium.org>
