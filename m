Return-Path: <SRS0=tM6R=XW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE59C4360C
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Sep 2019 12:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F8C821906
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Sep 2019 12:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AtlepkPs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfI0Maf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Sep 2019 08:30:35 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:37453 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfI0Maf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Sep 2019 08:30:35 -0400
Received: by mail-lf1-f51.google.com with SMTP id w67so1788176lff.4
        for <linux-wireless@vger.kernel.org>; Fri, 27 Sep 2019 05:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zT+XJ8rgbvvgqu15vgJ1VYmsyRkxzmWrc4dnnHHU3yA=;
        b=AtlepkPsysu2pUUMVS1Q3NqsT7PE7X7hGG6XW/yT0Ad7VlkuzCZG7EV6kqlBSfHi5C
         D5dHO85XNeT7suWZsD0QGwOC/Eh/1O7SnlfMqrBavTdYxJCWI1m2w/3cyL9SdlQHZ2r8
         PTE7GoB9VLre9BuZemraPAVogVZUZWO2vfqq5bAB8Jd78sHFZoukn97Zr3DYxL4RMXKM
         +NnQ8DTzB7l1IBB9lg/uWosV3Xzz8m+xYGS8BKB785/RcRRcWw+XdRlpALeK5y1g0qRA
         +qGUk+hu5QkAE5b5Y4YvrfDszjKGdOhvFZ+b6yQRsA0yZISGdERfAEkeMeRhr77WoIXk
         /hfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zT+XJ8rgbvvgqu15vgJ1VYmsyRkxzmWrc4dnnHHU3yA=;
        b=cz5IU8/jhabzaGZePnpiebw3VZ5Re2tn0t8GsgxESDgrJfHtGmj6pwH0u5O1ACTpX6
         m5JI835Exa1E0jkO/Gs05A5do7lFwn6KV9OpbJGHgUfG4zLQjdXFvydDSYWFCBTchHB5
         m0V0PVZhXr0WDyYZEKvUIChrf8ASgg+ZQPTle7SV6EfEnv2EaYiUknOIwkOQhhbzFcgb
         bwN5DTB7BUyCt9zasuFt1vfVFbyne7koGCaB8WUjejJlFJZJmDvlEOHX9toqkpYAX/gB
         BzdqIjYgVonqtDdw1uOfXDoAvWX4FYXI+P4f/7lhXfonGE/eQPrvDKNX2bP8d9Q26D3P
         YcTw==
X-Gm-Message-State: APjAAAUdtp+p6wvRnrxgcnu+KvKIN6r1vika6B4dEEKRWOtFgmYkAQXG
        g+0xqfZIleAOV+CcL+obw3WZ5n/kAkoU5HyvsCE=
X-Google-Smtp-Source: APXvYqxsPZ7srG4jIoN20WSI/9CwvrgXqqJrDb/IeVfTPZ6j146WyHzeSYA8OpezFQocgLV2BbDmbNMkdh3yR1XvjvI=
X-Received: by 2002:a19:7715:: with SMTP id s21mr2567405lfc.98.1569587433069;
 Fri, 27 Sep 2019 05:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8U23ZyFnYt+ePreGjFA2VFXnpu21SPthscvJhP-5xjQCb0OA@mail.gmail.com>
 <49ded6ae8a23c29168ab7061235292ac7a853e0f.camel@sipsolutions.net>
In-Reply-To: <49ded6ae8a23c29168ab7061235292ac7a853e0f.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Fri, 27 Sep 2019 09:30:21 -0300
Message-ID: <CAK8U23bdmJGARCT=TXKyfknhmz-V0qUJ8dj0Mhko-CkvW+uW1A@mail.gmail.com>
Subject: Re: mac80211_hwsim: packets being transmitted through the monitor interface
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yes, I agree that they are different things, but I can also see the
packets through the monitor interface created via iw. Is this expected
too?

On Fri, Sep 27, 2019 at 9:16 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2019-09-26 at 22:54 -0300, Ramon Fontes wrote:
> > Hello,
> >
> > I've noticed that packets transmitted between two clients connected to
> > a hostapd AP are also transmitted (injected) through the monitor
> > interface. Is this expected behavior?
>
> You mean on 'hwsim0'? That interface is just for monitoring what's
> happening on the 'virtual air', so yes.
>
> > I can easily modify such
> > behavior by changing mac80211_hwsim, but it works only with hwsim0. On
> > the other hand, if I create a monitor interface via iw it doesn't
> > work.
>
> The two are completely different/unrelated things.
>
> johannes
>
