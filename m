Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDA7C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C11621B68
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="coK6sk2A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfBKR4j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:56:39 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39031 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfBKR4j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 12:56:39 -0500
Received: by mail-ed1-f66.google.com with SMTP id b14so9667649edt.6
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 09:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pIeowyW41eOo9CVNk9ZFj9ScRprRWs2JpeKe3YuLIHQ=;
        b=coK6sk2AvA7sIHe2POLMmd1/fzmgBmN2IS/GRZkFhARJG5meAoVNSmmPGIHAHQF3Ys
         wMwCKfgEhrKLDDAQlTzosrUv5YxGOMlSgpvIniIYOXxjyRk7J4wtGykwiUO8/K0Wd4fK
         ntXwlHQ650KsN3FVocV/XrTtNohBdAPDXAqHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pIeowyW41eOo9CVNk9ZFj9ScRprRWs2JpeKe3YuLIHQ=;
        b=QOi0u4pgSU2XmmFtGLR9F4Ia/02WBVUHzQQ5Gb8wnP7TkM0nynqV9DcTvTbz3TeRS5
         ihto3NzdhmOhrFrq+ch1qFcK1yk6jJ5Jhq0YozFvrL47qfRRrnP+udqYVbsATB83sYSz
         URbtJrw8wO9YpDkn44S2vdpF/45q27oc9hvWF7kuaFhbV48Kv6O3gcXehowQ2MORF5R1
         DgiBg6PBUlGcRN1sdlEJlbHzOqlQI0EKY2/7HsoSGZaXQhIpqo6AOeQpCP/OU4yPTpLX
         FRS5FFlnCvNFHVjf0u0NC370NZU19jvbpFlaFYLKpNqwJ/nLeqBHK9B9kLrxOkTV+n/E
         t8Rg==
X-Gm-Message-State: AHQUAubSdUYnLEOJfEl5EF5ulyQ0buP5LxUVa4P4UaZqquUD89qlWk89
        I6fD17CcErg1GNVw8wKL//ysqNXk/KQ=
X-Google-Smtp-Source: AHgI3IYf366rb3unn5TY+WVdzbbpL/CUu7MtVUhJJ+cWALrjpLYO84GEvEM6LnJhKhTeBsd9qG3xzA==
X-Received: by 2002:a17:906:3482:: with SMTP id g2mr313812ejb.242.1549907797589;
        Mon, 11 Feb 2019 09:56:37 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id v10sm1040847ejj.55.2019.02.11.09.56.34
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 09:56:35 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id h58so2398789edb.5
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 09:56:34 -0800 (PST)
X-Received: by 2002:a50:c8c9:: with SMTP id k9mr29830436edh.6.1549907793940;
 Mon, 11 Feb 2019 09:56:33 -0800 (PST)
MIME-Version: 1.0
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com> <20190209021426.GA163159@google.com>
 <F7CD281DE3E379468C6D07993EA72F84D17A2AC2@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17A2AC2@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 11 Feb 2019 09:56:22 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNmU3_nZ1VXeGZ4GMijgQKSL+LJMvy44FP9u1THBohSbA@mail.gmail.com>
Message-ID: <CA+ASDXNmU3_nZ1VXeGZ4GMijgQKSL+LJMvy44FP9u1THBohSbA@mail.gmail.com>
Subject: Re: [PATCH v4 03/13] rtw88: hci files
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 10, 2019 at 9:48 PM Tony Chuang <yhchuang@realtek.com> wrote:
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > > +   tx_data = rtw_pci_get_tx_data(skb);
> > > +   tx_data->dma = dma;
> > > +   skb_queue_tail(&ring->queue, skb);
> >
> > IIUC, you have no locking for this queue. That seems like a bad idea. It
> > then gets pulled off this queue in your ISR, again without a lock. So
> > for example, if the only packet in your queue gets completed while you
> > are trying to queue another one, you might corrupt the list.
> >
>
> I think skb_queue_tail already has its own spinlock to protect the queue?
> Cannot see why the list might be corrupted. Or I misunderstand you.

Ah, no of course you're correct. I think I kept looking at the
definition of __skb_queue_tail() instead. It also doesn't help that,
in skbuff.h, the kerneldoc comments for __skb_queue_tail() are put
above skb_queue_tail(). So it's extra easy to confuse them...

And to be clear, so far I don't think I've seen actual corruption of
this queue yet. Just bad TX status reporting, including plenty of
driver WARN()s. So my comment was only theoretical (and incorrect).

Regards,
Brian
