Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59408C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 15:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 260FC20863
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 15:43:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VkbJHWV/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731888AbfCZPna (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:43:30 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39909 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfCZPna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 11:43:30 -0400
Received: by mail-lf1-f67.google.com with SMTP id m13so9041997lfb.6
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2019 08:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3pOMhhWI0UkSM888lstYWoQSIcrIv1qyI6eat0fRu9Q=;
        b=VkbJHWV/aGo3qeRJy2obZuVCbIP+XDZXeJDQzeVuxZvZrWIgZJPjjROF4cWrUO7yhl
         EEEpO5QnZ2kZ0S4tV3nHMImbABNpS6n289T+EwXQnXYZMq9jO/L1HEkrcifDaoBLQ6BO
         ldPD8HbdZaUdfOI0hd5wGVdyYatR4HYzws9Us=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3pOMhhWI0UkSM888lstYWoQSIcrIv1qyI6eat0fRu9Q=;
        b=Qex8wSWwT23g7WjKzZQM27Wwtck4U9Chfo12jOf1CdBEk722Hr3lyNHtBo4aXtcKhd
         degNby2HbQ+nLhaBandu0Ip8Q3ouEGJNdOyymL3vUBuZfY7nFlT7xZFSIXBcVlS6Tm4E
         0OfHURSaYir4y5rpGd1rgeQC9zXq4wDwdqbE1ZOt5KuxBZhcwIgzvSj3JJ6wvcy9OsPD
         G/gb6o4oPOQ8jcIfG197CfkAV+pWsjeK9/5zu3iPDdwrl6pTbuWv9nHQSka5ED0szz3c
         3WDSFl9x1hxECnyJgni2MnTzus4URc+UMoTq9NaRMLr4Tcrq+1CILHmX0bAYDIZUnbba
         34sQ==
X-Gm-Message-State: APjAAAWgWHrYBJenGmysvEQOlsWy8MvNQrGtQr+wmfuha/BcRnTK9DpB
        YAKGDzkv17CYwC1xbRt5RlQzVes3iLM=
X-Google-Smtp-Source: APXvYqylDa898CyDeU1sah7BIn/CJWOG4m6roDoj7pwb33rn0bJUQXadLYemX8kqBGjynmm+jIF5nw==
X-Received: by 2002:a19:c90a:: with SMTP id z10mr15741239lff.40.1553615007790;
        Tue, 26 Mar 2019 08:43:27 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id k19sm3954287lje.7.2019.03.26.08.43.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 08:43:26 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id v13so11571794ljk.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2019 08:43:26 -0700 (PDT)
X-Received: by 2002:a2e:7d04:: with SMTP id y4mr9599862ljc.193.1553615005985;
 Tue, 26 Mar 2019 08:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
 <20190325143611.sjwwjqtrftxntwyk@penguin> <20190326075414.GA8598@redhat.com>
In-Reply-To: <20190326075414.GA8598@redhat.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 26 Mar 2019 08:43:13 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNcCNcBmiHi468p1foWgSOXy9Mt8o+CD17Bd4PqhUXFoA@mail.gmail.com>
Message-ID: <CA+ASDXNcCNcBmiHi468p1foWgSOXy9Mt8o+CD17Bd4PqhUXFoA@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 26, 2019 at 12:54 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> I also tested on RTL8822CE we generously got from Tony. I replaced wifi
> card on my laptop by the 8822CE device. I have warning on resume from
> suspend (see below, it could be mac80211 issue though). But network
> connection was established after the warning and in general device
> works stable for 2 days now.
>
> Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
>
> [16158.826873] rtw_pci 0000:02:00.0: start vif 00:e0:4c:09:94:0f on port 0
> [16158.827693] ------------[ cut here ]------------
> [16158.827694] wlan0: invalid CW_min/CW_max: 0/0

I didn't test system suspend/resume with this driver yet (oops), but
FWIW I've seen reports of this warning on every other mac80211 driver
I've supported. I don't think we've ever totally resolved them and I
haven't looked closely into the reason for the WARNING.

Brian
