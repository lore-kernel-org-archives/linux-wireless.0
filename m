Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA4EC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E6AD2070D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LTsXELOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfDLVn1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:43:27 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46882 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfDLVn1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 17:43:27 -0400
Received: by mail-oi1-f195.google.com with SMTP id x188so9173743oia.13
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 14:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3OoUmStK7naKTmdY6VcSIVOPNxt53joQy3TgRUXr3eE=;
        b=LTsXELOniAf4bxcgsP/eixrDnGO8d0ZpYnG+C9h4JF1KjI9L9qnOTOZJHwPXBJyaNi
         fYz+XExGu8UkIn7a6e9AEzcCQGJvZspvcMkaoVoG7CrNe6WiIA/dYk6UPASDN7drUDDM
         J+JVXW6YmDxJCTr00YQrCEUQtPe1OBg+BCk/sgdaLEq00SCOHMl6BFmiUpOHvwhs9Fc1
         aup+2Cz8K06leFXiGgwMZk3t9EMoF4mf6sqNm5KeZwJF9StCLEOpuZ0wz0PcJ9FJn93G
         favBKYgn1hfdqXfrR5IUuksFA20sxXiUZhn2WI2lS/g8F4w6mRWRYpDjO3TeZUYXcg33
         nPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3OoUmStK7naKTmdY6VcSIVOPNxt53joQy3TgRUXr3eE=;
        b=ZAzEhDl+kQOX0ISQ6/7lcDFNKsu6LO6Cxu5WOK0ah0/2TO02hjqkptW3LrJBzNbqTd
         0LsGwY2+wE/WstAj9IjyNSMbwJM17VQChV2gMhXopq3g+Mb22gXVoEH1rM6Kad7lvtI8
         lwcF7nsy8Y/DlY3oN/cG+YZWfMFcKpK5BJbh0P+Bc97U4jIfHsS4vhAhURMU3p0edMX+
         eswx+aXo3426oH5QGyZIRgFMAOlW/BEXCcHJePCYJuE5BVZ/Ml20mSV05n9vqWj7l5jB
         KaSa+9FgMdOQgdr553D9v37FhuC7OJTw+zehubJb0a5m3Yp89pL2h+NYyhnjHl7eSNDs
         0HsQ==
X-Gm-Message-State: APjAAAW2cjDQqZZFudmI4CjxcRNWjvFX+nAvuBE6Ej4Ct9RtmZDaUjkM
        SvBP0qr0tdbhDtS1lL3pQSN1Za/6F+/qilZ3q+vKHJ0i
X-Google-Smtp-Source: APXvYqxNuVM1/3TyQDbI6mDsBEadF7WXeEE7VBdAuWdSxBBQf+ES5fb5Vfg8vRtUYNK8BHtT+Dp+viRvTZ7/Esm22Gw=
X-Received: by 2002:aca:e054:: with SMTP id x81mr11458095oig.146.1555105405815;
 Fri, 12 Apr 2019 14:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <1555105210-22996-1-git-send-email-greearb@candelatech.com> <1555105210-22996-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1555105210-22996-2-git-send-email-greearb@candelatech.com>
From:   Kirtika Ruchandani <kirtika@google.com>
Date:   Fri, 12 Apr 2019 14:43:14 -0700
Message-ID: <CAOXD1ifE_rxU0fV6tXK2WpdOU2x9-b0J4cGsuqf3whi7YapBzA@mail.gmail.com>
Subject: Re: [PATCH 2/2] iw: Print current time in station info dump
To:     greearb@candelatech.com
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Apr 12, 2019 at 2:40 PM <greearb@candelatech.com> wrote:
>
> From: Ben Greear <greearb@candelatech.com>
>
> This lets us more precisely calculate the absolute timestamp
> of last-rix (ie, now - idle).

Can you use 64-bit timestamps? struct timeval suffers from the
overflow after 2038 problem.

>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  station.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/station.c b/station.c
> index 3b0c5f1..60804f2 100644
> --- a/station.c
> +++ b/station.c
> @@ -314,6 +314,12 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
>                 [NL80211_STA_INFO_ACK_SIGNAL_AVG] = { .type = NLA_U8 },
>         };
>         char *chain;
> +       struct timeval now;
> +       unsigned long long now_ms;
> +
> +       gettimeofday(&now, NULL);
> +       now_ms = now.tv_sec * 1000;
> +       now_ms += (now.tv_usec / 1000);
>
>         nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
>                   genlmsg_attrlen(gnlh, 0), NULL);
> @@ -561,7 +567,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
>                 printf("\n\tauthenticated at:\t%llu ms",
>                          (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_AUTH_AT_MS]));
>
> -       printf("\n");
> +       printf("\n\tcurrent time:\t%llu ms\n", now_ms);
>         return NL_SKIP;
>  }
>
> --
> 2.7.5
>
