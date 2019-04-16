Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647E8C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34E5220821
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfDPItO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:49:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37592 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfDPItO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 04:49:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id f53so15591309ede.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 01:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=606yNXbN2CKRzvM793MQyfetRQE/osaBflcEeqkvBDc=;
        b=mbkBcinzsPw6Ke0I+x2eSeaN1y6e0QUQ2NoaKYHW7KGdhWXzdtzPNnKtS2SHDFYlHa
         t4i1y5wGEpdpCfNUOuGC6f6Ht7rYJnV3pScixdWIX4mBFMgO+v/Qz4q0FdZhSj7wFX+5
         awKCCM8clTA7wg0qgwdNSVEddoFU6Sml5NQfyvQJ5I0NIKNjwQ/AlkI4y30Ss5PQw9cI
         sKHb5rpydIpfwTLmEA3iNHTrHpvCJ7Lf6q4O3po+GHGfraSRJyiDw73EjCY+VcPzs7DR
         TApBJNR4Ril2sPfzzDXumvwdj9swQDLqsJaSDudp8jOxd2cvdSjgO7thnMnRVXSVwsbU
         JMyw==
X-Gm-Message-State: APjAAAWVVBWZOnkRE+qUn37dKzXDzzUm8b8UBYg/2ikmG5qPefLbG5u/
        3kntPEFrIJt0ltmGUFxYeJy+Kw==
X-Google-Smtp-Source: APXvYqyVMCh4LVmLbDMLj/P6/8ELUb2vmlybCsmBS2m0F8sL0ugJdrXGWFEJnj2a0ESNju/Z1EbRoQ==
X-Received: by 2002:a50:8822:: with SMTP id b31mr16036530edb.53.1555404552588;
        Tue, 16 Apr 2019 01:49:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id x14sm780596edm.1.2019.04.16.01.49.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 01:49:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 81B601800E8; Tue, 16 Apr 2019 09:49:07 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>,
        johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: Re: [PATCH] mac80211: Fix kernel panic due to use of txq after free
In-Reply-To: <1555399480-30537-1-git-send-email-bperumal@codeaurora.org>
References: <1555399480-30537-1-git-send-email-bperumal@codeaurora.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Apr 2019 09:49:07 +0100
Message-ID: <87sguiuygs.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bhagavathi Perumal S <bperumal@codeaurora.org> writes:

> The txq of vif is added to active_txqs list for ATF TXQ scheduling
> in the function ieee80211_queue_skb(), but it was not properly removed
> before freeing the txq object. It was causing use after free of the txq
> objects from the active_txqs list, result was kernel panic
> due to invalid memory access.
>
> Fix kernel invalid memory access by properly removing txq object
> from active_txqs list before free the object.
>
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>

Nice catch, thanks!

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>

This should probably have a fixes tag:

Fixes: 1866760096bf ("mac80211: Add TXQ scheduling API")

-Toke
