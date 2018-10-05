Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCDEC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 21:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F135208E7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 21:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c4vfXGnT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F135208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbeJFEJW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 00:09:22 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39253 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbeJFEJW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 00:09:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id e22-v6so8254712qto.6
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 14:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=idZscuqw9ecAbJHiItU7I9Cc6KqieRtAkAaXuBbOCMg=;
        b=c4vfXGnTRRN2VWYCuDta4MI9HCMPiy6UYcivSbox9PP51k9VEM3Rk9E3bC/usRkTf9
         TYwlBEpJ4Ahacf92hn25ithhZMkqpl+muZbH+BYMyN76cNlUxs1mqvfiSyBdz9P9CNEz
         nl4Sh5T1RkLN61rh+dSB/4pCG97VIbPasR8cdTP6PFyK9owKapTsuy9xRiwLYfjPmSuR
         Xi+LuOmcvmd5i256mvSgDtjNB5j9cvImOy4PJQyNzSyHGQFmrLym61jbGCTIdmMH2IFm
         4fpTHmhYQHhAXXBVhWtTFG4jTf1HoW6sKhjidVcNZDv8WuZ8yhaCSiVk862aN55NBSYy
         PeAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=idZscuqw9ecAbJHiItU7I9Cc6KqieRtAkAaXuBbOCMg=;
        b=n4LBbovJTwdvEfhuscCCIV0BR7tKpaFaGb9PRmpST+jIfZlc4ZO2wsi1LRbIgh2BqL
         sA6DvA1QwIBtrXuFu8FdDHPxBweKmcgeGxC+JxtZkRiRVLUPqONy6GrSlQQvNSRFVT1G
         zbw64vE1mIhUHnAkEitwA9P4Ks22jPY+a59l/ceaP7vDWgDEojzTP37/8rC8GWHco4yE
         uwaNLZLLXE9TUu2sPmqQzDk+TTPbZLFndAH0eiA7vDGjpdu+XcXnm9vcf0kngZ+Nhs8a
         xzaXeb0xezV/6GM+eTNq1sGGGNdVe/HaKbbc8kPHtOT7cLj9W/UQduwEtwGwI7zZ0yMv
         VlVw==
X-Gm-Message-State: ABuFfogmNAiheQv7xED7F+6773RyoSu+t6mHG/ha1JKiGdt8i174JkoF
        ZyBaMU38XTfalFfBPGgIV8/SrHCwBfbSHoGBdntXHA==
X-Google-Smtp-Source: ACcGV60Dk2ZR0QIs8i+0IH5/nzAG9XZP88QG711panyTVQN6TM4UccpBIGdnO84MvSSh8PwVCDRf1Nn4a2HVGl+Qg+s=
X-Received: by 2002:ac8:33d6:: with SMTP id d22-v6mr11004827qtb.313.1538773732087;
 Fri, 05 Oct 2018 14:08:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac8:2a95:0:0:0:0:0 with HTTP; Fri, 5 Oct 2018 14:08:51 -0700 (PDT)
In-Reply-To: <CAJWu+ooTRUxj2PAiUkgjTLb+VC9OoBpkj9-_ZoC-oCS3owc5Hg@mail.gmail.com>
References: <20181004195906.201895-1-schuffelen@google.com>
 <20181005143323.ezyd2x6x5ymlb7rg@bars> <CAJWu+ooTRUxj2PAiUkgjTLb+VC9OoBpkj9-_ZoC-oCS3owc5Hg@mail.gmail.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Fri, 5 Oct 2018 14:08:51 -0700
Message-ID: <CAJWu+oqoSsj=50vk-jUTKUVgZ_oj5Vng0bBF605Aw_iWD=W24A@mail.gmail.com>
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

On Fri, Oct 5, 2018 at 2:05 PM, Joel Fernandes <joelaf@google.com> wrote:
> On Fri, Oct 5, 2018 at 7:33 AM, Sergey Matyukevich
> <sergey.matyukevich.os@quantenna.com> wrote:
>> Hi Cody,
>>
>>>  drivers/net/wireless/Kconfig     |   7 +
>>>  drivers/net/wireless/Makefile    |   2 +
>>>  drivers/net/wireless/virt_wifi.c | 618 +++++++++++++++++++++++++++++++
>>>  3 files changed, 627 insertions(+)
>>>  create mode 100644 drivers/net/wireless/virt_wifi.c
>>
>> I did a quick check of your patch using checkpatch kernel tool,
>> here is a summary of its output:
>>
>> $ ./scripts/checkpatch.pl --strict test.patch
>> ...
>> total: 165 errors, 428 warnings, 9 checks, 634 lines checked
>>
>> Most part of those complaints is about either whitespaces or code
>> idents. I am not sure whether this is a patch itself or email client.
>> So could you please take a look and run checkpatch on your side.
>>
>
> Yeah, it could be his email client, weird though because if I pull the
> patch from the kernel.org archive's mbox though, I don't get any
> errors except the MAINTAINERS file thing:
>
> wget https://lore.kernel.org/lkml/20181004195906.201895-1-schuffelen@google.com/raw
> -O /tmp/tmp.patch
> ./scripts/checkpatch.pl --strict /tmp/tmp.patch
>
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #167:
> new file mode 100644
>
> total: 0 errors, 1 warnings, 0 checks, 634 lines checked
>

FWIW, the X-Mailer on the patch is: git-send-email 2.19.0.605.g01d371f741-goog

So I am guessing this is some issue with the way the patch was
generated, or something else. Cody, care to share the steps you used
to generate and send the patch?

- Joel
