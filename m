Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083A6C282CD
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 02:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0FDE21738
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 02:41:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mlVDL5f8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfA2ClW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 21:41:22 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38127 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbfA2ClW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 21:41:22 -0500
Received: by mail-ed1-f66.google.com with SMTP id h50so14758958ede.5
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 18:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=npbPi6NRCsGR1JrtNhGcxLfAUcnSVhalsnxt1P8YDII=;
        b=mlVDL5f8wpczlou0MKsyLdTj/ST/31DY/j4/X/GN6fypsSlAZ2NDpSJQioDnPpPvIg
         qSlmFi5dpQOn3tt2ARp3+g407jomqXHLg+Wk1gkApsNuBl3/WIkSP2dODEQ5IrZAMWY/
         BQzBzhB7xGHxM9L/CSnifwE+Utd3UP8C0HCgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=npbPi6NRCsGR1JrtNhGcxLfAUcnSVhalsnxt1P8YDII=;
        b=WMjk1Fs7uvD1ggaHfIsEzmioxHQQmk8jADENxZeowkxIOwoFUL864rWtBu8a9faI27
         8huq5yEMs7Yvq5TvrXSR9EkZadcCWfvoBFSS2xP74RNXKPg/lq4zsh7HA5ea7LAre2ub
         sXqOdvsUUt6qCRwWzx8oSbk8X4INbR8QGpmS/GguDBIoXyZbpUilRTDa9GqtxaBLTQur
         C1oBVLNp0lJ3N2LDdoQdxuPmJMknQMBa3zHLVw8o9Ig4uZn17Qk29OJwv0HwdgbH00h1
         F7miUnAgvjGiTlGYwtcCHC9ruE0W4EN77a0oQqoO3mcj83CBiGUWhDZs5O0wzaO5YIKC
         MIJQ==
X-Gm-Message-State: AJcUukce60SCTaHt5T0GobxkBtGONoBJuWqRCZXNZFDtYo/u/8yx/KwU
        cEV6GaNulIu5c8Hr5fr6BW2rqjphAoY=
X-Google-Smtp-Source: ALg8bN7l1UDLWERHYbDQcspBshcD6E8Fc42/VacXGoI1BOgVPfEoUHiD6NgoJsEBqvhejWqasxyrkQ==
X-Received: by 2002:a50:c017:: with SMTP id r23mr24336459edb.278.1548729680493;
        Mon, 28 Jan 2019 18:41:20 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id w31sm14175479edw.82.2019.01.28.18.41.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 18:41:19 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id g22so14758619edr.7
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 18:41:18 -0800 (PST)
X-Received: by 2002:a50:b487:: with SMTP id w7mr24043399edd.72.1548729678597;
 Mon, 28 Jan 2019 18:41:18 -0800 (PST)
MIME-Version: 1.0
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net> <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 28 Jan 2019 18:41:06 -0800
X-Gmail-Original-Message-ID: <CA+ASDXM=+_U+SrXhm3pq4Zd7gkvHwkRAZw+OGmzg=6+0+=iZGg@mail.gmail.com>
Message-ID: <CA+ASDXM=+_U+SrXhm3pq4Zd7gkvHwkRAZw+OGmzg=6+0+=iZGg@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 6:15 PM Tony Chuang <yhchuang@realtek.com> wrote:
> This NULL pointer was found months ago and has been fixed already.
> Thanks for your test :).
> I am holding the patch to fix it for the next patchsets.
>
> BTW, since rtw88 has not been accepted, could I send next patch set based on
> this patch set as long as I explicitly mark that the next patch is based on the previous one?

I'd normally expect that if you find major bugs in your initial driver
submission that still isn't reviewed/merged, you might as well just
roll the fix into latest version and describe it in the
cover-letter/changelog. This particular change is so trivial it
doesn't really seem to deserve a separate patch.

(It would also help people like me, who may very well run into the
same bug when they get around to testing/reviewing the driver.)

I also don't know what the contents of the "next patch set" is -- if
it's a lot of new features, maybe they don't deserve to clutter the
initial submission, but if they're bugfixes like this, it seems like
you could just fix the original patch set.

But that's just my opinion.

Brian
