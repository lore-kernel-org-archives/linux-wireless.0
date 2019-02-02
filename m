Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A70DC282D8
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 02:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248542148D
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 02:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kb2KW8qi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfBBCvD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 21:51:03 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41067 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfBBCvD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 21:51:03 -0500
Received: by mail-ed1-f66.google.com with SMTP id a20so7047001edc.8
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 18:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PWafC+4O2CB9XWGOVTduEG7m0W3QsKfVaF7EjD+9mpA=;
        b=kb2KW8qixjghXmF+r5SyUmkgnhn014/S2Tl/zHdCFZCBic/i8pysIhEJBV4sPq6+la
         spetUlfV8mrDNaoyuk4zT860xAiuA7qFCPpwnjAKw5HWJDHSzpgypdBHTECTD2h2zlyA
         cWRvjKvHCAvWC0J8k7bfPFTspv6ktGTb5eDd4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PWafC+4O2CB9XWGOVTduEG7m0W3QsKfVaF7EjD+9mpA=;
        b=gj7LVUCUJP+3PFuhlOFlMtmDawd5HKRLf1FrX+TNH30yPA/inQGR9g/6BM0yvmg8Ib
         2vuX0psgqqfwvAlRPWs6LtBULtvbeqWYvydRREHITEsvlplDwbuz8l44+dwdlHSnYhcf
         fDxPE4uThh1JlF/VRDwwh8l0dkyOvjxmJvJp5xgNh5R8pCqrylAFr1cA75vJbT4pqWSA
         FxIrM4GeB3RkwCqgfQ9At9bmZ6owNCFajiubfOc11O3gMpDWxRNj84fQA9S1m0EuGZUQ
         gy0lFBH+THYFiqJI2MduzJ4JnrMkFRbMJy1hgCchGq5bq05fRy34TElCykCf8t5vPCok
         kv9Q==
X-Gm-Message-State: AJcUukff3FJ7HGqRrSXvzcdgB+4yOXYPM1uuEWu0TyJ3I4flQDHN61Bo
        lOWb4nCdkmLa0f/hOqo6nzQdp2yqCXA=
X-Google-Smtp-Source: ALg8bN5UumSsdk+TOqVpqX5zOh5FnoxrySmcIxmCe4ojO/blNL07pAiJeW6g9k0nntdzKjbbhT8dPg==
X-Received: by 2002:a17:906:f146:: with SMTP id gw6mr37107246ejb.176.1549075860364;
        Fri, 01 Feb 2019 18:51:00 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id y3sm682400ejc.34.2019.02.01.18.50.57
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Feb 2019 18:50:58 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id b14so7060538edt.6
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 18:50:57 -0800 (PST)
X-Received: by 2002:a17:906:68c8:: with SMTP id y8mr31171207ejr.87.1549075857286;
 Fri, 01 Feb 2019 18:50:57 -0800 (PST)
MIME-Version: 1.0
References: <20190114153558.972-1-chunkeey@gmail.com>
In-Reply-To: <20190114153558.972-1-chunkeey@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 1 Feb 2019 18:50:45 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMvFZNcyTeuJ5_q62XW+hME41nPUoTxrafqDB94GqribA@mail.gmail.com>
Message-ID: <CA+ASDXMvFZNcyTeuJ5_q62XW+hME41nPUoTxrafqDB94GqribA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: implement set_base_macaddr to fix rx-bssid mask
 in multiple APs conf
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello!

On Mon, Jan 14, 2019 at 7:36 AM Christian Lamparter <chunkeey@gmail.com> wrote:
> Part of the "setting an alternate MAC" issue was already tackled by a
> patch from Brian Norris:
> commit 9d5804662ce1
> ("ath10k: retrieve MAC address from system firmware if provided")
> by allowing the option to specify an alternate MAC-address with the
> established device_get_mac_address() function which extracts the right
> address from DeviceTree/fwnode mac-address or local-mac-address
> properties and saves it for later.
>
> However, Ben Greear noted that the Qualcomm's ath10k firmware is liable
> to not properly calculate its rx-bssid mask in this case. This can cause
> issues in the popluar "multiple AP with a single ath10k instance"
> configurations.

I'll admit that
(a) I wasn't testing AP mode, or any similar configuration to this and
(b) I'm not super familiar with the firmware features involved here.

That's to say, this patch could very well be completely justified and
correct, but I may not the right person to analyze it.

I do have it on my list to test out though, so I'll hopefully chime in
again eventually.

Regards,
Brian
