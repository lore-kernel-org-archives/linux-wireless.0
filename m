Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F1FC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 18:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3B7E218FC
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 18:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfCPSMy convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 14:12:54 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:45214 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfCPSMx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 14:12:53 -0400
Received: by mail-ed1-f53.google.com with SMTP id m16so3666961edd.12
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 11:12:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=htIhFP6vghE890XdK2eZjaGCeN5c6NAldqObrbeioaU=;
        b=e8csmXv971YpExcRAZJCxHTOs9CuyiYGoKJNhFlqMMpG3NkGb71lP0WA3lZpAMVhg/
         xHG3iCfoAlteg9sy2qw6A/aj1scsNZ7rtQ8tolLunxJ6PknapKepi37JdWYFYeamXVG8
         sQII2SqBTY7s2wa9cQMFa1s5qz1DPjgpoexhIbCsrsLEX0EVSLaX2pO9Tqrn8s03Eb5p
         QvYwCfzkNi39lkfH5pnkl9h6QNn0MjkCDmYitOH8kv0BwPiqgM+WvcGWp7gOqjVtfRIk
         lYk/x7Ak0B1ved4sCJNuarOGgwraFQ5Ui0N6IxjvMekTCfIkW/8MqoPeg32v33pn1EjB
         +Prw==
X-Gm-Message-State: APjAAAUGap26IF1w93KVSdbfDB9VtGksRwI96/nwbIaAa+ofDdOO9Kmj
        z+gsasI8QtYgvuW29RCKPnhJPQ==
X-Google-Smtp-Source: APXvYqz2YAngzQpqeCBBaqCbberjPoaL1VRxpVvk/3bSS1bM1TtdUkdB9+t/1ZLFqOmd32UrrduOpw==
X-Received: by 2002:aa7:d053:: with SMTP id n19mr7400433edo.228.1552759972170;
        Sat, 16 Mar 2019 11:12:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b3sm1213912eje.3.2019.03.16.11.12.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Mar 2019 11:12:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 57C521804A2; Sat, 16 Mar 2019 19:12:50 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH 2/5] mac80211: fix memory accounting with A-MSDU aggregation
In-Reply-To: <20190316170634.13125-2-nbd@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name> <20190316170634.13125-2-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 16 Mar 2019 19:12:50 +0100
Message-ID: <871s36wuvx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> skb->truesize can change due to memory reallocation or when adding extra
> fragments. Adjust fq->memory_usage accordingly

Nice catch.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
