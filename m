Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22A2C352AA
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 12:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C47F6218DE
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 12:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IYIfcfAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387820AbfJAMf4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 08:35:56 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37127 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfJAMf4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 08:35:56 -0400
Received: by mail-qk1-f195.google.com with SMTP id u184so11013588qkd.4
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2019 05:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8R02kNXRxfu4pSotKAW6zObEoBS2WT0sAFLmZGTDJp0=;
        b=IYIfcfAgje5CndjZQmWhIviMbdoRRukzTaAVG636GRSiicnmBQxfHoOiV+wpaMYwD5
         2D/anylaPAqkZp/jtVbKX7+2MOKJkud0ELObeWxBwqUk9mZctBOma0KfjcD7Xn4Gd3ca
         bZEYkN2L3vYHqInRUWGHdjsq4kyWBZJz526nzn4MHINmV70F/Azz1+/lJo4osxtbjl6y
         A+v6ZEfYH64wph5Y/iPUwwPWVLgNr+Al2rQ8VVQ0q95GOLNYTsGS2JJufmHX3XvzdH0P
         VsfWDTCPvQP9rwJYtnhv4q394AJjKZn1fugOUcCVRqZ0VXcokUC9zlkrZDpfScwaWNjZ
         jJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8R02kNXRxfu4pSotKAW6zObEoBS2WT0sAFLmZGTDJp0=;
        b=XqqQRwUX7uaW8apGxy1FxlRyN7f0nib/VMw/wKjBel8bq/v2T3K0qvbRh6WWWuzwlP
         BrKQ9zg7YNIOH05Few5Pw/dvkP2bpn4pMgFb36xlpiF0PyFTfhfhDM4wsBvrt9yKQSSN
         jHnh1gFATBbdJ7sfP15Kka8xNg3mX4KQxjceIGjwXksW0I0sj5wwHE1j7EJiOWEmLpb6
         sp29IISUkrNPmCuvq9l/FCjPfaRu4NuQH9hNbutUrKxqxkJuvTinTPOvHO7CLRjVK4R2
         g0HU2m+pk4M94uzCx/mL6HyiO/pM0FH5prKO5yfLCITW4Wep5pcYq+g4cuFzAHonVH7V
         G0rg==
X-Gm-Message-State: APjAAAVdn3ZjoLQF99YKdvgtdclXgp+LCik2Dm++pCln8tqrXvORXq/8
        wTpY3vNW9y+k/jvrVd6WYPNEJRF6TjoL3gSmfojefvkGdhI5YQ==
X-Google-Smtp-Source: APXvYqxuMb74HtkNiGpyLdknC2STSEnTFCy3g2oyaYuMwZLt3GAA0waYtLs0s5l4ZYIO+uzktJEUfHLsBWvuwEQ/MBE=
X-Received: by 2002:a37:76c3:: with SMTP id r186mr3806814qkc.224.1569933355194;
 Tue, 01 Oct 2019 05:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdYzYpqYbgb-9s1VPSreoosQ=BPnhzC_gKOzbGipKikk5+4zA@mail.gmail.com>
 <7b920db4e91a7e68f9eeacd95339b5f509e3273b.camel@sipsolutions.net>
In-Reply-To: <7b920db4e91a7e68f9eeacd95339b5f509e3273b.camel@sipsolutions.net>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Tue, 1 Oct 2019 08:35:44 -0400
Message-ID: <CAMdYzYq2iifpZzRAxGwjL9S65O6cL4vP1eJE-d6bq7zG-mQ7qA@mail.gmail.com>
Subject: Re: bug: nl80211 / brcmfmac broken for bcm4329/bcm4330 sdio in linux-next
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 1, 2019 at 3:32 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi,
>
> > Since 5.3 landed, brcmfmac has been broken both on bcm4329 and bcm4330
> > sdio devices.
>
> Yep, thanks for the report. I don't think you mean 5.3, as that doesn't
> contain the problematic commit as far as I can tell? That was commit
> 2a38075cd0be ("nl80211: Add support for EDMG channels").
>
> I have a fix for this already pending I believe:
> https://patchwork.kernel.org/patch/11156631/
>
> johannes
>

Correct, I was using the 5.3 merge window as the point of reference
for the linux-next timeline.
Confirmed this patch corrects the issue.

Tested-by: Peter Geis <pgwipeout@gmail.com>
