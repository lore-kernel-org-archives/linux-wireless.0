Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BC3C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 18:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A602F218FC
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 18:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfCPSNX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 14:13:23 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35075 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfCPSNW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 14:13:22 -0400
Received: by mail-ed1-f67.google.com with SMTP id d6so9681773eds.2
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 11:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=oUAnp1tYSBMewjqwPgwlqKE99toIH+niavssI4BXtGE=;
        b=F8UtXnZNo1B53XJSCMki4dCRm5Hp7oYMeuOBgd97U1/lMVeDF8LfCdDighLQQGvRuZ
         vdAGijdaHEKftao9qFnZ053p8zGJMsygkldnKshMYPJj2rzD6PsR0yLIRsnwZXNo8A3u
         y0yfqASy3cq1vquGNjaSlsdKNI5vnRLWlFhkXoDOQTy2jaAqUF5J7e6JklaIDgFXHf6E
         EZwBXjMsSk9LgPUx28bKmJ06ifm3g1UkGieJTLq3Z72suLlbCaxPE6X/67CnbmMvoe7C
         L8KFnrr9M0MmeutdPOVw8aaF5boljStjvTo7QpR0j3CnvtjWgDiFY3DGABTQvAfDPQSj
         40Vw==
X-Gm-Message-State: APjAAAUDdkKValxYOROLOdtW7GictHXZH0c/7Y8It0rDFvEFUQfqCMwP
        xuoXaQQ3s+M2Fv7dbngMAaBpjg==
X-Google-Smtp-Source: APXvYqxt8eodl6HYs/VMyL7KEsrk7y8MqtPqSEJOCE6k5Si9uk0OhXri0b8bi0PuHfCXgJ2l/5FZfA==
X-Received: by 2002:a50:b924:: with SMTP id m33mr6407753ede.278.1552760001411;
        Sat, 16 Mar 2019 11:13:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id e11sm1187427eja.54.2019.03.16.11.13.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Mar 2019 11:13:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E120C1804A2; Sat, 16 Mar 2019 19:13:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH 3/5] mac80211: calculate hash for fq without holding fq->lock in itxq enqueue
In-Reply-To: <20190316170634.13125-3-nbd@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name> <20190316170634.13125-3-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 16 Mar 2019 19:13:19 +0100
Message-ID: <87y35evgao.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Reduces lock contention on enqueue/dequeue of iTXQ packets
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Seems reasonable.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>

