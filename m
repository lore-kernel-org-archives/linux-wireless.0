Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8AEC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 09:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C45AF20651
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 09:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=airfi-aero.20150623.gappssmtp.com header.i=@airfi-aero.20150623.gappssmtp.com header.b="x5XQkobl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfAHJac (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 04:30:32 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40189 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfAHJac (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 04:30:32 -0500
Received: by mail-io1-f67.google.com with SMTP id k2so2609765iog.7
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2019 01:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=airfi-aero.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jGGz/8YZ9WfSRjdftf3/HK5XmdBMSJiplXGrSvj81j4=;
        b=x5XQkoblKTLk07teMz+dF+JndoDTWdJI8YLXSj5NiP422W8d5grultckG+5sBFAFF1
         9FV5o3OLwwB8QjLErAgc2BgwONHAQbEw2Qol8k2EbWUmi0PnvAnfHTrlfYVP3MNB6am9
         51GsVEBTrAEJrNFjH7u/iHK4ZioeY4dJt185QDXKsN0AiDMeMwpURHPIuIJHMUzZdOjH
         VXi68SXPVwzt9bqI9GKG+dEBPcI6S2F1HO7f5NNGeYHnDZQwaH5mx/kH6/WpFJJvoXWO
         H77lskRaJFrWaWrnMbRXPGDYv/9UoL7AOghLi8uuqrsVLPn/NrTHrYAgQ4f0OxTxTcJF
         8Iaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jGGz/8YZ9WfSRjdftf3/HK5XmdBMSJiplXGrSvj81j4=;
        b=tp14WzamLK1kj13DhAO55BbENQg+V+oHmiXEvpmZc2mUN1akXZIXkSRVm82Mb2y/qo
         f0Fm7bo/2Kgq0bEvM/U4lyYLSHkMPIVv64IoeBUrmB02TMFiZnNX/ArZ6LpWYD/vjvnF
         HYbDwxfh1CuBzv9Jd+1sZFCDHdz3vBrWXOu1cjNH3m9hNVgR5VGIsanA6iEZIPMBd2uN
         0Epep0ctzqi1jcnzGcuSckqCIEeO5Q9A0RzICNgIEWcDcEpTr4qmfshLMcVV8/6BBpzA
         x2cdKyVWA68ajmp+dETN/mAj+ZVlHk0edWKwjMZ2DDrKFK7p+FepiMxXhGPJ/w8LTGmF
         jjmA==
X-Gm-Message-State: AJcUukdIi00paOeuwuZH5qBbzU1dnW6BTQ1wcMsYTJASRuVcBNuEe5Ip
        RiXndzulK2zI4R/U83PKuK2Q9MMhIdqYpiBe6afAug==
X-Google-Smtp-Source: ALg8bN61jm1QtLiInf917PFOCPw0LXO5ZE6de1WWDfwhRAqWzmdhZPRjAwMWP9oCe4ahx8piUA4CEExTQG8Bv08BLXs=
X-Received: by 2002:a6b:7e04:: with SMTP id i4mr530594iom.116.1546939831234;
 Tue, 08 Jan 2019 01:30:31 -0800 (PST)
MIME-Version: 1.0
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com> <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com>
In-Reply-To: <20190107150912.GA9516@redhat.com>
From:   Jeroen Roovers <jer@airfi.aero>
Date:   Tue, 8 Jan 2019 10:30:20 +0100
Message-ID: <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        =?UTF-8?Q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

     Hi Stanislaw,


On Mon, 7 Jan 2019 at 16:09, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jan 07, 2019 at 01:47:19PM +0100, Jeroen Roovers wrote:
> > Maybe I am wrong about this, but then again I have neither ever seen
> > the driver respond to an ENOENT like this when an RT5592
> > "disappeared".

By "neither ever seen" I mean I have never seen rt2x00usb respond
properly like that because no -ENOENT was ever seen. I have many
system logs collected over the years showing the exact error that the
code was trying to catch and still does try to catch: with USB debug
messages enabled, I tend to see

usb: kworker.* timed out on ep.*

followed by rt2x00 specific warnings about the queues filling up:
rt2800usb_txdone: Warning - Data pending for entry N in queue N
[may repeat a few times]

followed by the fatal:

rt2x00usb_vendor_request: Error - Vendor Request X failed for offset X
with error -110
[many of these, system is slowly locking up]

So the only clue that I had was that perhaps rt2x00usb_vendor_request
wasn't catching the correct return value.

> According to Documentation/driver-api/usb/error-codes.rst
> ENOENT is valid error code when interface does not exist or
> when URB was unlinked.

rt2x00usb_vendor_request calls usb_control_msg.
usb_control_msg according to that document can return -ETIMEDOUT.

1. rt2x00usb_vendor_request calls usb_control_msg.
2. usb_control_msg calls usb_internal_control_msg and passes on its
return value.
3. usb_internal_control_msg calls usb_start_wait_urb and passes on its
return value.
4. usb_start_wait_urb very specifically substitutes -ETIMEDOUT for
-ENOENT as the return value of usb_kill_urb and
5. that is passed back all the way up to rt2x00usb_vendor_request.

Kind regards,
     jer
