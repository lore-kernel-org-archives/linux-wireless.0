Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AADFC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 03:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 055BE2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 03:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qPFEVpj5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 055BE2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbeKUNxG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:53:06 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:38953 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbeKUNxG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 08:53:06 -0500
Received: by mail-it1-f193.google.com with SMTP id m15so6904932itl.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2018 19:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZIPzqofjs6yZ6OIwxBHyvs/wydE9D2NgOy4LYNGRIMY=;
        b=qPFEVpj5vIyEQkjAGB6GOEzHx5rz3O6zkJ/+pKvtl+kysiklzTrysCGcOBEWC8v/dE
         BNFnv8cUhbq8WUZ+lMRen9SiO4yBbwJFJDItDcf3ZXqJReEvINUVOLAC0XXoKY0fz/qq
         wLi1QCohPJg9ruH/dPtDjGWRpxUDkaE9S8dKAfBMK402bXNcQQjWgvjGjqoz0vGruzVD
         OjdTQeyohaSCsgDS1/3pRylbmmnGFu+EO5UcJ7stfZwx1lqdCstNDHM8Rado50RhUh9r
         KXA9buu0Gl+IyC7eoJCY8RacN4f1VmajayijFK0UU9s2IyF+/S8z5TMcq4LQr2KKimac
         Fa/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZIPzqofjs6yZ6OIwxBHyvs/wydE9D2NgOy4LYNGRIMY=;
        b=ZRWNm/hGCD4HOJaH8Hq0LtoED9iHoBqmo5yIrzOTRDNxhQ7OJ5/xHGN3Kpzv1BYSOd
         UqIuYT+VWRzehTFOveSBsp2M3xP42w4HHPG8WQJc8rIxL/+Dpk7A9NKp1sp7vjubVL9V
         J4UOGqW/mo+H94vHFCS9mr08E+Z1QmT2jMKGmOVAWsI32dTG1HdYy3rSMnSVsytD1WQH
         OoGSDXS2bKBSVwmbsw8MRsc7TlRFP/1lZzUmqbAsNRNZ3D9D9h5xSvGicHNzN451wqPL
         r0GOAhNgZ8S5oEY8da0BOHSpmCXWCmytEUI0iq84C7xzX9UYDvr8RR/+0M3l5tXJ/xS7
         BNZw==
X-Gm-Message-State: AA+aEWb4xYWqrsiw1DTQhJiV9JkdFcAJKsLXvB6agl1tBYZwROt461jP
        6AxSPE75gQf7/wqBeGUnp9b30ktix08h7pbHTDlqIg==
X-Google-Smtp-Source: AFSGD/UJYSc0OyQV94+f+B93B/UzkvfGr3AHmpjbLg1ybnQlwg9hw4W5ttAWfXLj/FswxGnP84BoLXugckKobO6FHqM=
X-Received: by 2002:a02:8527:: with SMTP id g36mr3826297jai.135.1542770436516;
 Tue, 20 Nov 2018 19:20:36 -0800 (PST)
MIME-Version: 1.0
References: <20181004195906.201895-1-schuffelen@google.com> <8736tjgumd.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8736tjgumd.fsf@kamboji.qca.qualcomm.com>
From:   Cody Schuffelen <schuffelen@google.com>
Date:   Tue, 20 Nov 2018 19:20:25 -0800
Message-ID: <CAAELVAE0QqON_6-m09CE4D-zypWmNxWaMRHi_AT-NOEDHaMPHw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation device
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> I already said in v2 that you should not mark this for net-next as this
> goes to mac80211-next (if it gets accepted), now you are just
> unnecessarily confusing people.

My fault, I misunderstood. The next version will be named correctly.

The new version is uploaded here: https://lkml.org/lkml/2018/11/21/251
