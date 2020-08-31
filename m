Return-Path: <SRS0=wavk=CJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910D2C433E2
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Aug 2020 13:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A754206E3
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Aug 2020 13:11:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QG/9SKmV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgHaNLy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:11:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32302 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726144AbgHaNLp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Aug 2020 09:11:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598879503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7nF5sKzdQpqrhvwSpdopxfb0fKEw2qVbNLvuVMDTjdc=;
        b=QG/9SKmVXFV+bPsyLVM0Z835WbAMATm5zFuTX76bMKq+ng9Vj7JR/dGvRMC5rLsonUZ3ub
        UWrNqjkJVtyNZ/fUrfe5o1tiVgzHQJ0nr6G9MHZme75apwWxKiG6NejEFC9eS1M0lkHK+Y
        tK0a6mLS0MZbUv5ZnbVmUpqAxk8AuaE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-Fw4RHxYXOwaY36MRJBW4Hg-1; Mon, 31 Aug 2020 09:11:42 -0400
X-MC-Unique: Fw4RHxYXOwaY36MRJBW4Hg-1
Received: by mail-ej1-f72.google.com with SMTP id f13so479745ejt.16
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2020 06:11:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7nF5sKzdQpqrhvwSpdopxfb0fKEw2qVbNLvuVMDTjdc=;
        b=jvXsABfoVRnrE5i61k0YXMM/7xYzBsu/M67v/EVEk0exNE5QlIUcmASPC1IaVv1ixR
         HgUDbQzzJcKBpfsDeQ2XASlSSdjjJ8l+XO8PP6q+bsEfSregMSlToUNXnax8ll84l7qz
         ZPsOgEwF8Op82Ygo+aVVN4e/KKBxGWvevq33OJd7Tw2wLM0B9RzmmDWg1+VcrBHo0JiQ
         Aw4zKR/vg0TWtduwyQfRS91DJBioak9Lg/B+6WKqkGAdoYjaU/2w9bGdaggla7SGUexY
         DWN0W8ydfOytpXLXMsrUBrdA7BvvLozVGDnu8vxN03txxw4bo8PO99bsnNsQF42oRIuq
         HqOQ==
X-Gm-Message-State: AOAM5303/Yw0/8k38fHLpGD33osgTsI/w/fNIGecqTAMFek2Otc2Cjui
        o5SIfIoIcjK1w2EQ8/9+m2m+jlZxdemeHUFqWSm6zMym2+wYh18ckYB+I9yu3C1K6idNRnJx1Ve
        2nqIhdzn0h5J6zbRgE3+feYCGNOA=
X-Received: by 2002:a17:906:6801:: with SMTP id k1mr1096263ejr.492.1598879501003;
        Mon, 31 Aug 2020 06:11:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzItLH86Ckd/S1T4CSysXzsOleHn5Gn0gTMPopx+V52YiWH6pI5k1RkLYwrROAXQWf5ezYHEw==
X-Received: by 2002:a17:906:6801:: with SMTP id k1mr1096249ejr.492.1598879500731;
        Mon, 31 Aug 2020 06:11:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id sb9sm8135015ejb.90.2020.08.31.06.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:11:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B0CC518200B; Mon, 31 Aug 2020 15:11:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/9] mt76: rely on AQL for burst size limits on tx queueing
In-Reply-To: <20200831122558.1388-6-nbd@nbd.name>
References: <20200831122558.1388-1-nbd@nbd.name>
 <20200831122558.1388-6-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 31 Aug 2020 15:11:39 +0200
Message-ID: <87h7sjj6yc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Now that AQL works well on all mt76 drivers,

Yay, great to hear! :)

> completely replace the arbitrary
> burst sizing and number of bursts logic for tx scheduling.
> For the short period of time in which AQL does not work well yet, limit each
> stations to 16 in-flight packets that have no estimated tx time.
> This should avoid filling the queue if a station connects and queues up a
> large number of packets before rate control information is available, especially
> with hardware rate control

I guess we could do accounting like this in the AQL mechanism itself?
Presumably this issue is not unique to mt76?

-Toke

