Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB12C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 18:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52479218FC
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 18:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfCPSNp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 14:13:45 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35925 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfCPSNp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 14:13:45 -0400
Received: by mail-ed1-f68.google.com with SMTP id e4so10267100edi.3
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 11:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ab5xYb8TMLO78Ct66tWq2YYzPFGc01DyGkGxy/HDD4k=;
        b=VlbWs8XfNAYBfGkCTlzTrx0hK47bJjpjyxqkvScpcTrA5ROaOpYNm1brd95Tr36Kmo
         XN5i2ukW3d15IylbJaI8LyEr7mnIxBrnBy0GJxMt44E3uMZFb4fFer/T8yQMwUp0zA/S
         DWNs6mC1Rg0WVbvNTKbNXXOCWLmiKR0fHvkXKXrGWzgirycaNUq1lhMD6nt3Lm0vt9eg
         fuozUNA9BiH2OD/7LR7Q3amSyYzBS9ZVUe+wFglNLFV1pgn1iDgMuu8OB8voSQhMYVCu
         YLWNKYiJBs9qonE8Ehw5XxhRUyfHZTDH9+MHmR2EaNy+JZcpjSVLOhRLv0YoDAX1fW2q
         SSuA==
X-Gm-Message-State: APjAAAXCu25uJjafzFAYOLkdphmC76pPGGzUB7iFywvAr6AG7H87V6Uc
        vjajm7BcyJwytV6I/JfC+jAs2g==
X-Google-Smtp-Source: APXvYqwHv0mjm7OnoeGNs8E7Ku4u2dp4rNRhYi1P13H8P+9k/OrBQqli9wRGGLsjwrLQRMku+gUY/A==
X-Received: by 2002:a17:906:2a9b:: with SMTP id l27mr5949407eje.89.1552760023729;
        Sat, 16 Mar 2019 11:13:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id l15sm1204402ejn.77.2019.03.16.11.13.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Mar 2019 11:13:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9547B1804A2; Sat, 16 Mar 2019 19:13:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH 4/5] mac80211: run late dequeue late tx handlers without holding fq->lock
In-Reply-To: <20190316170634.13125-4-nbd@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name> <20190316170634.13125-4-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 16 Mar 2019 19:13:41 +0100
Message-ID: <87va0ivga2.fsf@toke.dk>
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

Also reasonable.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
