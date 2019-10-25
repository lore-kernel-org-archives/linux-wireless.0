Return-Path: <SRS0=+qZr=YS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88524CA9EBC
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 16:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F62321D81
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 16:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhGn7ZWA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505745AbfJYQxn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:53:43 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32796 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502610AbfJYQxn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Oct 2019 12:53:43 -0400
Received: by mail-lj1-f195.google.com with SMTP id a22so3497013ljd.0;
        Fri, 25 Oct 2019 09:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=60f1VeXr9Ngv8dhGgBl+LcRR8B4yUQb/u7zjeQKLFGc=;
        b=ZhGn7ZWAzUKPAKn17DxM4tOGqNypVPlZ9TCcqb5ea8/Zd8XCHgmLR5dsSaZViSTAzE
         CIaSR61rr42XLrveVeM4/bioDZzikla4AFFlD7Xv92SqODcPxxqqbPGDUkHm5oT8AO9d
         JKotlbRCpccWl3BZ6S/UZUr7fYtkZgmuDHqMsTpiySDJ3IvEN3+NgVOcBK9V6LRUppUe
         CNQ9QppYLqcukVXIJHGqJ6RfYdJwuaGIul0H9wuGRzVWUp3ef4FksDs/hX0vYgnDIi/9
         KYYdlU65bSDYvsHOBtMEri+6TRlS3Cp5ba0PMbPjXgMNx9xPBtHcz9bZ7DrDhVKDn+vb
         EbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=60f1VeXr9Ngv8dhGgBl+LcRR8B4yUQb/u7zjeQKLFGc=;
        b=a6OYYb6VLzypnJveH5foU/uZORJi6kOW1+72eEBEaDSu17Qc2ib1/x0Hu7yy+kluHU
         u4+k+boh7wE5Jqys5hlhXYJydhd5ZlfSPT1k39PTs9hSvwZbyNLEJsUp+t05HDLXLQaV
         7/OfXMZXGuTRFyzAt5fF6FaduxPidefZPt8qn/yuGZfLsEiGgjrkrjE+5fQJZarirDsF
         jzIDgfrLSv+YguHgJDULG+2yf/r+NM2PrmJYSY9GgIokiEBy5+wb0wpBoKnTDatbgw6y
         zFvSCNn8Z1bYeT668vvant4uTvE72z/mYKhJxvf3V1kdcCKpgV7JmIslaDcKqf5yPXP/
         pRRg==
X-Gm-Message-State: APjAAAXebbrjvIOpRxMBmOR5drU5t769EcbcOjYBPsvhFCHg15rkOAsw
        zB1DMrRc9YqyfjjWCRI6ZyZOe08HgnkZbtPk2r4=
X-Google-Smtp-Source: APXvYqzj14cbhI2MfVTm81sGJvffoQj27w56CihYLjltC1huKicdC4s/P1ZaaTG2FOkBqVhygbeW2O2EUA5zajqWijo=
X-Received: by 2002:a2e:89d3:: with SMTP id c19mr3127088ljk.201.1572022421279;
 Fri, 25 Oct 2019 09:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191021184710.12981-1-ap420073@gmail.com> <20191024.145536.140176702728222831.davem@davemloft.net>
In-Reply-To: <20191024.145536.140176702728222831.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sat, 26 Oct 2019 01:53:29 +0900
Message-ID: <CAMArcTWCHop53Xg85Cb2ko2sm+GhV0Y8vY_z7m9G-ve1T2D_YQ@mail.gmail.com>
Subject: Re: [PATCH net v5 00/10] net: fix nested device bugs
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 25 Oct 2019 at 06:55, David Miller <davem@davemloft.net> wrote:
>
> From: Taehee Yoo <ap420073@gmail.com>
> Date: Mon, 21 Oct 2019 18:47:10 +0000
>
> > This patchset fixes several bugs that are related to nesting
> > device infrastructure.
>  ...
>
> Series applied.
>
> There were some inline functions in foo.c files which we don't so, we
> let the compiler decide.  So I removed the inline keyword in these case
> when applying this series.
>

Thank you so much for the review and for modifying this point.
Taehee Yoo

> Thanks.
