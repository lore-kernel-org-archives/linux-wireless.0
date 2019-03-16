Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D439AC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 18:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A746A218FC
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 18:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfCPSOG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 14:14:06 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39034 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfCPSOG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 14:14:06 -0400
Received: by mail-ed1-f68.google.com with SMTP id p27so10241438edc.6
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 11:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kZx/Q/oQO8V/zLnpCsIgflSdImjixmXyGxAXCTEKwQQ=;
        b=mMQZdrgmKKxsr5QDWbmO+jrdoGaBp6Fmb2AD8R1eIyJ3NG/t6VH4UFDpCz7FYDeqGb
         qN0JNZYujRGJeaIPkD9g33CD3oMqOKY5fDIbJsfTOtD6g13y4WAX6RAZiakKu9Nr5oBM
         sB/jVm0TWRC+AwLu/XxwLhfN4GEv60Du3iCw5j/t4pfw8BH0kEGWOjpapA/QZWmkPD21
         TwnDdiFBoDHns/zfEMzEGzIdJH2vqP21DVq2o5YbJQHQ9mwIzcflAHK/wtijFrtigdWr
         2b4xnFfmHhsQp2llKPiytAC9YcazMkKKoCh6W3JhagjaVusmaP1uCgp5cG21bnBkeslv
         P54g==
X-Gm-Message-State: APjAAAUqpWMwpNUOMOI4zhjeGEqxQeAtdzfJ4CA6c0iNml+qc9wrsBgU
        vYI/3ykoFvfdxdnsIxAyjHjZuA==
X-Google-Smtp-Source: APXvYqyLNOWzeauBOyXZz3Ljx+x718wa0Yw2XJdAcMYJ/k5GPng6MuVkzhivgmd7C5j6T6G64yZmCQ==
X-Received: by 2002:a50:a387:: with SMTP id s7mr4193273edb.24.1552760045142;
        Sat, 16 Mar 2019 11:14:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id j64sm1503411edd.88.2019.03.16.11.14.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Mar 2019 11:14:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7C0791804A2; Sat, 16 Mar 2019 19:14:03 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
In-Reply-To: <20190316170634.13125-5-nbd@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name> <20190316170634.13125-5-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 16 Mar 2019 19:14:03 +0100
Message-ID: <87sgvmvg9g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> When using iTXQ, tx sequence number allocation and statistics are run at
> dequeue time. Because of that, it is safe to enable NETIF_F_LLTX, which
> allows tx handlers to run on multiple CPUs in parallel.

Cool, didn't know about that flag.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
