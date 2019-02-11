Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39235C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 19:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08C1621B25
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 19:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oH8SwQsD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbfBKTV4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 14:21:56 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39074 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfBKTVz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 14:21:55 -0500
Received: by mail-ed1-f66.google.com with SMTP id b14so27699edt.6
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 11:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uuPKGMWk0CKHmAqXuZ+zrX3AMH6iT0BU/0sLG9WrhKE=;
        b=oH8SwQsDoSIMEnTApfRe0KusZy/MuOIsuYpJTWj3VcGPgD4gIjdFKRCs1U9dHk7Oc8
         1Hfiabp2OdidYOCM3H+gpZ1WuJfEv6JEDEyc91iF0YAH78HMmjFbFsy3adGeBg6Y/ZPK
         3yZJHgJS+M91Z0nuv6NccyCmqIUTVRcGw/dss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uuPKGMWk0CKHmAqXuZ+zrX3AMH6iT0BU/0sLG9WrhKE=;
        b=bMi5/bz7N8uHPuhrVGLZ8WRvAj4uZ9vjL9iz/NhsXWhuK2Z7t8wDUFE623p3ZE0gfS
         kOHOekeWTfXYCmVZMYXwTVbSiOIWbYDXMCTQFrPs8CEIC77uDesYjo+KMymsgQWI7CzJ
         MsFjW2r21aW5ZRM+0leVxThLw0AGx5xR/6y4Wr2gxu11IqxN/Lt+qO/eBwhOg9Jt+EYU
         8WvDRC05AduAOyn4FMGYnQzjJSq+QiTJNAzKhVm1EcoZ/pnAsHQpgQoMoBqRLkvS7cnq
         HX7tYUOSfzGCob5DqvlaLYwG/Am3mgdlJV/3PbcKOe3hy7C0nFeQJ2Vi2vwSX1OZ1d81
         x0Cg==
X-Gm-Message-State: AHQUAubhaZHfftXWRvTVXzjAdGmAEzAlBLDCZHVQ5yifQg46ztpB7eGE
        JdgLSS5SvkSSRecPWBAT/5wXiFGLdUg=
X-Google-Smtp-Source: AHgI3Iaw5sxZ4XHgibB0hadS0X3IzwcVHCrBTa2oewbH7LhUSqp/kaHeEWiz6qQ5IRN8kQkhC6X0VA==
X-Received: by 2002:a17:906:1191:: with SMTP id n17mr28467604eja.47.1549912913816;
        Mon, 11 Feb 2019 11:21:53 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id c14sm3129331eds.73.2019.02.11.11.21.52
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 11:21:52 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id o59so43782edb.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 11:21:52 -0800 (PST)
X-Received: by 2002:a17:906:b886:: with SMTP id hb6mr27624923ejb.71.1549912912069;
 Mon, 11 Feb 2019 11:21:52 -0800 (PST)
MIME-Version: 1.0
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
 <1548937297-14660-2-git-send-email-yhchuang@realtek.com> <20190209030756.GB163159@google.com>
 <F7CD281DE3E379468C6D07993EA72F84D17A2A22@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17A2A22@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 11 Feb 2019 11:21:40 -0800
X-Gmail-Original-Message-ID: <CA+ASDXP5PCDnQoLXVnCkjyRoM31DbieusJa214_Km_BTiZMPkA@mail.gmail.com>
Message-ID: <CA+ASDXP5PCDnQoLXVnCkjyRoM31DbieusJa214_Km_BTiZMPkA@mail.gmail.com>
Subject: Re: [PATCH 01/24] rtw88: report correct tx status if mac80211
 requested one
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 10, 2019 at 8:31 PM Tony Chuang <yhchuang@realtek.com> wrote:
> To fix `iw wlan0 station dump` display, I think I can just restore one line
> in pci.c. That is, restore IEEE80211_TX_STAT_ACK flag line:
>
> +                       continue;
> +               }
>                 ieee80211_tx_info_clear_status(info);
> -               info->flags |= IEEE80211_TX_STAT_ACK;
>                 ieee80211_tx_status_irqsafe(hw, skb)
>
> And with some modifications, such as IEEE80211_TX_CTL_NO_ACK check.
> Then we can better reporting ACK status for data frames without
> IEEE80211_TX_CTL_REQ_TX_STATUS. This way we can also ensure the
> connection monitor can work. (but it will be no loss)

This seems like a small improvement. It means you will almost never
actually report a "drop", but that's still probably better than
*always* reporting drops I think. I also see that there are handful of
older (likely poorly-maintained? or perhaps similarly-constrained)
drivers that have a similar default behavior -- they report ACK by
default, apparently without any particular notice that the packet was
actually ACKed by the receiver.

But I'm not really a mac80211 expert, so someone else may have better
ideas here.

> It's not buggy I think, if firmware is not reporting status, something must
> go wrong. And after some test I know why you feel it's unreliable.
>
> For WOW implementation, we modified a lot in fw.c functions.
> And correct some driver-firmware interface behaviors. To make sure the
> firmware is running as expected. But the patches are still holding in my hand.
> I can attach them in this patch set, and apparently I should. I will separate
> them out of WOW patch set and resend again.

Ah, well I don't know at what point we should cut things off, but I'll
stick to my stated opinion from previously: all bugfixes will help
someone like me. It's tough to differentiate firmware bugs from driver
bugs, especially when I have absolutely no firmware documentation :)

BTW, while we're at it: is this still a reasonable firmware to reference?

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=338684a0c7760644031483311464c7cf5b3aac94
rtw88: Add firmware file for driver rtw88

> I think we should keep this feature. Because we actually can report status,
> despite not for every packet. The only problem is when we use `iw wlan0
> station dump` we could get *no* packet loss (like I've mentioned above,
> report TX_STAT_ACK for every other packets not have
> IEEE80211_TX_CTL_REQ_TX_STATUS). We cannot accurately report
> everything by firmware report, it takes too many tx bandwidth, and
> the performance will degrade severely. If we really cannot accept reporting

Yeah, it does seem like it would be pretty heavyweight to do this C2H
reporting for every frame.

> tx status this way, we need to find another way to solve it. That means I
> need some time to investigate and test connect monitor system and get
> a better report logic if we drop the REPORTS_TX_ACK_STATUS feature.
> Or if you have a point of view, we can discuss about it.
> Thanks!

Regards,
Brian
