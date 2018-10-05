Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F50C65BBE
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 21:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE69208E7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 21:06:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bDhizx7C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FE69208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbeJFEG0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 00:06:26 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43583 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbeJFEG0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 00:06:26 -0400
Received: by mail-qk1-f193.google.com with SMTP id 12-v6so1937969qkj.10
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 14:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=DGLzUbIsxkj3sSc/VHFYtkUjVnsY993ySIgsB02TCOc=;
        b=bDhizx7CtSP/u2AcvEhBODolVPIPxJ1DjI887EA2QRERvP7TB1kt6XrWcSfvlcIpjM
         5t2ZVcMUMd4Z8c2i1oNAU64GJcZFk55qzKDyWvnQqOdcUb9PqOBK82165hdxJW31xghA
         PwuAKh4IOiTcmSKVlN8m6kcNoLjdony4ed/VzfOTdx9GX6nwd+eQYYdK5iwlyBAGXaYO
         6xUpPsUkFaxXkHYgUMy6fXnMrjX+ZO6mkm5nq/2SS4HF8qSAn6h5HxC4/2NMUZ1zfbMV
         3RVTkPwLzY4inJtmcfgq5k4OorF+jG0en8iPRkJfjGQ8FW/c9QJ08gZp5eJalSBsAVyE
         wLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=DGLzUbIsxkj3sSc/VHFYtkUjVnsY993ySIgsB02TCOc=;
        b=Uov+ylrEadA5IRTYrboFnCW/X6Rg0ojDl9FbEwcxAjfAWAeBlHyzmrTE9mD3ncvbE8
         2mI/yrY/60yEsar2jo6SLA7qrZKNKVgLWFNa8+WGZFkm6KH18Xc6wcTezbBhdMSA6m02
         eyhTlWSnLJcA68swWnqGixH2xXVdwRnEGbdXlh6z0JksCQK8Tx3ujOHyJCxWSydV9PTs
         sMunQEZgSSVCABhWOFUFd4SOBs2g13Fgy82MoBiYvtEigXYmPdkSwDV6ZdEBPy9852VB
         M8OLdnQ1NGdp3fip/JF41oKgIU9EvCcBVpzFyKcVC/wIDwqy6uf8Vlwbz+QHKJhKyZIx
         kQVA==
X-Gm-Message-State: ABuFfoi3ksXGUhB7DTY54wpm4cy/KeOjLRL6rH9A6ImFLIlyxRyYYkXw
        94HJ/nS5IUWcvbjEIlv1rMWnso4EWNmS1B5V03Irqg==
X-Google-Smtp-Source: ACcGV602BowYeFfjoBDLisMyn0CrRB7ZmNZffaDV8dM18LdlHeJ1LXyclO1PUFj+hH8hY/o4NSQHe9jc4MdVM66cSBQ=
X-Received: by 2002:a37:895:: with SMTP id 143-v6mr10105268qki.99.1538773556492;
 Fri, 05 Oct 2018 14:05:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac8:2a95:0:0:0:0:0 with HTTP; Fri, 5 Oct 2018 14:05:55 -0700 (PDT)
In-Reply-To: <20181005143323.ezyd2x6x5ymlb7rg@bars>
References: <20181004195906.201895-1-schuffelen@google.com> <20181005143323.ezyd2x6x5ymlb7rg@bars>
From:   Joel Fernandes <joelaf@google.com>
Date:   Fri, 5 Oct 2018 14:05:55 -0700
Message-ID: <CAJWu+ooTRUxj2PAiUkgjTLb+VC9OoBpkj9-_ZoC-oCS3owc5Hg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation device
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     Cody Schuffelen <schuffelen@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 5, 2018 at 7:33 AM, Sergey Matyukevich
<sergey.matyukevich.os@quantenna.com> wrote:
> Hi Cody,
>
>>  drivers/net/wireless/Kconfig     |   7 +
>>  drivers/net/wireless/Makefile    |   2 +
>>  drivers/net/wireless/virt_wifi.c | 618 +++++++++++++++++++++++++++++++
>>  3 files changed, 627 insertions(+)
>>  create mode 100644 drivers/net/wireless/virt_wifi.c
>
> I did a quick check of your patch using checkpatch kernel tool,
> here is a summary of its output:
>
> $ ./scripts/checkpatch.pl --strict test.patch
> ...
> total: 165 errors, 428 warnings, 9 checks, 634 lines checked
>
> Most part of those complaints is about either whitespaces or code
> idents. I am not sure whether this is a patch itself or email client.
> So could you please take a look and run checkpatch on your side.
>

Yeah, it could be his email client, weird though because if I pull the
patch from the kernel.org archive's mbox though, I don't get any
errors except the MAINTAINERS file thing:

wget https://lore.kernel.org/lkml/20181004195906.201895-1-schuffelen@google.com/raw
-O /tmp/tmp.patch
./scripts/checkpatch.pl --strict /tmp/tmp.patch

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#167:
new file mode 100644

total: 0 errors, 1 warnings, 0 checks, 634 lines checked

- Joel
