Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A302FECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 18:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 731D02086E
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 18:26:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uqoeKNTW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 731D02086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbeJTCdr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 22:33:47 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:35076 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbeJTCdr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 22:33:47 -0400
Received: by mail-io1-f43.google.com with SMTP id 79-v6so3761180iou.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 11:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/B9HRUb1pN0oeNexgKI/YfWSFYy7wOL5kEV61Po+j/o=;
        b=uqoeKNTWwj+kh/s/VNyygchLqdZwUKw8PHwgvwu+NDB7oq5F6uLGebMddCEmiAInS4
         lshrBZLOrhQT5yjnPKqLQhPo+jinpGiOlO/8gevRkMrXXwRXhmhAhX9FMou+9+JajloC
         y5iJGQXro32WuL5vPDMCBI75CmpxvDTR4crL5IiDZ8eaCBCVOuxkFuH1v81Be6ieL8hS
         BQb3Dw5+AE5LhZayJr7PnvoQ2UETCc+R6UK5gPSOSrxhYsP+m8G7s6Dzj6sbL/kOhtXi
         GouQy8W3b4iBlGvfnxMiEiWyaDQMHLDCtah0pb/BBhXJ7i5is56Wo2xekA6xa9ShU95R
         GGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/B9HRUb1pN0oeNexgKI/YfWSFYy7wOL5kEV61Po+j/o=;
        b=NCfV5ehnheaNx1R3HGg3Kx4yD4MOPbPTzNKggfrVX+iFD+QubFTrHN1aNldgPfUl8+
         T1PzH+SctwK8f+zDx+YLVLufKPhfQwhmCRuGxcjK37ih+lFt+hgsK1A2iqEwbNw1tHA+
         n5J3P1ggFC8yqWYIWXU87xAK8izAdAuJ3XF5wHRyODlJ91HP1DaOk6tXvYRJdv31OZAu
         IczRzm8DCxa6Oy26/X/q7RbAac7fscEwAOXj6pMndgBXFQrJWUIv+pu50qEbEd2GC9eO
         /txoDZBwhbatuA6Y5++iO4NAsSmQ7YleZCVp4T4k2yDZ292oqMtO8i07ncd4HrD+xCbA
         /aCQ==
X-Gm-Message-State: AGRZ1gIfXu3V7SUJSXpmnIg1e5Pm6K12aeeqofmgCfE6hWyAYjt5dsJK
        KfDjr0dlmXwcpOkIFmj5uhDfW9HTqjMit6ZhWH4=
X-Google-Smtp-Source: AJdET5fPMxQaHOJxsH+8l5KzH8DlnLHNg2qdortwHugy/JvcTqVFbjnfrCPW0vMHf0qsafQxcg41r189FJ1qc8FI5U8=
X-Received: by 2002:a6b:fc03:: with SMTP id r3-v6mr3527943ioh.288.1539973594495;
 Fri, 19 Oct 2018 11:26:34 -0700 (PDT)
MIME-Version: 1.0
References: <104c8823-e867-6244-a528-979482c7fccc@candelatech.com>
In-Reply-To: <104c8823-e867-6244-a528-979482c7fccc@candelatech.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Fri, 19 Oct 2018 11:25:58 -0700
Message-ID: <CALLGbRKOLVg0bLhezLkEA_MPCg_S1L-drJNy3fSWxPJXJV+ajQ@mail.gmail.com>
Subject: Re: Where to report mpdus tx vs failed?
To:     Ben Greear <greearb@candelatech.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 19, 2018 at 10:34 AM Ben Greear <greearb@candelatech.com> wrote:
>
> While debugging rate-ctrl in ath10k, I found the amount of mpdus transmitted vs failed
> ratio useful.  Probably more useful than retries since retries could count an attempt at
> 80Mhz followed by HW trying a 40Mhz rate (afaik).
>
> Is there a good way to report this up the stack in a useful manner?  I currently only
> get this stat for the first frame in an transmitted ampdu.
>

debugfs? Is it useful for someone working on it, like a sysadmin or
kernel programmer?  Or is it useful for programs to know?  In the
first case I'd say debugfs, in the second case I'd suggest it goes in
some tx stats structure that is reported by netlink.

Also, is it something that is given by (or should be given by) all
drivers, or is it very driver-specific?

- Steve
