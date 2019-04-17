Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2992C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0F620835
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbfDQJ0V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:26:21 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35578 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfDQJ0U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 05:26:20 -0400
Received: by mail-ed1-f65.google.com with SMTP id y67so7087143ede.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 02:26:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ze7JquwvUneY/03dtXW751kdGYnLdVXEW6bGNmpE3F4=;
        b=Do3aIyXgMGcLuaoLcwEQ3Fh2laT5GQVK5ciI2O/eINsa9ozTr1iGIqqBTkAubpp2vX
         d/oQ62FQLmBBqx+4XRCmL5Gtbuozn7vj1YBZoc0q+peDzy6BxbVYMrKSBJTdjUFzyWVe
         25lRPSqJc0YA3usxdsxR0RI5wSCEDpZ1pZQoyGsL9DVYT6DftDM13wm1NnVmWNYNzjYJ
         /IlIfooBCdvWZwMjA1ZRHvsaAIFAHaDi+AmSh2dPy4dg+0HV5TuUJLJ2grakoWBY/E9Z
         7nIWCs0GzlN1B7UG08E3pk41HJZS1QFcQNU+1N5XVyZTaCkHt7Jr6/+tbIH38poaOhW1
         m0JA==
X-Gm-Message-State: APjAAAVjcJND+BABe5ntlPm6WGdK+a3DqSg1evcDGVeN4OobFB5l/9vE
        Gom4Br76aaIOAK8JGx9osyzIcoEnE4I=
X-Google-Smtp-Source: APXvYqx00Zrqj4t1gXeqPilRIbDNxA+lywb8cM50gd4jovdjPxFHD0pcK/6OUHz6g6WYhgsfHp5OYg==
X-Received: by 2002:a17:906:1851:: with SMTP id w17mr46319790eje.242.1555493179448;
        Wed, 17 Apr 2019 02:26:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id j12sm3181998eda.71.2019.04.17.02.26.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 02:26:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9E69A1800E8; Wed, 17 Apr 2019 10:26:17 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lei Wang <leiwa@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Lei Wang <leiwa@codeaurora.org>
Subject: Re: [PATCH v2] ath10k: fix different tx duration output
In-Reply-To: <1555489045-18070-1-git-send-email-leiwa@codeaurora.org>
References: <1555489045-18070-1-git-send-email-leiwa@codeaurora.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 17 Apr 2019 10:26:17 +0100
Message-ID: <87mukprnie.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lei Wang <leiwa@codeaurora.org> writes:

> TX duration output of tx_stats in debugfs and station dump had big
> difference because they got tx duration value from different statistic
> data. We should use the same statistic data.

So are you sure you picked the most accurate one of the two? :)

-Toke
