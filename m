Return-Path: <SRS0=+7Bs=YY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E23CA9ECB
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Oct 2019 20:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1472B2080F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Oct 2019 20:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iiF38AcE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbfJaUBV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Oct 2019 16:01:21 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44076 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaUBV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Oct 2019 16:01:21 -0400
Received: by mail-qk1-f196.google.com with SMTP id m16so7982744qki.11
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2019 13:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JUBFKZGmHFkr4Miw5eswIUy0sPhQ+vsywESEyWJvYwI=;
        b=iiF38AcE2k3QKeaJWSpegl3N2jjmSwdDJIGs7ZYx81MMr/bqw7kQOa9m4J4f8ee7t4
         s9k+6ZRQtDezai+BT80v6FKmWNKkzzAUzng/qRyUOGpasBd6NHrR5qPvSoqfLhBIG7ok
         a9dsBOqRDQ5E4eSGgis5Bat8Tjhxqu1X39JV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JUBFKZGmHFkr4Miw5eswIUy0sPhQ+vsywESEyWJvYwI=;
        b=ROata3rXAqnyIXOJTVwWVeLBQzKipgGFKB/eWkREJzXX5pBRPN1oSgbF2pLhjpqNCv
         g7ngay97LyZZ1a5J82GK6jojpLF+ncFSIpGeKQC8RpGL6YiNePA8WceIncvRbjM/qMfm
         bjqWt6kzK3OgHzvc+fpbyNguS39VuV4Ti8+EvsZTQRmj16gxrEWw6b3xiSch3ojJHcH9
         9zEUsHK9wAdbJ7GNRx2bocdo0vVkUDvLCMcMoZgWnu2Ie1xTLBVCvenfflUFh2EWKTeZ
         gYaekjAo2W7nsdZXw70xZDVLvUWgHGr3FStBwAtsl4E6V4NbHe6y0dmzlbEbFlvbh6XF
         lGcQ==
X-Gm-Message-State: APjAAAVvP7I+pRJXgIpefl46aPwFN8FhFm7DqJRtICHI39FLQIKfiEJs
        nDULYBzAKKymy52Ci4v1oxTZAA8IaKs=
X-Google-Smtp-Source: APXvYqwCSuIPAMROrRzazwmaw55hqU+WuVEGDW6BnZoMymPH3y1+71k1GHnMGq7FsLa28ogSRBROhg==
X-Received: by 2002:ae9:ec1a:: with SMTP id h26mr6919083qkg.156.1572552079542;
        Thu, 31 Oct 2019 13:01:19 -0700 (PDT)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com. [209.85.160.177])
        by smtp.gmail.com with ESMTPSA id o201sm2153752qka.17.2019.10.31.13.01.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 13:01:18 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id g50so10229236qtb.4
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2019 13:01:18 -0700 (PDT)
X-Received: by 2002:ad4:4dca:: with SMTP id cw10mr6599220qvb.251.1572552077644;
 Thu, 31 Oct 2019 13:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191025093345.22643-4-yhchuang@realtek.com> <20191031075911.3CCB86079C@smtp.codeaurora.org>
 <F7CD281DE3E379468C6D07993EA72F84D1914F4C@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1914F4C@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 31 Oct 2019 13:01:06 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPzLJ0OkuN0-BHqxGSBuVqQg6=eyg+PizLTCj+5bJ_5kw@mail.gmail.com>
Message-ID: <CA+ASDXPzLJ0OkuN0-BHqxGSBuVqQg6=eyg+PizLTCj+5bJ_5kw@mail.gmail.com>
Subject: Re: [PATCH 3/6] rtw88: use a module parameter to control LPS enter
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "g.schlmm@googlemail.com" <g.schlmm@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 31, 2019 at 1:17 AM Tony Chuang <yhchuang@realtek.com> wrote:
> Or I should just change the
> value to a better one. By our experience, set this to 50 is a more reasonable
> value, such that some web surfing or background traffic wouldn't make the
> driver to leave PS mode.

FWIW, I think choosing a more reasonable default is definitely a good
start, as long as this choice doesn't have huge downsides.

@Kalle: FYI, this (set to 50) is exactly the change that Tony is
recommending to me for my distro, and I have the same qualms about
supporting a growing number of module parameter tweaks like this. So,
thanks for pushing back :)

Brian
