Return-Path: <SRS0=HZW5=B7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA43C433E1
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 17:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB8320656
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 17:05:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtOVQDwj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgHURFp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Aug 2020 13:05:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728378AbgHURFY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Aug 2020 13:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598029523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j+s5qDnvDNxAoLj8pQE3tHYHYfaTGarALQyX/pzVwzo=;
        b=WtOVQDwjiOfPBSt4xzZJc6l4YJ2W/RV11P3U9cU7xhHgmyCeJY6q5TzTFHUWG2Re3PsL77
        cF6/WyS1KH/i7oo/ctUT13QWj+9nbT0hb4+0l81MiMECKQxLXSDvppTkBSBpr3PyWRYgCE
        UiOL5FVCio83tV/ARoiPHrKQs/Ywvu0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-Y7SLZ3a8MGq11R5DeuP9rA-1; Fri, 21 Aug 2020 13:05:21 -0400
X-MC-Unique: Y7SLZ3a8MGq11R5DeuP9rA-1
Received: by mail-wr1-f71.google.com with SMTP id o10so741499wrs.21
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2020 10:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=j+s5qDnvDNxAoLj8pQE3tHYHYfaTGarALQyX/pzVwzo=;
        b=ofHZjTbnbmaq90iNXUDEyMzsAK/Ynk3gstiLDjyXt0NCBsmCMBsK02b1lX8akr3YPw
         +RA4Y2UeY7eHYW3be2Y2ZYIdzbkSGx+g+oNnt4jxXE4bj6HQVj0madD4Xj3sPRZYmXPb
         s4c4bIBLmW4IOdAiK/zYAayZ9/6H9z7jjar2CIsluAOF4yolknFqzo4kOonhwZcbbhJN
         sV8D7WLDIV0aDcHofWV30/9MmeVb65X1qg/ujeSnFqVuSRg8y39V31Cf2nwlMXR15wxY
         9sZ32bzn77P4A3UIROxUCd4sYmhPYmehna38D7UEciow9/P+4WZa2zw6/01KGXv4in88
         cPng==
X-Gm-Message-State: AOAM531/CKPlnvS4f78RflgovPO9dhsMu6Rdp7kDqeguGowHsRhuF80Q
        Q/ZCccqJJcsstETV2/Y5TShsErwrWJSbUJ7pg9pgsZp2ePh3cpu+ROLWpJSmGCpo56gZRxx+WZc
        KmorwkFQYbTWpG27jEEXyweT5z5E=
X-Received: by 2002:a7b:cb98:: with SMTP id m24mr4971245wmi.10.1598029520686;
        Fri, 21 Aug 2020 10:05:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXkeXYNveW71kDJCww5QcGs6SudAhUjfxk8JUtoHSiIyWB47E/AJNyGHx/SFJxnWE707hciQ==
X-Received: by 2002:a7b:cb98:: with SMTP id m24mr4971231wmi.10.1598029520512;
        Fri, 21 Aug 2020 10:05:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k13sm6427682wmj.14.2020.08.21.10.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 10:05:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 83E33182B59; Fri, 21 Aug 2020 19:04:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH 5.9 v2 3/3] mac80211: improve AQL aggregation estimation
 for low data rates
In-Reply-To: <20200821163045.62140-3-nbd@nbd.name>
References: <20200821163045.62140-1-nbd@nbd.name>
 <20200821163045.62140-3-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 21 Aug 2020 19:04:49 +0200
Message-ID: <87a6yo2amm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Links with low data rates use much smaller aggregates and are much more
> sensitive to latency added by bufferbloat.
> Tune the assumed aggregation length based on the tx rate duration.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

