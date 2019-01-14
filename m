Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB79C43612
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 02:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA0B20850
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 02:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I7G6e/lR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfANCVG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 13 Jan 2019 21:21:06 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:39925 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfANCVG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Jan 2019 21:21:06 -0500
Received: by mail-ot1-f41.google.com with SMTP id n8so18062768otl.6
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2019 18:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p9TUJixXmO6v9iuAOAjySKdXuf4wZMpYlJGhsVhllLY=;
        b=I7G6e/lRv+64T/LOgmzyVCUbV08+/XWjAvGtsryHeAHalPPWIs3YPEEh6/EU2EaDrq
         VSNGoOjDufm446nOU+spdCLHAT0ct8AXiugJtsoBL+LWt3gc05Jz4j9CWBdadSAi+O7D
         a+7lVkxXVHKYA03wgRDq6zrqiKk4Dz2eRl1vtRffzs96Ynnd7JC+zXETaT/qVzyAUzq+
         BYp1abB3MwKRk6yYBG3M1uOZIHky0eR3vpmPrmExqbS6nxtbJ1fOv+7283nZoZlbRJqx
         Bplvr26aFvF+etQFrzWDTbaz+kYk07za5MWgakIbl8qWBrxwoMCrIy0CRBgExVPasiDv
         pssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p9TUJixXmO6v9iuAOAjySKdXuf4wZMpYlJGhsVhllLY=;
        b=bz02JPvfw4//8C3lM99e8CNR8PnE/ybvys8SRToAYMZY7eT0+5kfKCeLv/HFMhHoWO
         e/G0HNu/rxCs5VY0mutkGpXsa+KzelOQ5Unc9F0I+p88fp3LtisJ1pn/jX7KLnKNXLOh
         ulE8XamF4I1ULIEj7udgwbzT9ojAYDFHtICnQ6210/fV+g3/zMCpH+S0ZHvdSmgN9372
         PtnevndGYqmgdfmk+pgI5zk04h7BE6PeU53S75JnAliL2Ui3aKxSpEZj6YmGbky3cAOV
         o46uJjr1FkxoN+1mmU4HPrPbV7XJ5N8oVEeBYhzcWZz3ajRMhqaZAeCqPz2qgPxSAA5G
         nSaA==
X-Gm-Message-State: AJcUukcYxWn/De9kAm18D3rFcXtt5o/j6LgMLKyJjkh/jTpra5Zb8m2s
        jlxY5uGVUYPTT7Ilv8jEMF8eK2Eq6Ch25kby4Rc=
X-Google-Smtp-Source: ALg8bN6Ys++9qCDQjLXoHuxg6Jt0brnxb3FHg7KdsihDwe/9pJW2tWvlzdh1NaFyN1seMf9tQ+5zMNlfLpgTjL7xSck=
X-Received: by 2002:a9d:2aea:: with SMTP id e97mr16164433otb.206.1547432465381;
 Sun, 13 Jan 2019 18:21:05 -0800 (PST)
MIME-Version: 1.0
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com> <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com> <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
In-Reply-To: <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
From:   Rosen Penev <rosenp@gmail.com>
Date:   Sun, 13 Jan 2019 18:20:53 -0800
Message-ID: <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Jan 13, 2019 at 11:00 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> >
> >
> > On Sun, Jan 13, 2019 at 5:33 AM, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> >
> > Direct. No VM used. This is the only peripheral causing this issue.
> >
> > Is the device connected to a usb3.0 port? If so, could you please try to connect the dongle to a 2.0 one?
> >
> > I tried through a USB 2.0 port. Shouldn't make a difference as they both use the xhci driver.
> >
>
> mt76x2u supports scatter-gather on usb 3.0 (not on 2.0)
Tried a USB 3 port. Same result.
>
> > Could you please double check if IOMMU is enabled?
> >
>
> Have you tried to disable it? Does it make any difference?
No idea how. UEFI doesn't seem to show anything similar.

Similar bug report: https://bugzilla.kernel.org/show_bug.cgi?id=202241
>
> Regards,
> Lorenzo
>
> > It is.
> >
> > Note that this does not happen on kernel 4.15 (Ubuntu's kernel) as mt76 lacks support.
> >
> > Regards, Lorenzo
> >
> >
> >
