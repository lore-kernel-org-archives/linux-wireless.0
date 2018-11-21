Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423C4C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 03:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BC632145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 03:20:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dl2L8brl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BC632145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbeKUNxQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:53:16 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:36466 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbeKUNxN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 08:53:13 -0500
Received: by mail-it1-f195.google.com with SMTP id c9so6932639itj.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2018 19:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gg27hJiPQ3d4NHt0mdVgx9/ikHSqaLrJCVV/c5lQqOk=;
        b=dl2L8brlBAQbXLQok8N8a5vojhfeMcvu8siUufhvsbO4jruRn4U8wVg03lmsIlDCdS
         q6+0xaveD+dGnOsWipm3d9u+i90LbBp9ysSfNa6gJ55L8JIUacymYPXg7r/lIGDjikWN
         HOLnhx++jUJsA/On+Blv26tODkj7NzgR6p1Iud+YTmgnXWkw9c88D4lpY8XktvdFrCLm
         +jJWbhDkC4QGBu9ypRZUcr/itq7XeT66UMN3hAjeie28xumgthfuS5wTMW7bkW31nxYL
         5qID8lGXKA4yH7priPGfcW+Pc858w/F/OeXKw8BEhbwX1FX4ecVER9VqSrXPnDHubR+V
         juvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gg27hJiPQ3d4NHt0mdVgx9/ikHSqaLrJCVV/c5lQqOk=;
        b=Wj6dYRueyR315x05baWcSrpg6Ftstr+BqnriqCl2vQFHr6AgenVj9p+UUNRy4HjoMN
         RwX5uKm/IAGT565tzsutFY10oaJtGRebsOgFRNQsOiiW1TW6CuVedF69LXhT8x4aVMQg
         YQhDFkCXFhKlzLnqY+nvZh/zV9HQhKVJDJAMmhwnXvPKxoeRdUaiAfJHR/mnuNXxchxI
         9JjtiqbdkkgeSYCVwptfk0mfWCwZljPSVg0KjaxXEPX7wyAiaBLICwWGnmzjK/BZDa/b
         c1PRA64DQyQKy+HANLRZAEBxEqm2d2GlAqo64IdLp1V9nOQBL8K8zuQyUPRprqWxO329
         wqHQ==
X-Gm-Message-State: AGRZ1gIu7rMpPuua9ddk5oR2WjNNKPm0viKdfwdwlLSr9ZkFMGmLMh+k
        oOeyJiZb7XSPc4jpWqmEsdybfmBCjTwU3kqlaDZz4Q==
X-Google-Smtp-Source: AFSGD/WjYGc6w1cIZ5ZcmZ/y0sV4cDGVGBp7bAE2mtAIN6fcEXMtN4GkhGcxKOWggD1OZCnEGIIn1wHhz0JdtiTfbqU=
X-Received: by 2002:a24:6c55:: with SMTP id w82-v6mr4415956itb.106.1542770442942;
 Tue, 20 Nov 2018 19:20:42 -0800 (PST)
MIME-Version: 1.0
References: <20181004195906.201895-1-schuffelen@google.com>
 <20181005143323.ezyd2x6x5ymlb7rg@bars> <CAJWu+ooTRUxj2PAiUkgjTLb+VC9OoBpkj9-_ZoC-oCS3owc5Hg@mail.gmail.com>
 <CAJWu+oqoSsj=50vk-jUTKUVgZ_oj5Vng0bBF605Aw_iWD=W24A@mail.gmail.com>
 <CAAELVAGAZ-UM77P=JqzHjUGja9oJcN5y9+YvxZWKBmOXAu=zNQ@mail.gmail.com> <87tvlzffmf.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87tvlzffmf.fsf@kamboji.qca.qualcomm.com>
From:   Cody Schuffelen <schuffelen@google.com>
Date:   Tue, 20 Nov 2018 19:20:32 -0800
Message-ID: <CAAELVAFgMPboCrhXW2v-jcwXaDExsWH0oxhWiVJRLJ5iBSYhaw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation device
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Joel Fernandes <joelaf@google.com>,
        sergey.matyukevich.os@quantenna.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> 1. Do not EVER submit HTML mails, mailing lists will automatically
>    reject them. So your mail didn't reach the lists and I only got it
>    because I was in the Cc field.

I apologize, my mistake.

> 2. Do not top post, it's really annoying:
>
>    https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_top_post_and_edit_your_quotes

 Thanks for the reference, I will keep that in mind.

> 3. Reply to the review comments you get, even if you agree with them. By
>    not replying you give an impression that you are ignoring the review
>    comments.

 Thanks for calling this out, will do.
