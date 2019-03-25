Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA91FC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 17:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 718B320879
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 17:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GhODQ4HH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfCYRQs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 13:16:48 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43785 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfCYRQs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 13:16:48 -0400
Received: by mail-lj1-f194.google.com with SMTP id f18so8558154lja.10
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 10:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4xu0x+/qbwZ1qoy5sJh+190MDznz/0ByXWbgtMpGCZA=;
        b=GhODQ4HHvmT/zLtD5PQe9quTjcLb9Y3BEjOIbsa3HBEu11aoX4gNLucgxeqI8qOk2t
         z8KlI8hCvB+g+TnaeDFJIOhcyRjvoElkLyXRW1EnoazNBkwPx783KGoRScE3rG+NfQAY
         x1p5eUcF11yAq+Z7oQazu6cy1fSt0LNKLvQDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4xu0x+/qbwZ1qoy5sJh+190MDznz/0ByXWbgtMpGCZA=;
        b=cv4XAHOZjAFrzOiMeCyIDN0LV788dwfnr1FodL1etP71tiOC/dqfY6a+8wlC9rtaSq
         xkYSUnG1VKiJYHHzpaCq7ru4iBAtbpBhTXfjaNZzQWg2mDaVHmMEJ0N3X/HXzXaKMA3N
         T45fbSj8GodVLDNborz1rAD/FAFHdb3IBpub+/s/lSRnAUBDwQJHgeDnbWNDBrOdrUEO
         5yuXScTqM2xL2L2C4yOwNC09X9Mxf1VwxWSJ2U7vqfM6UFkZCjTUGKjblAxPcAIdT5Lo
         qJ7GLEzaVAD63lPC8DcG4XYwwemvp2gB6WleHLo/0DknLD/FqxwHcoO8ZozCi5MSLpCH
         KHqg==
X-Gm-Message-State: APjAAAV64r9l2xuKtrhRiB381nMUxwt93Qm/3T2KPtamRKNeZM5OXSrD
        k+T3YafaJt26zftnIqzhMQHHLrNXZg4=
X-Google-Smtp-Source: APXvYqzFar1EHD3JEEeHuz+12ptqJ0tkGhdWUc/1ChJzQO8aNMMeZStWLqOWki23Oyn9NvATRXtYzA==
X-Received: by 2002:a2e:3311:: with SMTP id d17mr13534750ljc.165.1553534205591;
        Mon, 25 Mar 2019 10:16:45 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id f16sm3462974lfa.91.2019.03.25.10.16.44
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 10:16:44 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id k8so8557912lja.8
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 10:16:44 -0700 (PDT)
X-Received: by 2002:a2e:b058:: with SMTP id d24mr14765865ljl.42.1553534204018;
 Mon, 25 Mar 2019 10:16:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190320044511.12172-1-govinds@codeaurora.org> <20190320044511.12172-2-govinds@codeaurora.org>
In-Reply-To: <20190320044511.12172-2-govinds@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 25 Mar 2019 10:16:32 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOMt9=bHOp3UrVy7FaPjta_GA70YeQJM3ksFRyoXK=kGw@mail.gmail.com>
Message-ID: <CA+ASDXOMt9=bHOp3UrVy7FaPjta_GA70YeQJM3ksFRyoXK=kGw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt: bindings: add dt entry for XO calibration support
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 19, 2019 at 9:48 PM Govind Singh <govinds@codeaurora.org> wrote:
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -81,6 +81,7 @@ Optional properties:
>         Definition: Name of external front end module used. Some valid FEM names
>                     for example: "microsemi-lx5586", "sky85703-11"
>                     and "sky85803" etc.
> +- xo-cal-data: xo cal offset to be configured in xo trim register.

https://media.readthedocs.org/pdf/devicetree-specification/stable/devicetree-specification.pdf

"2.2.4 Properties
...
Nonstandard property names should specify a unique string prefix, such
as a stock ticker symbol, identifying the name of the company or
organization that defined the property. Examples:
  fsl,channel-fifo-len ibm,ppc-interrupt-server#s
  linux,network-index"

In other words, like most other custom properties in this file, you
should probably have a "qcom," prefix.

Brian

>  Example (to supply PCI based wifi block details):
